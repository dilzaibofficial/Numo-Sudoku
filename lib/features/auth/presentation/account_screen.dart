import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../profile/data/profile_repository.dart';
import '../application/auth_controller.dart';

class AccountScreen extends ConsumerStatefulWidget {
  const AccountScreen({super.key});

  @override
  ConsumerState<AccountScreen> createState() => _AccountScreenState();
}

enum _EmailMode { signIn, register }

class _AccountScreenState extends ConsumerState<AccountScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _busy = false;
  bool _showEmailForm = false;
  _EmailMode _emailMode = _EmailMode.signIn;
  String? _error;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _run(Future<User> Function() action) async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final user = await action();
      await ref.read(profileRepositoryProvider).ensureProfile(user.toProfileInput());
      if (mounted) setState(() => _showEmailForm = false);
    } on FirebaseAuthException catch (e) {
      setState(() => _error = _messageFor(e.code));
    } catch (_) {
      setState(() => _error = 'Something went wrong. Please try again.');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _signInWithGoogle() =>
      _run(() => ref.read(authControllerProvider).signInWithGoogle());

  Future<void> _submitEmailForm() async {
    if (!_formKey.currentState!.validate()) return;
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    await _run(() => _emailMode == _EmailMode.register
        ? ref.read(authControllerProvider).registerWithEmail(email, password)
        : ref.read(authControllerProvider).signInWithEmail(email, password));
  }

  Future<void> _signOut() async {
    setState(() => _busy = true);
    await ref.read(authControllerProvider).signOut();
    await ref.read(authControllerProvider).ensureSignedIn();
    if (mounted) setState(() => _busy = false);
  }

  String _messageFor(String code) {
    switch (code) {
      case 'invalid-email':
        return 'That email address looks invalid.';
      case 'user-not-found':
        return 'No account found for that email.';
      case 'wrong-password':
      case 'invalid-credential':
        return 'Incorrect email or password.';
      case 'email-already-in-use':
        return 'That email is already registered — try signing in instead.';
      case 'weak-password':
        return 'Password should be at least 6 characters.';
      case 'network-request-failed':
        return 'No internet connection.';
      default:
        return 'Sign-in failed ($code).';
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Account')),
      body: Center(
        child: authState.when(
          loading: () => const CircularProgressIndicator(),
          error: (err, _) => Text('Something went wrong: $err'),
          data: (user) => SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage:
                      user?.photoURL != null ? NetworkImage(user!.photoURL!) : null,
                  child: user?.photoURL == null
                      ? const Icon(Icons.person, size: 40)
                      : null,
                ),
                const SizedBox(height: 16),
                Text(
                  _titleFor(user),
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  user == null || user.isAnonymous
                      ? 'Playing as guest — progress stays on this device only.'
                      : 'Signed in — your progress syncs across devices.',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                if (_error != null) ...[
                  Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
                  const SizedBox(height: 12),
                ],
                if (_busy)
                  const CircularProgressIndicator()
                else if (user == null || user.isAnonymous) ...[
                  SizedBox(
                    width: 260,
                    child: FilledButton.icon(
                      onPressed: _signInWithGoogle,
                      icon: const Icon(Icons.login),
                      label: const Text('Sign in with Google'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: 260,
                    child: OutlinedButton.icon(
                      onPressed: () => setState(() => _showEmailForm = !_showEmailForm),
                      icon: const Icon(Icons.email_outlined),
                      label: const Text('Use email instead'),
                    ),
                  ),
                  if (_showEmailForm) _EmailForm(
                    formKey: _formKey,
                    emailController: _emailController,
                    passwordController: _passwordController,
                    mode: _emailMode,
                    onModeChanged: (mode) => setState(() => _emailMode = mode),
                    onSubmit: _submitEmailForm,
                  ),
                ] else
                  OutlinedButton.icon(
                    onPressed: _signOut,
                    icon: const Icon(Icons.logout),
                    label: const Text('Sign out'),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _titleFor(User? user) {
    if (user == null || user.isAnonymous) return 'Guest';
    return user.displayName ?? user.email ?? 'Signed in';
  }
}

class _EmailForm extends StatelessWidget {
  const _EmailForm({
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.mode,
    required this.onModeChanged,
    required this.onSubmit,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final _EmailMode mode;
  final ValueChanged<_EmailMode> onModeChanged;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            SegmentedButton<_EmailMode>(
              segments: const [
                ButtonSegment(value: _EmailMode.signIn, label: Text('Sign in')),
                ButtonSegment(value: _EmailMode.register, label: Text('Create account')),
              ],
              selected: {mode},
              onSelectionChanged: (selection) => onModeChanged(selection.first),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
              validator: (value) =>
                  (value == null || !value.contains('@')) ? 'Enter a valid email' : null,
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: passwordController,
              obscureText: true,
              decoration:
                  const InputDecoration(labelText: 'Password', border: OutlineInputBorder()),
              validator: (value) =>
                  (value == null || value.length < 6) ? 'At least 6 characters' : null,
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: 260,
              child: FilledButton(
                onPressed: onSubmit,
                child: Text(mode == _EmailMode.register ? 'Create account' : 'Sign in'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
