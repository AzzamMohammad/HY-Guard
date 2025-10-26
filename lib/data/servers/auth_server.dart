import 'package:firebase_auth/firebase_auth.dart';
import 'package:hy_guard/data/exceptions/server_exception.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthServer {
  late final FirebaseAuth _firebaseAuthInstance;

  AuthServer() {
    _firebaseAuthInstance = FirebaseAuth.instance;
  }

  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String userName,
  }) async {
    try {
      final UserCredential user = await _firebaseAuthInstance
          .createUserWithEmailAndPassword(email: email, password: password);
      await user.user?.updateDisplayName(userName);
    } on FirebaseAuthException catch (error) {
      throw ServerException(error.code, error.message);
    }
  }

  Future<void> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuthInstance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (error) {
      throw ServerException(error.code, error.message);
    }
  }

  Future<void> signUserWithGoogleAccount({
    required GoogleSignInAuthentication googleAuth,
  }) async {
    try {
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );
      await _firebaseAuthInstance.signInWithCredential(credential);
    } on FirebaseAuthException catch (error) {
      throw ServerException(error.code, error.message);
    }
  }

  Future<void> reloadUserInfo(User user) async {
    try {
      await user.reload();
    } on FirebaseAuthException catch (error) {
      throw ServerException(error.code, error.message);
    }
  }

  Future<void> resetUserPassword(String recoveryEmail) async {
    try {
      await _firebaseAuthInstance.sendPasswordResetEmail(email: recoveryEmail);
    } on FirebaseAuthException catch (error) {
      throw ServerException(error.code, error.message);
    }
  }
}
