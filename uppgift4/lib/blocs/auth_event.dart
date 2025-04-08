abstract class AuthEvent {}

class LoginRequested extends AuthEvent {
  final String username;

  LoginRequested({required this.username});
}

class LogoutRequested extends AuthEvent {}



