part of 'group_bloc.dart';

/// Class which represents the possible states of groups.
/// A group can be inital (when it's first created), Loading and Loaded.
@immutable
abstract class GroupBlocState {
  const GroupBlocState();
}

/// The inital state of the group.
class GroupBlocInitial extends GroupBlocState {}

class GroupLoading extends GroupBlocState {}

class GroupError extends GroupBlocState {
  GroupError([this.groupError]);
  final String groupError;
}

/// State containing groups data
class GroupLoaded extends GroupBlocState {
  GroupLoaded(this.groups);
  final UserGroupsResponse groups;
}
