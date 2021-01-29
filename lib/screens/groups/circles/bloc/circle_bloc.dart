import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/logger/logger.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/models/expression_query_params.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/utils/junto_exception.dart';

part 'circle_event.dart';
part 'circle_state.dart';

class CircleBloc extends Bloc<CircleEvent, CircleState> {
  CircleBloc(
    this.groupRepo,
    this.userRepo,
    this.userDataProvider,
    this.notificationRepo,
  ) : super(CircleInitial());

  final GroupRepo groupRepo;
  final NotificationRepo notificationRepo;
  final UserDataProvider userDataProvider;
  final UserRepo userRepo;

  List<Users> members;
  List<Group> groups;
  List<Group> notifications;
  UserData creator;

  @override
  Stream<CircleState> mapEventToState(
    CircleEvent event,
  ) async* {
    if (event is FetchMyCircle) {
      yield* _mapFetchCircleToState(event);
    } else if (event is RefreshCircle) {
      yield* _mapRefreshCircleToState(event);
    } else if (event is UpdateCircle) {
      yield* _mapUpdateCircleToState(event);
    } else if (event is DeleteCircle) {
      yield* _mapDeleteCircleToState(event);
    } else if (event is LeaveCircle) {
      yield* _mapLeaveCircleToState(event);
    } else if (event is AddMemberToCircle) {
      yield* _mapAddMemberToCircleToState(event);
    } else if (event is LoadCircleMembers) {
      yield* _mapLoadCircleMembersToState(event);
    } else if (event is LoadCircleMembersMore) {
      yield* _mapLoadCircleMembersMoreToState(event);
    } else if (event is RemoveMemberFromCircle) {
      yield* _mapRemoveMemberFromCircleToState(event);
    }
  }

  Stream<CircleState> _mapFetchCircleToState(FetchMyCircle event) async* {
    final String uid = userDataProvider.userProfile.user.address;

    try {
      yield CircleLoading();
      final unfilteredGroups = await groupRepo.getUserGroups(uid);
      groups = _buildUserSphere(unfilteredGroups);
      final result =
          await notificationRepo.getJuntoNotifications(groupJoinRequests: true);

      if (result.wasSuccessful) {
        final unFilteredNotifications = result.results
            .where((element) =>
                element.notificationType == NotificationType.GroupJoinRequest)
            .toList();
        notifications = unFilteredNotifications.map((e) => e.group).toList();
        yield CircleLoaded(
            groups: groups, groupJoinNotifications: notifications);
      } else {
        yield CircleLoaded(groups: groups, groupJoinNotifications: []);
      }
    } on JuntoException catch (error) {
      yield CircleError(error.message);
    } catch (e, s) {
      logger.logException(e, s);
      yield CircleError();
    }
  }

  Stream<CircleState> _mapRefreshCircleToState(RefreshCircle event) async* {
    final String uid = userDataProvider.userProfile.user.address;

    try {
      final unfilteredGroups = await groupRepo.getUserGroups(uid);
      final result = await notificationRepo.getJuntoNotifications(
          connectionRequests: true);
      if (result.wasSuccessful) {
        final unFilteredNotifications = result.results
            .where((element) =>
                element.notificationType == NotificationType.GroupJoinRequest)
            .toList();
        notifications = unFilteredNotifications.map((e) => e.group).toList();
        yield CircleLoaded(
            groups: groups, groupJoinNotifications: notifications);
      } else {
        groups = _buildUserSphere(unfilteredGroups);
        yield CircleLoaded(groups: groups, groupJoinNotifications: []);
      }
    } on JuntoException catch (error) {
      yield CircleError(error.message);
    } catch (e, s) {
      logger.logException(e, s);
      yield CircleError();
    }
  }

  Stream<CircleState> _mapUpdateCircleToState(UpdateCircle event) async* {
    try {
      yield CircleLoading();

      final group = await groupRepo.updateGroup(event.group);

      groups =
          groups.map((e) => e.address == group.address ? group : e).toList();

      yield CircleLoaded(
        groups: groups,
        groupJoinNotifications: notifications,
        members: members,
        creator: creator,
      );
    } catch (e, s) {
      logger.logException(e, s);
      yield CircleError();
    }
  }

