import 'package:meta/meta.dart';

@immutable
abstract class AuthState {}

class InitialAuthState extends AuthState {}
