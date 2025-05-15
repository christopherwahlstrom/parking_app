import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import '../../services/person_firestore_service.dart';
import '../models/person.dart';
import '../blocs/repositories/firebase_auth_repository.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuthRepository authRepository;
  final PersonFirestoreService personService;

  AuthBloc({required this.authRepository, required this.personService})
    : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<AuthUserChanged>(_onAuthUserChanged);

    authRepository.authStateChanges.listen((user) {
      if (user != null) {
        add(AuthUserChanged(user.uid));
      } 
    });
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await authRepository.signIn(event.email, event.password);
    } on FirebaseAuthException catch (e) {
      emit(AuthFailure(e.message ?? 'Inloggningen misslyckades.'));
    }
  }

  Future<void> _onRegisterRequested(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final userCredential = await authRepository.register(
        event.email,
        event.password,
      );
      final user = userCredential.user;
      if (user != null) {
        final person = Person(
          id: user.uid,
          name: event.name,
          personalNumber: event.personalNumber,
          email: event.email,
          vehicleIds: [],
        );
        await personService.createPerson(person);
      } else {
        emit(AuthFailure('Misslyckades att skapa användare.'));
      }
    } on FirebaseAuthException catch (e) {
      emit(AuthFailure(e.message ?? 'Registreringen misslyckades.'));
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await authRepository.signOut();
    emit(AuthInitial());
  }

  Future<void> _onAuthUserChanged(
    AuthUserChanged event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final person = await personService.getPersonById(event.uid);
    if (person != null) {
      emit(AuthSuccess(person));
    } else {
      emit(AuthFailure('Persondata saknas – kontakta support.'));
    }
  }
}
