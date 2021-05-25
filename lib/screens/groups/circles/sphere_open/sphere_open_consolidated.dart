import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/groups/circles/sphere_open/sphere_open_members/sphere_open_members.dart';
import 'package:junto_beta_mobile/widgets/avatars/member_avatar.dart';
import 'package:readmore/readmore.dart';
import 'package:provider/provider.dart';
import 'package:junto_beta_mobile/backend/repositories/app_repo.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/end_drawer_relationships/error_widget.dart';
import 'package:junto_beta_mobile/widgets/progress_indicator.dart';
import 'package:junto_beta_mobile/screens/collective/bloc/collective_bloc.dart';
import 'package:junto_beta_mobile/screens/collective/perspectives/collective_populated_list.dart';
import 'package:junto_beta_mobile/widgets/custom_refresh/collective_feed_refresh.dart';
import 'package:junto_beta_mobile/widgets/fetch_more.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Widget that consolidates About and Expression Feed of a community
class SphereOpenConsolidated extends StatelessWidget {
  const SphereOpenConsolidated({
    this.group,
    this.circleCreator,
    this.members = const <Users>[],
    this.relationToGroup,
    this.totalMembers,
    this.totalFacilitators,
  });

  final UserProfile circleCreator;
  final List<Users> members;
  final Map<String, dynamic> relationToGroup;
  final int totalMembers;
  final int totalFacilitators;

  final Group group;

  @override
  Widget build(BuildContext context) {
    void _removeExpression(ExpressionResponse expression) {
      final bloc = context.read<CollectiveBloc>();
      bloc.add(DeleteCollective(expression.address));
    }

    return CollectiveFeedRefresh(
      child: ListView(
        children: <Widget>[
          CircleBio(
            group: group,
          ),
          if (members != null)
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute<dynamic>(
                    builder: (BuildContext context) => SphereOpenMembers(
                      group: group,
                      relationToGroup: relationToGroup,
                    ),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border(
                    bottom: BorderSide(
                      color: Theme.of(context).dividerColor,
                      width: .5,
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    CircleMembers(
                      members: members,
                      totalMembers: totalMembers,
                      totalFacilitators: totalFacilitators,
                    ),
                    if (circleCreator != null)
                      CircleFacilitators(
                        members: members,
                        circleCreator: circleCreator,
                      ),
                  ],
                ),
              ),
            ),
          if (members == null) const SizedBox(),
          Consumer<AppRepo>(builder: (context, AppRepo appRepo, _) {
            return BlocBuilder<CollectiveBloc, CollectiveState>(
              builder: (context, state) {
                final canFetch = state is CollectivePopulated &&
                    (state.availableMore && !state.loadingMore);

                if (state is CollectiveError) {
                  return JuntoErrorWidget(
                    errorMessage: 'Hmm, something went wrong',
                  );
                } else if (state is CollectivePopulated) {
                  return CustomScrollView(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    slivers: <Widget>[
                      // Empty SliverToBoxAdaptor is necessary, otherwise switching
                      //  between single and two column layouts creates an issue.
                      const SliverToBoxAdapter(),
                      if (state is CollectivePopulated)
                        CollectivePopulatedList(
                          state,
                          deleteExpression: _removeExpression,
                        ),
                      if (state is CollectivePopulated &&
                          state.loadingMore == true)
                        JuntoProgressIndicator(),
                      if (state is CollectiveLoading) JuntoProgressIndicator(),
                      if (canFetch)
                        // pagination
                        SliverToBoxAdapter(
                          child: FetchMoreButton(
                            onPressed: () {
                              context.read<CollectiveBloc>().add(
                                    FetchMoreCollective(),
                                  );
                            },
                          ),
                        ),
                    ],
                  );
                }

                return Container(
                  height: MediaQuery.of(context).size.height,
                  alignment: Alignment.center,
                  child: Transform.translate(
                    offset: Offset(0.0, -50),
                    child: JuntoProgressIndicator(),
                  ),
                );
              },
            );
          })
        ],
      ),
    );
  }
}

class CircleBio extends StatelessWidget {
  const CircleBio({this.group});
  final Group group;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).dividerColor,
                  width: .5,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bio & Purpose',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(height: 10),
                ReadMoreText(
                  group.groupData.description,
                  trimLines: 3,
                  trimMode: TrimMode.Line,
                  style: TextStyle(
                    fontSize: 15,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                  trimExpandedText: ' Close',
                  trimCollapsedText: '...Show More',
                  delimiter: '',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CircleMembers extends StatelessWidget {
  const CircleMembers({
    this.members,
    this.totalMembers = 0,
    this.totalFacilitators = 0,
  });

  final List<Users> members;
  final int totalMembers;
  final int totalFacilitators;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          child: Text(
            'Members (${(totalMembers ?? 0) + (totalFacilitators ?? 0) + 1})',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
        Container(
          color: Colors.transparent,
          margin: const EdgeInsets.only(bottom: 15),
          child: Row(children: <Widget>[
            for (Users user in members)
              if (members.indexOf(user) < 7)
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  child: MemberAvatar(
                    profilePicture: user.user.profilePicture,
                    diameter: 28,
                  ),
                ),
          ]),
        ),
      ],
    );
  }
}

class CircleFacilitators extends StatelessWidget {
  const CircleFacilitators({
    this.members,
    this.circleCreator,
  });

  final List<Users> members;
  final UserProfile circleCreator;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          child: Text(
            'Facilitators',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          color: Colors.transparent,
          child: Row(children: <Widget>[
            Container(
              margin: const EdgeInsets.only(right: 10),
              child: MemberAvatar(
                profilePicture: circleCreator.profilePicture,
                diameter: 28,
              ),
            ),
            for (Users user in members)
              if (user.permissionLevel == 'Admin')
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  child: MemberAvatar(
                    profilePicture: user.user.profilePicture,
                    diameter: 28,
                  ),
                ),
          ]),
        ),
      ],
    );
  }
}

class SeeAllMembers extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Theme.of(context).dividerColor,
            width: .5,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'See All',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).primaryColorLight,
            ),
          ),
          Icon(
            Icons.keyboard_arrow_right,
            color: Theme.of(context).primaryColorLight,
            size: 17,
          )
        ],
      ),
    );
  }
}
