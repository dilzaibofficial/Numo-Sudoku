import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The subset of `firebase_auth`'s `User` that profile sync actually needs.
/// Keeping the data layer decoupled from the auth SDK's `User` type (which
/// isn't a plain data class and can't be constructed in tests without a
/// real FirebaseAuth instance) makes this trivially testable.
class UserProfileInput {
  const UserProfileInput({
    required this.uid,
    required this.isAnonymous,
    this.displayName,
    this.photoUrl,
    this.email,
  });

  final String uid;
  final bool isAnonymous;
  final String? displayName;
  final String? photoUrl;
  final String? email;
}

class ProfileRepository {
  ProfileRepository(this._firestore);

  final FirebaseFirestore _firestore;

  DocumentReference<Map<String, dynamic>> _userDoc(String uid) =>
      _firestore.collection('users').doc(uid);

  /// Creates the user's profile doc on first sign-in, or refreshes display
  /// info on subsequent calls (e.g. after a guest -> Google upgrade, once
  /// displayName/photoUrl become available).
  Future<void> ensureProfile(UserProfileInput user) async {
    final doc = _userDoc(user.uid);
    final snapshot = await doc.get();
    if (!snapshot.exists) {
      await doc.set({
        'displayName': user.displayName ?? 'Player',
        'photoUrl': user.photoUrl,
        'email': user.email,
        'isAnonymous': user.isAnonymous,
        'createdAt': FieldValue.serverTimestamp(),
        'stats': {'gamesPlayed': 0, 'gamesWon': 0},
        'friendUids': <String>[],
      });
    } else {
      await doc.update({
        'displayName': user.displayName ?? snapshot.data()?['displayName'] ?? 'Player',
        'photoUrl': user.photoUrl,
        'email': user.email,
        'isAnonymous': user.isAnonymous,
      });
    }
  }

  Future<void> recordGameResult({required String uid, required bool won}) {
    return _userDoc(uid).update({
      'stats.gamesPlayed': FieldValue.increment(1),
      if (won) 'stats.gamesWon': FieldValue.increment(1),
    });
  }
}

final firestoreProvider = Provider<FirebaseFirestore>((ref) => FirebaseFirestore.instance);

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepository(ref.watch(firestoreProvider));
});
