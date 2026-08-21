import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'generator_event.dart';
part 'generator_state.dart';

class GeneratorBloc extends Bloc<GeneratorEvent, GeneratorState> {
  GeneratorBloc() : super(const GeneratorState()) {
    on<GeneratePassword>(_onGenerate);
    on<UpdateOptions>(_onUpdateOptions);
  }

  void _onGenerate(GeneratePassword event, Emitter<GeneratorState> emit) {
    const chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#\$%^&*()_+-=[]{}|;:,.<>?';
    final random = Random.secure();
    final password = List.generate(
      state.length,
      (_) => chars[random.nextInt(chars.length)],
    ).join();
    emit(state.copyWith(password: password));
  }

  void _onUpdateOptions(UpdateOptions event, Emitter<GeneratorState> emit) {
    emit(state.copyWith(length: event.length));
  }
}
