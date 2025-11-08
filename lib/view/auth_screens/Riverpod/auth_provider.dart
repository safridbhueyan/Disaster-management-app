import 'package:dissaster_mgmnt_app/view/home_screen/riverpod/sos_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/legacy.dart';

/// Provides the FirebaseAuth instance
final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

/// Stream provider to watch the auth state (login/logout)
final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(firebaseAuthProvider).authStateChanges();
});

/// StateNotifierProvider for authentication controller
final authControllerProvider =
    StateNotifierProvider<AuthController, AsyncValue<User?>>((ref) {
      final auth = ref.watch(firebaseAuthProvider);
      return AuthController(auth);
    });

/// AuthController handles signup, signin, and signout logic
class AuthController extends StateNotifier<AsyncValue<User?>> {
  final FirebaseAuth _auth;

  AuthController(this._auth) : super(const AsyncValue.data(null));

  /// 🔹 Sign In existing user
  Future<void> signIn(String email, String password) async {
    try {
      state = const AsyncValue.loading();
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // ✅ Save FCM token to Firestore after successful login
      await saveUserToken();

      print("✅ User signed in successfully: ${credential.user?.email}");
      state = AsyncValue.data(credential.user);
    } on FirebaseAuthException catch (e) {
      print("⚠️ Sign in failed: ${e.message}");
      state = AsyncValue.error(
        e.message ?? 'Sign in failed',
        StackTrace.current,
      );
    } catch (e) {
      print("⚠️ Unexpected error during sign in: $e");
      state = AsyncValue.error(e.toString(), StackTrace.current);
    }
  }

  /// 🔹 Sign Up new user
  Future<void> signUp(String email, String password, String name) async {
    try {
      state = const AsyncValue.loading();
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await credential.user?.updateDisplayName(name);
      await credential.user?.reload();

      // ✅ Save FCM token to Firestore after successful signup
      await saveUserToken();

      print("✅ User signed up successfully: ${credential.user?.email}");
      state = AsyncValue.data(credential.user);
    } on FirebaseAuthException catch (e) {
      print("⚠️ Sign up failed: ${e.message}");
      state = AsyncValue.error(
        e.message ?? 'Sign up failed',
        StackTrace.current,
      );
    } catch (e) {
      print("⚠️ Unexpected error during sign up: $e");
      state = AsyncValue.error(e.toString(), StackTrace.current);
    }
  }

  /// 🔹 Sign Out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      print("👋 User signed out");
      state = const AsyncValue.data(null);
    } catch (e) {
      print("⚠️ Sign out failed: $e");
      state = AsyncValue.error(e.toString(), StackTrace.current);
    }
  }
}
