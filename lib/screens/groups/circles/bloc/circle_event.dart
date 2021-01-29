part of 'circle_bloc.dart';

abstract class CircleEvent {
  const CircleEvent();
}

// ? Done
class FetchMyCircle extends CircleEvent {}

// ? Done
class RefreshCircle extends CircleEvent {}

// ? Done
class UpdateCircle extends CircleEvent {
  final Group group;

  UpdateCircle({
    this.group,
  });
}

// ? Done
class LeaveCircle extends CircleEvent {
  final String sphereAdress;
  final String userAddress;

  LeaveCircle({
    this.sphereAdress,
    this.userAddress,
  });
}

// ? Done
class DeleteCircle extends CircleEvent {
  final String sphereAddress;

  DeleteCircle({
    this.sphereAddress,
  });
}

// TODO: @fayeed load the creator & all the members, calling the event would reset the pagination to 0
class LoadCircleMembers extends CircleEvent {
  final String sphereAddress;

  LoadCircleMembers({
    this.sphereAddress,
  });
}

// TODO: @fayeed this wouldn't get the creator
class LoadCircleMembersMore extends CircleEvent {
  final String sphereAddress;

  LoadCircleMembersMore({
    this.sphereAddress,
  });
}

// TODO: @fayeed once added show a message to the user. Will also be used for adding facilitator
class AddMemberToCircle extends CircleEvent {
  final String sphereAddress;
  final UserProfile user;
  // Can be one of these values: Admin | Member
  final String permissionLevel;

  AddMemberToCircle({
    this.sphereAddress,
    this.user,
    this.permissionLevel,
  });
}

class RemoveMemberFromCircle extends CircleEvent {
  final String sphereAdress;
  final String userAddress;

  RemoveMemberFromCircle({
    this.sphereAdress,
    this.userAddress,
  });
}
