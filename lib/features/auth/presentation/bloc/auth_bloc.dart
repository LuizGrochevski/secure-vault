import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:local_auth/local_auth.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LocalAuthentication _localAuth = LocalAuthentication();

  AuthBloc() : super(AuthInitial()) {
    on<CheckAuthStatus>(_onCheck);
    on<AuthenticateWithBiometrics>(_onAuthenticate);
    on<Logout>(_onLogout);
  }

  Future<void> _onCheck(CheckAuthStatus event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final canCheck = await _localAuth.canCheckBiometrics;
    emit(canCheck ? AuthUnauthenticated() : AuthUnsupported());
  }

  Future<void> _onAuthenticate(
      AuthenticateWithBiometrics event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final didAuth = await _localAuth.authenticate(
        localizedReason: 'Desbloqueie o Secure Vault',
        options: const AuthenticationOptions(biometricOnly: true),
      );
      emit(didAuth ? AuthAuthenticated() : AuthUnauthenticated());
    } catch (e) {
      print('Erro biometria: $e');
      emit(const AuthError('Falha na autenticação biométrica'));
    }
  }

  void _onLogout(Logout event, Emitter<AuthState> emit) {
    emit(AuthUnauthenticated());
  }
}
