import 'dart:async';
import 'package:dio/dio.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/logger/logger.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/models/expression_query_params.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/utils/junto_exception.dart';
import 'package:rxdart/rxdart.dart';

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
  List<Group> publicGroups;
  List<Group> notifications;
  UserData creator;
  int currentMemberPage = 0;
  int currentPublicGroupsPage = 0;
  int remainingPublicGroupCount = 0;
  String currentMemberTimeStamp;

  @override
  Stream<Transition<CircleEvent, CircleState>> transformEvents(
    Stream<CircleEvent> events,
    TransitionFunction<CircleEvent, CircleState> transitionFn,
  ) {
    final nonDebounceStream = events.where((event) =>
        event is! LoadCircleMembersMore && event is! FetchMorePublicCircle);
    final debounceStream = events
        .where((event) =>
            event is LoadCircleMembersMore || event is FetchMorePublicCircle)
        .debounceTime(const Duration(milliseconds: 600));
    return super.transformEvents(
        MergeStream([nonDebounceStream, debounceStream]), transitionFn);
  }

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
    } else if (event is CreateCircleEvent) {
      yield* _mapCreateCircleToState(event);
    } else if (event is FetchPublicCircle) {
      yield* _mapFetchPublicGroupsToState(event);
    } else if (event is FetchMorePublicCircle) {
      yield* _mapFetchMorePublicGroupsToState(event);
    }
  }

  Stream<CircleState> _mapCreateCircleToState(CreateCircleEvent event) async* {
    try {
      yield CircleLoading();
      final typeState = state as CircleLoaded;
      final tempGroup = event.sphere;
      final group = Group(
        address: tempGroup.address,
        createdAt: tempGroup.createdAt,
        creator: tempGroup.creator,
        privacy: tempGroup.privacy,
        groupData: tempGroup.groupData,
        groupType: tempGroup.groupType,
        facilitators: null,
        members: null,
      );
      groups = [...typeState.groups, group];
      yield CircleLoaded(
        groups: groups,
        groupJoinNotifications: notifications,
        members: members,
        creator: creator,
        publicGroups: publicGroups,
      );
    } catch (e, s) {
      logger.logException(e, s);
      yield CircleError();
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
          groups: groups,
          groupJoinNotifications: notifications,
          publicGroups: publicGroups,
        );
      } else {
        yield CircleLoaded(
          groups: groups,
          groupJoinNotifications: [],
          publicGroups: publicGroups,
        );
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
      groups = _buildUserSphere(unfilteredGroups);
      if (result.wasSuccessful) {
        final unFilteredNotifications = result.results
            .where((element) =>
                element.notificationType == NotificationType.GroupJoinRequest)
            .toList();
        notifications = unFilteredNotifications.map((e) => e.group).toList();
        yield CircleLoaded(
          groups: groups,
          groupJoinNotifications: notifications,
          publicGroups: publicGroups,
        );
      } else {
        yield CircleLoaded(
          groups: groups,
          groupJoinNotifications: [],
          publicGroups: publicGroups,
        );
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
      final group = await groupRepo.updateGroup(event.group);

      groups =
          groups.map((e) => e.address == group.address ? group : e).toList();

      yield CircleLoaded(
        groups: groups,
        groupJoinNotifications: notifications,
        members: members,
        creator: creator,
        publicGroups: publicGroups,
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
        publicGroups: publicGroups,
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
        publicGroups: publicGroups,
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
        publicGroups: publicGroups,
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
        event.sphereAddress,
        [...event.user],
        event.permissionLevel,
      );

      yield CircleLoaded(
        groups: groups,
        groupJoinNotifications: notifications,
        members: members,
        creator: creator,
        publicGroups: publicGroups,
      );
    } on DioError catch (e, s) {
      print(e.response.data);
    } catch (e, s) {
      logger.logException(e, s);
      // yield CircleError();
    }
  }

  Stream<CircleState> _mapLoadCircleMembersToState(
      LoadCircleMembers event) async* {
    try {
      members = [];

      currentMemberPage = 0;

      yield CircleLoaded(
        groups: groups,
        groupJoinNotifications: notifications,
        members: members,
        publicGroups: publicGroups,
      );

      final result = await groupRepo.getGroupMembers(
          event.sphereAddress, ExpressionQueryParams());

      final groupResult = await groupRepo.getGroup(event.sphereAddress);

      members = result.results;

      currentMemberTimeStamp = result.lastTimestamp;

      var activeGroup = -1;
      var isPublic = false;

      activeGroup = groups.indexWhere((e) => e.address == event.sphereAddress);

      if (activeGroup == -1) {
        activeGroup =
            publicGroups.indexWhere((e) => e.address == event.sphereAddress);
        isPublic = true;
      }

      if (activeGroup != -1) {
        final group =
            !isPublic ? groups[activeGroup] : publicGroups[activeGroup];

        if (group.creator.runtimeType == String) {
          creator = await userRepo.getUser(group.creator);
        } else if (isPublic) {
          creator = await userRepo.getUser(groupResult.creator['address']);
        } else {
          creator = await userRepo.getUser(group.creator['address']);
        }
      }

      yield CircleLoaded(
        groups: groups,
        groupJoinNotifications: notifications,
        members: members,
        creator: creator,
        totalMembers: groupResult.members,
        totalFacilitators: groupResult.facilitators,
        publicGroups: publicGroups,
      );
    } catch (e, s) {
      logger.logException(e, s);
      yield CircleError();
    }
  }

  Stream<CircleState> _mapLoadCircleMembersMoreToState(
      LoadCircleMembersMore event) async* {
    try {
      final results = state as CircleLoaded;
      if (results.members.length % 50 == 0) {
        currentMemberPage += 50;
        final result = await groupRepo.getGroupMembers(
            event.sphereAddress,
            ExpressionQueryParams(
              paginationPosition: currentMemberPage.toString(),
              lastTimestamp: currentMemberTimeStamp,
            ));

        currentMemberTimeStamp = result.lastTimestamp;

        members = [...members, ...result.results];

        yield CircleLoaded(
          groups: groups,
          groupJoinNotifications: notifications,
          members: members,
          creator: creator,
          totalMembers: results.totalMembers,
          totalFacilitators: results.totalFacilitators,
          publicGroups: publicGroups,
        );
      }
    } catch (e, s) {
      logger.logException(e, s);
    }
  }

  Stream<CircleState> _mapFetchPublicGroupsToState(
      FetchPublicCircle event) async* {
    try {
      publicGroups = [];

      currentPublicGroupsPage = 0;

      yield CircleLoaded(
        groups: groups,
        groupJoinNotifications: notifications,
        members: members,
        publicGroups: publicGroups,
      );

      final result = await groupRepo.getPublicGroups({
        'pagination_position': currentPublicGroupsPage.toString(),
        'query': event.query,
        'sorting': 'GroupSize',
      });

      final results = result['results'];

      publicGroups =
          results.map((e) => Group.fromJson(e)).toList().cast<Group>();
      print(publicGroups);

      remainingPublicGroupCount = event.query.length > 0
          ? result['result_count']
          : result['remaining_count'];

      yield CircleLoaded(
        groups: groups,
        groupJoinNotifications: notifications,
        members: members,
        creator: creator,
        publicGroups: publicGroups,
      );
    } on DioError catch (e) {
      print(e.message);
    } catch (e, s) {
      logger.logException(e, s);
    }
  }

  Stream<CircleState> _mapFetchMorePublicGroupsToState(
      FetchMorePublicCircle event) async* {
    try {
      final loadmore = event.query.length > 0
          ? remainingPublicGroupCount == 50
          : remainingPublicGroupCount != 0;
      if (loadmore) {
        currentPublicGroupsPage += 1;

        final result = await groupRepo.getPublicGroups({
          'pagination_position': currentPublicGroupsPage.toString(),
          'query': event.query,
          'sorting': 'GroupSize',
        });

        final results = result['results'];

        publicGroups = [
          ...publicGroups,
          ...results.map((e) => Group.fromJson(e)).toList().cast<Group>()
        ];

        remainingPublicGroupCount = event.query.length > 0
            ? result['result_count']
            : result['remaining_count'];

        yield CircleLoaded(
          groups: groups,
          groupJoinNotifications: notifications,
          members: members,
          creator: creator,
          publicGroups: publicGroups,
        );
      }
    } catch (e, s) {
      logger.logException(e, s);
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
