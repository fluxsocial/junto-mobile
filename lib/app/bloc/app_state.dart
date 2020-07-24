part of 'app_bloc.dart';

abstract class AppBlocState extends Equatable {
  const AppBlocState();
}

class AppBlocInitial extends AppBlocState {
  @override
  List<Object> get props => [];
}

class UnsupportedState extends AppBlocState {
  @override
  List<Object> get props => [];
}

class SupportedVersion extends AppBlocState {
  @override
  List<Object> get props => [];
}
