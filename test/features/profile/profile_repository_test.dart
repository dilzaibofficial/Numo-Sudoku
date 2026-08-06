import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:numo_sudoku/features/profile/data/profile_repository.dart';

void main() {
  group('ProfileRepository', () {
    late FakeFirebaseFirestore firestore;
    late ProfileRepository repository;

    setUp(() {
      firestore = FakeFirebaseFirestore();
      repository = ProfileRepository(firestore);
    });

    test('ensureProfile creates a new doc with default stats for a first-time user', () async {
      const user = UserProfileInput(
        uid: 'uid1',
        isAnonymous: true,
        displayName: null,
        photoUrl: null,
        email: null,
      );

      await repository.ensureProfile(user);

      final doc = await firestore.collection('users').doc('uid1').get();
      expect(doc.exists, isTrue);
      expect(doc.data()!['displayName'], 'Player');
      expect(doc.data()!['isAnonymous'], isTrue);
      expect(doc.data()!['stats'], {'gamesPlayed': 0, 'gamesWon': 0});
      expect(doc.data()!['friendUids'], isEmpty);
    });

    test('ensureProfile does not reset stats or friends on a returning user', () async {
      const user = UserProfileInput(uid: 'uid2', isAnonymous: true);
      await repository.ensureProfile(user);
      await repository.recordGameResult(uid: 'uid2', won: true);

      // Simulate the same user signing in again later.
      await repository.ensureProfile(user);

      final doc = await firestore.collection('users').doc('uid2').get();
      expect(doc.data()!['stats']['gamesPlayed'], 1);
      expect(doc.data()!['stats']['gamesWon'], 1);
    });

    test('ensureProfile upgrades display info after a guest -> Google upgrade', () async {
      const guest = UserProfileInput(uid: 'uid3', isAnonymous: true);
      await repository.ensureProfile(guest);

      const upgraded = UserProfileInput(
        uid: 'uid3',
        isAnonymous: false,
        displayName: 'Zaib',
        photoUrl: 'https://example.com/photo.png',
        email: 'zaib@example.com',
      );
      await repository.ensureProfile(upgraded);

      final doc = await firestore.collection('users').doc('uid3').get();
      expect(doc.data()!['displayName'], 'Zaib');
      expect(doc.data()!['isAnonymous'], isFalse);
      expect(doc.data()!['email'], 'zaib@example.com');
    });

    test('recordGameResult increments gamesPlayed always, gamesWon only on a win', () async {
      const user = UserProfileInput(uid: 'uid4', isAnonymous: true);
      await repository.ensureProfile(user);

      await repository.recordGameResult(uid: 'uid4', won: false);
      await repository.recordGameResult(uid: 'uid4', won: true);
      await repository.recordGameResult(uid: 'uid4', won: true);

      final doc = await firestore.collection('users').doc('uid4').get();
      expect(doc.data()!['stats']['gamesPlayed'], 3);
      expect(doc.data()!['stats']['gamesWon'], 2);
    });
  });
}
