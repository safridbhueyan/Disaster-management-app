import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/legacy.dart';

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(firebaseAuthProvider).authStateChanges();
});

final authControllerProvider =
    StateNotifierProvider<AuthController, AsyncValue<User?>>((ref) {
      final auth = ref.watch(firebaseAuthProvider);
      return AuthController(auth);
    });

class AuthController extends StateNotifier<AsyncValue<User?>> {
  final FirebaseAuth _auth;

  AuthController(this._auth) : super(const AsyncValue.data(null));

  Future<void> signIn(String email, String password) async {
    try {
      state = const AsyncValue.loading();
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      state = AsyncValue.data(credential.user);
    } on FirebaseAuthException catch (e) {
      state = AsyncValue.error(
        e.message ?? 'Sign in failed',
        StackTrace.current,
      );
    }
  }

  Future<void> signUp(String email, String password, String name) async {
    try {
      state = const AsyncValue.loading();
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await credential.user?.updateDisplayName(name);
      await credential.user?.reload();

      state = AsyncValue.data(credential.user);
    } on FirebaseAuthException catch (e) {
      state = AsyncValue.error(
        e.message ?? 'Sign up failed',
        StackTrace.current,
      );
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    state = const AsyncValue.data(null);
  }
}
