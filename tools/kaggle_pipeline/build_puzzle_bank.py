"""
Offline, one-time ETL: turns the two raw Kaggle 9x9 Sudoku datasets into a
capped, deduped, difficulty-bucketed puzzle bank CSV that the Dart seed
script (tools/generate_bank/seed_from_csv.dart) turns into the bundled
SQLite asset.

Usage: python build_puzzle_bank.py
Output: tools/kaggle_pipeline/output/puzzle_bank_9x9.csv
"""

import csv
import os
import random

import kagglehub
import pandas as pd

OUTPUT_DIR = os.path.join(os.path.dirname(__file__), "output")
OUTPUT_CSV = os.path.join(OUTPUT_DIR, "puzzle_bank_9x9.csv")

# clue_count -> difficulty band, per the client's table (9x9 only)
DIFFICULTY_BANDS = [
    ("easy", 36, 46),
    ("normal", 32, 35),
    ("hard", 28, 31),
    ("extraHard", 22, 27),
    ("expert", 17, 21),
]
CAP_PER_BAND = 12000
RNG_SEED = 42


def difficulty_for_clue_count(clue_count):
    for name, lo, hi in DIFFICULTY_BANDS:
        if lo <= clue_count <= hi:
            return name
    return None


def is_valid_complete_grid(solution_str):
    """81-char string of digits 1-9, each row/col/box a permutation of 1-9."""
    if len(solution_str) != 81 or not solution_str.isdigit():
        return False
    grid = [int(c) for c in solution_str]
    if any(v == 0 for v in grid):
        return False
    full = set(range(1, 10))
    for r in range(9):
        if set(grid[r * 9:(r + 1) * 9]) != full:
            return False
    for c in range(9):
        if {grid[r * 9 + c] for r in range(9)} != full:
            return False
    for br in range(3):
        for bc in range(3):
            box = {
                grid[(br * 3 + r) * 9 + (bc * 3 + c)]
                for r in range(3) for c in range(3)
            }
            if box != full:
                return False
    return True


def givens_match_solution(puzzle_str, solution_str):
    return all(p == "0" or p == s for p, s in zip(puzzle_str, solution_str))


def load_rohanrao():
    path = kagglehub.dataset_download("rohanrao/sudoku")
    df = pd.read_csv(os.path.join(path, "sudoku.csv"))
    return df.rename(columns={"quizzes": "puzzle"})[["puzzle", "solution"]]


def load_radcliffe():
    path = kagglehub.dataset_download("radcliffe/3-million-sudoku-puzzles-with-ratings")
    csv_files = [f for f in os.listdir(path) if f.endswith(".csv")]
    frames = []
    for f in csv_files:
        df = pd.read_csv(os.path.join(path, f))
        cols = {c.lower(): c for c in df.columns}
        puzzle_col = cols.get("puzzle") or cols.get("quizzes")
        solution_col = cols.get("solution") or cols.get("solutions")
        if puzzle_col and solution_col:
            frames.append(df.rename(columns={puzzle_col: "puzzle", solution_col: "solution"})[["puzzle", "solution"]])
    return pd.concat(frames, ignore_index=True) if frames else pd.DataFrame(columns=["puzzle", "solution"])


def main():
    os.makedirs(OUTPUT_DIR, exist_ok=True)
    random.seed(RNG_SEED)

    print("Loading rohanrao/sudoku ...")
    df_a = load_rohanrao()
    print(f"  {len(df_a)} rows")

    print("Loading radcliffe/3-million-sudoku-puzzles-with-ratings ...")
    df_b = load_radcliffe()
    print(f"  {len(df_b)} rows")

    combined = pd.concat([df_a, df_b], ignore_index=True)
    combined["puzzle"] = combined["puzzle"].astype(str).str.strip()
    combined["solution"] = combined["solution"].astype(str).str.strip()
    print(f"Combined: {len(combined)} rows")

    combined = combined.drop_duplicates(subset=["puzzle"])
    print(f"After dedupe on puzzle string: {len(combined)} rows")

    buckets = {name: [] for name, _, _ in DIFFICULTY_BANDS}
    seen_invalid = 0

    for puzzle, solution in zip(combined["puzzle"], combined["solution"]):
        if len(puzzle) != 81 or len(solution) != 81:
            seen_invalid += 1
            continue
        if not is_valid_complete_grid(solution):
            seen_invalid += 1
            continue
        if not givens_match_solution(puzzle, solution):
            seen_invalid += 1
            continue

        clue_count = sum(1 for c in puzzle if c != "0")
        difficulty = difficulty_for_clue_count(clue_count)
        if difficulty is None:
            continue

        bucket = buckets[difficulty]
        if len(bucket) < CAP_PER_BAND * 3:  # keep a bit of headroom pre-shuffle
            bucket.append((clue_count, puzzle, solution))

    print(f"Dropped {seen_invalid} malformed/inconsistent rows")

    with open(OUTPUT_CSV, "w", newline="") as f:
        writer = csv.writer(f)
        writer.writerow(["grid_size", "difficulty", "clue_count", "puzzle", "solution", "source"])
        total = 0
        for name, _, _ in DIFFICULTY_BANDS:
            rows = buckets[name]
            random.shuffle(rows)
            rows = rows[:CAP_PER_BAND]
            for clue_count, puzzle, solution in rows:
                # '|'-joined (not ',') so these fields never collide with the
                # CSV's own comma delimiter — no quoting ambiguity to worry
                # about on the Dart-side reader.
                puzzle_csv = "|".join(puzzle)
                solution_csv = "|".join(solution)
                writer.writerow([9, name, clue_count, puzzle_csv, solution_csv, "kaggle"])
            print(f"  {name}: {len(rows)} puzzles")
            total += len(rows)

    print(f"Wrote {total} puzzles to {OUTPUT_CSV}")


if __name__ == "__main__":
    main()
