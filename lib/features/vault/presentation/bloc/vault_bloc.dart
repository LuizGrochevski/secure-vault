import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:secure_vault/features/vault/data/vault_repository.dart';
import 'package:secure_vault/features/vault/domain/entities/vault_entry.dart';

part 'vault_event.dart';
part 'vault_state.dart';

class VaultBloc extends Bloc<VaultEvent, VaultState> {
  final VaultRepository _repo = VaultRepository();

  VaultBloc() : super(VaultInitial()) {
    on<LoadEntries>(_onLoad);
    on<AddEntry>(_onAdd);
    on<UpdateEntry>(_onUpdate);
    on<DeleteEntry>(_onDelete);
  }

  Future<void> _onLoad(LoadEntries event, Emitter<VaultState> emit) async {
    emit(VaultLoading());
    try {
      await _repo.init();
      final entries = await _repo.getEntries();
      emit(VaultLoaded(entries));
    } catch (e) {
      emit(VaultError(e.toString()));
    }
  }

  Future<void> _onAdd(AddEntry event, Emitter<VaultState> emit) async {
    try {
      await _repo.addEntry(
        title: event.title,
        username: event.username,
        password: event.password,
        url: event.url,
        notes: event.notes,
      );
      add(LoadEntries());
    } catch (e) {
      emit(VaultError(e.toString()));
    }
  }

  Future<void> _onUpdate(UpdateEntry event, Emitter<VaultState> emit) async {
    try {
      await _repo.updateEntry(event.entry);
      add(LoadEntries());
    } catch (e) {
      emit(VaultError(e.toString()));
    }
  }

  Future<void> _onDelete(DeleteEntry event, Emitter<VaultState> emit) async {
    try {
      await _repo.deleteEntry(event.id);
      add(LoadEntries());
    } catch (e) {
      emit(VaultError(e.toString()));
    }
  }
}
