part of 'den_bloc.dart';

@immutable
abstract class DenEvent {}

class LoadDen extends DenEvent {
  LoadDen(this.userAddress);

  final String userAddress;
}

class LoadMoreDen extends DenEvent {}

class RefreshDen extends DenEvent {}
