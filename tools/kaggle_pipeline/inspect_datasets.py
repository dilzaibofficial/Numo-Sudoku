import kagglehub
import pandas as pd
import os

for slug in ["rohanrao/sudoku", "radcliffe/3-million-sudoku-puzzles-with-ratings"]:
    print(f"\n=== {slug} ===")
    path = kagglehub.dataset_download(slug)
    print("Downloaded to:", path)
    for f in os.listdir(path):
        print(" -", f)
        full = os.path.join(path, f)
        if f.endswith(".csv"):
            df = pd.read_csv(full, nrows=5)
            print("   columns:", list(df.columns))
            print(df.head(2).to_string())
