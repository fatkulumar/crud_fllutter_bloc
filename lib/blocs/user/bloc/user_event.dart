part of 'user_bloc.dart';

@immutable
sealed class UserEvent {}

class LoadUser extends UserEvent {}

class AddUser extends UserEvent {
  final String name;
  final String email;
  final String password;

  AddUser({required this.name, required this.email, required this.password});
}
