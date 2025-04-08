import '../../models/person.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final Person user;

  AuthSuccess({required this.user});
}

class AuthFailure extends AuthState {
  final String error;

  AuthFailure({required this.error});
}