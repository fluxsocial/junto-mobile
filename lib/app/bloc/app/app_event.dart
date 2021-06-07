part of 'app_bloc.dart';

abstract class AppBlocEvent extends Equatable {
  const AppBlocEvent();
}

class CheckServerVersion extends AppBlocEvent {
  @override
  List<Object> get props => [];
}