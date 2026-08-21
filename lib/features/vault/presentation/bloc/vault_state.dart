part of 'vault_bloc.dart';

abstract class VaultState extends Equatable {
  const VaultState();
  @override
  List<Object> get props => [];
}

class VaultInitial extends VaultState {}

class VaultLoading extends VaultState {}

class VaultLoaded extends VaultState {
  final List<VaultEntry> entries;
  const VaultLoaded(this.entries);
  @override
  List<Object> get props => [entries];
}

class VaultError extends VaultState {
  final String message;
  const VaultError(this.message);
  @override
  List<Object> get props => [message];
}
