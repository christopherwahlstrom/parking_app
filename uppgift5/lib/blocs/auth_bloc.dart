import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import '../../services/person_service.dart';



class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final PersonService personService;

  AuthBloc({required this.personService}) : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>((event, emit) => emit(AuthInitial()));
  }

  Future<void> _onLoginRequested(LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final person = await personService.getPersonByName(event.username);
      if (person != null) {
        emit(AuthSuccess(person));
      } else {
        emit(AuthFailure('Personen finns inte registrerad.'));
      }
    } catch (e) {
      emit(AuthFailure('Ett fel inträffade: $e'));
    }
  }
}