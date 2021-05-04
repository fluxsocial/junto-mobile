part of 'circle_bloc.dart';

/// Class which represents the possible states of groups.
/// A group can be initial (when it's first created), Loading and Loaded.
@immutable
abstract class CircleState {
  const CircleState();
}

/// The initial state of the group.
class CircleInitial extends CircleState {}

class CircleLoading extends CircleState {}

class CircleError extends CircleState {
  CircleError([this.groupError]);

  final String groupError;
}

/// State containing groups data
class CircleLoaded extends CircleState {
  CircleLoaded({
    this.totalMembers,
    this.groups,
    this.groupJoinNotifications,
    this.members,
    this.creator,
    this.totalFacilitators,
    this.publicGroups,
  });

  final List<Group> groups;
  final List<Group> groupJoinNotifications;
  final List<Users> members;
  final UserData creator;
  final int totalMembers;
  final int totalFacilitators;
  final List<Group> publicGroups;
}
