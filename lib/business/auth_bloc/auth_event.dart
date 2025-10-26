part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

final class SignUpWithEmailEvent extends AuthEvent {
  late final String email;
  late final String password;
  late final String userName;

  SignUpWithEmailEvent({
    required this.email,
    required this.password,
    required this.userName,
  });
}

final class LoginWithEmailEvent extends AuthEvent {
  late final String email;
  late final String password;

  LoginWithEmailEvent({required this.email, required this.password});
}

final class SignUpWithGoogleEvent extends AuthEvent {}

final class SignInWithGoogleEvent extends AuthEvent {}

final class AppStartedEvent extends AuthEvent {}

final class RequestPasswordResetEmailEvent extends AuthEvent {
  late final String recoveryEmail;

  RequestPasswordResetEmailEvent({required this.recoveryEmail});
}
