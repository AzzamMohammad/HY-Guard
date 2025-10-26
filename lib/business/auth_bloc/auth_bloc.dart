import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hy_guard/core/utils/either.dart';
import 'package:meta/meta.dart';
import '../../data/repositories/auth_repository.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository = AuthRepository();

  AuthBloc() : super(AuthInitial()) {
    on<SignUpWithEmailEvent>(_onSignUpWithEmail);
    on<LoginWithEmailEvent>(_onLoginWithEmail);
    on<SignUpWithGoogleEvent>(_onSignUpWithGoogle);
    on<SignInWithGoogleEvent>(_onSignInWithGoogle);
    on<AppStartedEvent>(_onAuthStarted);
    on<RequestPasswordResetEmailEvent>(_onUserResetHisPassword);
  }

  Future<void> _onSignUpWithEmail(
    SignUpWithEmailEvent event,
    Emitter<AuthState> emit,
  ) async {
    // submit user info
    Either<String?, bool> result = await _authRepository.signUpWithEmail(
      email: event.email,
      password: event.password,
      userName: event.userName,
    );
    // case user created successfully
    if (result.isRight) {
      emit(CreateUserSuccessState());
    } else {
      // case an error happened
      final String? errorMessage = result.fold((lef) => lef, (rig) => null);
      emit(AnErrorHappenState(errorMessage: errorMessage));
    }
  }

  Future<void> _onLoginWithEmail(
    LoginWithEmailEvent event,
    Emitter<AuthState> emit,
  ) async {
    // submit user info
    Either<String?, bool> result = await _authRepository.loginWithEmail(
      email: event.email,
      password: event.password,
    );
    // case user login successfully
    if (result.isRight) {
      emit(UserLoginSuccessState());
    } else {
      // case an error happened
      final String? errorMessage = result.fold((lef) => lef, (rig) => null);
      emit(AnErrorHappenState(errorMessage: errorMessage));
    }
  }

  Future<void> _onSignUpWithGoogle(
    SignUpWithGoogleEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final GoogleSignInAuthentication googleAuth = await _initGoogleAuth();
      Either<String?, bool> result = await _authRepository
          .signUpWithGoogleAccount(googleAuth: googleAuth);
      if (result.isRight) {
        emit(CreateUserSuccessState());
      } else {
        final String? errorMessage = result.fold((l) => l, (r) => null);
        emit(AnErrorHappenState(errorMessage: errorMessage));
      }
    } catch (error) {
      // an error happen in init google auth
      emit(AnErrorHappenState());
    }
  }

  Future<void> _onSignInWithGoogle(
    SignInWithGoogleEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final GoogleSignInAuthentication googleAuth = await _initGoogleAuth();
      Either<String?, bool> result = await _authRepository
          .signInWithGoogleAccount(googleAuth: googleAuth);
      if (result.isRight) {
        emit(UserLoginSuccessState());
      } else {
        final String? errorMessage = result.fold((l) => l, (r) => null);
        emit(AnErrorHappenState(errorMessage: errorMessage));
      }
    } catch (error) {
      // an error happen in init google auth
      emit(AnErrorHappenState());
    }
  }

  /// Initialize and authenticate with Google Sign-In
  Future<GoogleSignInAuthentication> _initGoogleAuth() async {
    // This is the Web Client ID (serverClientId) obtained from Firebase/Google Cloud Console
    final String serverClientId = dotenv.env['GOOGLE_SERVER_CLIENT_ID'] ?? "";
    // Initialize GoogleSignIn with the provided serverClientId
    GoogleSignIn.instance.initialize(serverClientId: serverClientId);
    // Open Google account chooser dialog (user selects an account)
    final GoogleSignInAccount googleUser = await GoogleSignIn.instance
        .authenticate();
    // Retrieve authentication details (AccessToken + IdToken) from the selected account
    final GoogleSignInAuthentication googleAuth = googleUser.authentication;
    return googleAuth;
  }

  Future<void> _onAuthStarted(
    AppStartedEvent event,
    Emitter<AuthState> emit,
  ) async {
    // Shows a delay (for splash screen / presentation purposes)
    await Future.delayed(Duration(milliseconds: 2500));
    final User? user = FirebaseAuth.instance.currentUser;
    // Checks if a user is already signed in with Firebase
    if (user != null) {
      // Reloads the user's information from Firebase to ensure it's up to date
      Either<String?, bool> result = await _authRepository.reloadUserInfo(user);
      // user info reloaded successfully
      if (result.isRight) {
        final User? updatedUser = FirebaseAuth.instance.currentUser;
        if (updatedUser == null) {
          // Emits `Authenticated` if the user is still valid after reload
          emit(UnauthenticatedState());
        } else {
          // Emits `Unauthenticated` if the reload results in no user
          emit(AuthenticatedState());
        }
      } else {
        // Emits `AnErrorHappen` if the user info reload fails
        emit(AnErrorHappenState());
      }
    } else {
      // If no user exists at the start, emits `Unauthenticated`
      emit(UnauthenticatedState());
    }
  }

  Future<void> _onUserResetHisPassword(
    RequestPasswordResetEmailEvent event,
    Emitter<AuthState> emit,
  ) async {
    Either<String?, bool> result = await _authRepository.resetUserPassword(
      event.recoveryEmail,
    );
    if (result.isRight) {
      emit(PasswordResetEmailSentState());
    } else {
      final String? errorMessage = result.fold(
        (message) => message,
        (_) => null,
      );
      emit(AnErrorHappenState(errorMessage: errorMessage));
    }
  }
}
