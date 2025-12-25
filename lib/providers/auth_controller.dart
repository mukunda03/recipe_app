import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_app/models/app_user.dart';
import 'package:recipe_app/providers/firebase_auth_provider.dart';
import 'package:recipe_app/providers/firestore_provider.dart';

class AuthController extends StateNotifier<bool> {
  final Ref ref;
  AuthController(this.ref) : super(false);

  //Register
  Future<void> register({
    required String email,
    required String password,
    required String fullName,
    required String phone,
  }) async {
    state = true; //bca loading on
    try {
      final userCredential = await ref
          .read(firebaseAuthProvider)
          .createUserWithEmailAndPassword(email: email, password: password);

      final uid = userCredential.user!.uid;

      final user = AppUser(
        uid: uid,
        email: email,
        fullName: fullName,
        phone: phone,
      );

      await ref
          .read(firestoreProvider)
          .collection('users')
          .doc(uid)
          .set(user.toMap());
    } finally {
      state = false; // loading off
    }
  }

  //login
  Future<void> login({required String email, required String password}) async {
    state = true;
    try {
      await ref
          .read(firebaseAuthProvider)
          .signInWithEmailAndPassword(email: email, password: password);
    } finally {
      state = false;
    }
  }

  //logOut
  Future<void> logout() async {
    await ref.read(firebaseAuthProvider).signOut();
  }
}

/// Provider Creation
final authControllerProvider = StateNotifierProvider<AuthController, bool>((
  ref,
) {
  return AuthController(ref);
});
