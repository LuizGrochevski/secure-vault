part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object> get props => [];
}

class CheckAuthStatus extends AuthEvent {}

class AuthenticateWithBiometrics extends AuthEvent {}

class Logout extends AuthEvent {}
