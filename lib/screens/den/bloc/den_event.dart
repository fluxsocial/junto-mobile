part of 'den_bloc.dart';

@immutable
abstract class DenEvent {}

class LoadDen extends DenEvent {}

class LoadMoreDen extends DenEvent {}

class RefreshDen extends DenEvent {}
