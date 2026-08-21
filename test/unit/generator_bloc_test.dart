import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:secure_vault/features/generator/presentation/bloc/generator_bloc.dart';

void main() {
  group('GeneratorBloc', () {
    blocTest<GeneratorBloc, GeneratorState>(
      'emits password on GeneratePassword',
      build: () => GeneratorBloc(),
      act: (bloc) => bloc.add(GeneratePassword()),
      expect: () => [
        isA<GeneratorState>().having((s) => s.password.length, 'length', 16),
      ],
    );

    blocTest<GeneratorBloc, GeneratorState>(
      'updates length',
      build: () => GeneratorBloc(),
      act: (bloc) => bloc.add(const UpdateOptions(24)),
      expect: () => [
        isA<GeneratorState>().having((s) => s.length, 'length', 24),
      ],
    );
  });
}
