import 'package:firebase_auth/firebase_auth.dart';
import 'package:hy_guard/data/exceptions/server_exception.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../core/utils/either.dart';
import '../servers/auth_server.dart';

class AuthRepository {
  late final AuthServer _authServer;

  AuthRepository() {
    _authServer = AuthServer();
  }

  Future<Either<String?, bool>> signUpWithEmail({
    required String email,
    required String password,
    required String userName,
  }) async {
    try {
      await _authServer.createUserWithEmailAndPassword(
        email: email,
        password: password,
        userName: userName,
      );
      //create user successfully
      return const Right(true);
    } on ServerException catch (error) {
      // can not create user
      return Left(error.message);
    }
  }

  Future<Either<String?, bool>> loginWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      await _authServer.loginWithEmailAndPassword(
        email: email,
        password: password,
      );
      //user login successfully
      return const Right(true);
    } on ServerException catch (error) {
      // can not login
      return Left(error.message);
    }
  }

  Future<Either<String?, bool>> signUpWithGoogleAccount({
    required GoogleSignInAuthentication googleAuth,
  }) async {
    try {
      await _authServer.signUserWithGoogleAccount(googleAuth: googleAuth);
      return const Right(true);
    } on ServerException catch (error) {
      // can not signup
      return Left(error.message);
    }
  }

  Future<Either<String?, bool>> signInWithGoogleAccount({
    required GoogleSignInAuthentication googleAuth,
  }) async {
    try {
      await _authServer.signUserWithGoogleAccount(googleAuth: googleAuth);
      return const Right(true);
    } on ServerException catch (error) {
      // can not signup
      return Left(error.message);
    }
  }

  Future<Either<String?, bool>> reloadUserInfo(User user) async {
    try {
      await _authServer.reloadUserInfo(user);
      return const Right(true);
    } on ServerException catch (error) {
      return Left(error.message);
    }
  }

  Future<Either<String?, bool>> resetUserPassword(String recoveryEmail) async {
    try {
      await _authServer.resetUserPassword(recoveryEmail);
      return Right(true);
    } on ServerException catch (error) {
      return Left(error.message);
    }
  }
}
