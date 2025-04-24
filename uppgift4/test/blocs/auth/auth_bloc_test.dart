import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:parking_app_uppgift4/blocs/auth_bloc.dart';
import 'package:parking_app_uppgift4/blocs/auth_event.dart';
import 'package:parking_app_uppgift4/blocs/auth_state.dart';
import '../../mocks/mock_repositories.dart'; 
void main() {
  late MockPersonService mockPersonService;

  setUp(() {
    mockPersonService = MockPersonService();
    registerFallbackValue(MockPerson());
  });

  group('AuthBloc', () {
    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthSuccess] on successful login',
      build: () {
        when(() => mockPersonService.getPersonByName(any()))
            .thenAnswer((_) async => MockPerson());
        return AuthBloc(personService: mockPersonService);
      },
      act: (bloc) => bloc.add(LoginRequested(username: 'Stig')),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthSuccess>(),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthFailure] when login fails',
      build: () {
        when(() => mockPersonService.getPersonByName(any()))
            .thenAnswer((_) async => null);
        return AuthBloc(personService: mockPersonService);
      },
      act: (bloc) => bloc.add(LoginRequested(username: 'IngenAnvändare')),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthFailure>(),
      ],
    );
  });
}