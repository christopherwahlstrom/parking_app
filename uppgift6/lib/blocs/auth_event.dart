abstract class AuthEvent {}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;
  LoginRequested({required this.email, required this.password});
}

class RegisterRequested extends AuthEvent {
  final String email;
  final String password;
  final String name;
  final String personalNumber;
  RegisterRequested({
    required this.email,
    required this.password,
    required this.name,
    required this.personalNumber,
  });
}



class LogoutRequested extends AuthEvent {}

class AuthUserChanged extends AuthEvent {
  final String uid;
  AuthUserChanged(this.uid);
}
