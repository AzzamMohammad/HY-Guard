part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class CreateUserSuccessState extends AuthState {}

final class UserLoginSuccessState extends AuthState {}

final class AnErrorHappenState extends AuthState {
  final String? errorMessage;

  AnErrorHappenState({this.errorMessage});
}

final class AuthenticatedState extends AuthState {}

final class UnauthenticatedState extends AuthState {}

final class PasswordResetEmailSentState extends AuthState {}
