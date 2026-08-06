import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../profile/data/profile_repository.dart';

extension UserProfileInputMapper on User {
  UserProfileInput toProfileInput() => UserProfileInput(
        uid: uid,
        isAnonymous: isAnonymous,
        displayName: displayName,
        photoUrl: photoURL,
        email: email,
      );
}

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(firebaseAuthProvider).authStateChanges();
});

class AuthController {
  AuthController(this._auth);

  final FirebaseAuth _auth;
  bool _googleSignInInitialized = false;

  Future<void> _ensureGoogleSignInInitialized() async {
    if (_googleSignInInitialized) return;
    await GoogleSignIn.instance.initialize();
    _googleSignInInitialized = true;
  }

  /// Called once at app startup. Guarantees there's always a signed-in user
  /// (anonymous if nothing else) so gameplay never requires an account —
  /// matches sudoku.com's no-signup-wall UX.
  Future<User> ensureSignedIn() async {
    final current = _auth.currentUser;
    if (current != null) return current;
    final credential = await _auth.signInAnonymously();
    return credential.user!;
  }

  /// Upgrades the current (typically anonymous) session to a Google account
  /// via linkWithCredential, preserving the uid and any data already
  /// attached to it. If that Google account already belongs to a different
  /// Firebase user (e.g. signed in previously on another device), falls
  /// back to signing into that existing account instead — the standard
  /// resolution for that conflict.
  Future<User> signInWithGoogle() async {
    await _ensureGoogleSignInInitialized();
    final account = await GoogleSignIn.instance.authenticate();
    final idToken = account.authentication.idToken;
    if (idToken == null) {
      throw StateError('Google sign-in did not return an ID token.');
    }
    final credential = GoogleAuthProvider.credential(idToken: idToken);

    final current = _auth.currentUser;
    if (current != null && current.isAnonymous) {
      try {
        final result = await current.linkWithCredential(credential);
        return result.user!;
      } on FirebaseAuthException catch (e) {
        if (e.code != 'credential-already-in-use') rethrow;
        // The Google account is already tied to a different Firebase user
        // (e.g. this person played as guest here but has an existing
        // account from another device) — fall through to adopt it.
      }
    }

    final result = await _auth.signInWithCredential(credential);
    return result.user!;
  }

  Future<void> signOut() async {
    await GoogleSignIn.instance.signOut();
    await _auth.signOut();
  }
}

final authControllerProvider = Provider<AuthController>((ref) {
  return AuthController(ref.watch(firebaseAuthProvider));
});
