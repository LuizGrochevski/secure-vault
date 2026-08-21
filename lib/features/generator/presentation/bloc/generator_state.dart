part of 'generator_bloc.dart';

class GeneratorState extends Equatable {
  final String password;
  final int length;

  const GeneratorState({
    this.password = '',
    this.length = 16,
  });

  GeneratorState copyWith({String? password, int? length}) {
    return GeneratorState(
      password: password ?? this.password,
      length: length ?? this.length,
    );
  }

  @override
  List<Object> get props => [password, length];
}
