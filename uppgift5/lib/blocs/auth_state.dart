import '../models/person.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final Person person;
  AuthSuccess(this.person);
}

class AuthFailure extends AuthState {
  final String error;
  AuthFailure(this.error);
}
