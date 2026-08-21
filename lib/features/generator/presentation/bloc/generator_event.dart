part of 'generator_bloc.dart';

abstract class GeneratorEvent extends Equatable {
  const GeneratorEvent();
  @override
  List<Object> get props => [];
}

class GeneratePassword extends GeneratorEvent {}

class UpdateOptions extends GeneratorEvent {
  final int length;
  const UpdateOptions(this.length);
  @override
  List<Object> get props => [length];
}
