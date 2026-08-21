part of 'vault_bloc.dart';

abstract class VaultEvent extends Equatable {
  const VaultEvent();
  @override
  List<Object?> get props => [];
}

class LoadEntries extends VaultEvent {}

class AddEntry extends VaultEvent {
  final String title;
  final String username;
  final String password;
  final String? url;
  final String? notes;

  const AddEntry({
    required this.title,
    required this.username,
    required this.password,
    this.url,
    this.notes,
  });

  @override
  List<Object?> get props => [title, username, password, url, notes];
}

class UpdateEntry extends VaultEvent {
  final VaultEntry entry;
  const UpdateEntry(this.entry);
  @override
  List<Object?> get props => [entry];
}

class DeleteEntry extends VaultEvent {
  final String id;
  const DeleteEntry(this.id);
  @override
  List<Object?> get props => [id];
}