  Stream<CircleState> _mapDeleteCircleToState(DeleteCircle event) async* {
    try {
      await groupRepo.deleteGroup(event.sphereAddress);

      groups = groups.where((e) => e.address != event.sphereAddress).toList();

      yield CircleLoaded(
        groups: groups,
        groupJoinNotifications: notifications,
        members: members,
        creator: creator,
      );
    } catch (e, s) {
      logger.logException(e, s);
      yield CircleError();
    }
  }

  Stream<CircleState> _mapLeaveCircleToState(LeaveCircle event) async* {
    try {
      await groupRepo.removeGroupMember(event.sphereAdress, event.userAddress);

      yield CircleLoaded(
        groups: groups,
        groupJoinNotifications: notifications,
        members: members,
        creator: creator,
      );
    } catch (e, s) {
      logger.logException(e, s);
      yield CircleError();
    }
  }

  Stream<CircleState> _mapRemoveMemberFromCircleToState(
      RemoveMemberFromCircle event) async* {
    try {
      await groupRepo.removeGroupMember(event.sphereAdress, event.userAddress);

      members = members.where((e) => e.user.address != event.userAddress);

      yield CircleLoaded(
        groups: groups,
        groupJoinNotifications: notifications,
        members: members,
        creator: creator,
      );
    } catch (e, s) {
      logger.logException(e, s);
      yield CircleError();
    }
  }

  Stream<CircleState> _mapAddMemberToCircleToState(
      AddMemberToCircle event) async* {
    try {
      await groupRepo.addGroupMember(
          event.sphereAddress, [event.user], event.permissionLevel);

      members = [
        Users(user: event.user, permissionLevel: event.permissionLevel),
        ...members
      ];

      yield CircleLoaded(
        groups: groups,
        groupJoinNotifications: notifications,
        members: members,
        creator: creator,
      );
    } catch (e, s) {
      logger.logException(e, s);
      yield CircleError();
    }
  }

  Stream<CircleState> _mapLoadCircleMembersToState(
      LoadCircleMembers event) async* {
    try {
      members = [];

      yield CircleLoaded(
        groups: groups,
        groupJoinNotifications: notifications,
        members: members,
      );

      final result = await groupRepo.getGroupMembers(
          event.sphereAddress, ExpressionQueryParams(paginationPosition: '0'));

      members = result.results;

      final activeGroup =
          groups.indexWhere((e) => e.address == event.sphereAddress);

      if (activeGroup != -1) {
        final group = groups[activeGroup];
        if (group.creator.runtimeType == String) {
          creator = await userRepo.getUser(group.creator);
        } else {
          creator = await userRepo.getUser(group.creator['address']);
        }
      }

      yield CircleLoaded(
        groups: groups,
        groupJoinNotifications: notifications,
        members: members,
        creator: creator,
      );
    } catch (e, s) {
      logger.logException(e, s);
      yield CircleError();
    }
  }

  Stream<CircleState> _mapLoadCircleMembersMoreToState(
      LoadCircleMembersMore event) async* {
    try {
      final result = await groupRepo.getGroupMembers(
          event.sphereAddress, ExpressionQueryParams(paginationPosition: '0'));

      members = [...members, ...result.results];

      yield CircleLoaded(
        groups: groups,
        groupJoinNotifications: notifications,
        members: members,
        creator: creator,
      );
    } catch (e, s) {
      logger.logException(e, s);
      yield CircleError();
    }
  }

  /// Return a list of "Sphere" the user is apart of.
  List<Group> _buildUserSphere(UserGroupsResponse groups) {
    final List<Group> ownedGroups = groups.owned;
    final List<Group> associatedGroups = groups.associated;

    final List<Group> userSpheres = ListDistinct<Group>(
      ownedGroups,
      associatedGroups,
    ).where((Group group) => group.groupType == 'Sphere').toList();

    return userSpheres;
  }

  List<T> ListDistinct<T>(List<T> listOne, List<T> listTwo) {
    final List<T> _newList = <T>[];
    _newList.addAll(listOne);
    for (final T item in listTwo) {
      if (_newList.contains(item)) {
        _newList.remove(item);
      } else {
        _newList.add(item);
      }
    }
    return _newList;
  }

  @override
  String toString() => 'CircleBloc';
}
