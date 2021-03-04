import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:junto_beta_mobile/backend/repositories.dart';
import 'package:junto_beta_mobile/models/expression_query_params.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/packs/packs_bloc/pack_bloc.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/end_drawer_relationships/error_widget.dart';
import 'package:junto_beta_mobile/widgets/previews/member_preview/member_preview.dart';
import 'package:junto_beta_mobile/widgets/progress_indicator.dart';
import 'package:junto_beta_mobile/widgets/placeholders/feed_placeholder.dart';
import 'package:provider/provider.dart';
import './search_bar.dart';

class PackMembers extends StatefulWidget {
  const PackMembers({this.userAddress});

  final String userAddress;

  @override
  State<StatefulWidget> createState() {
    return PackMembersState();
  }
}

class PackMembersState extends State<PackMembers> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> getPackMembers(BuildContext _context) async {
    final userData = await Provider.of<UserRepo>(context, listen: false)
        .getUser(widget.userAddress);
    _context.bloc<PackBloc>().add(FetchPacks(group: userData.pack.address));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PackBloc(
        Provider.of<ExpressionRepo>(context, listen: false),
        Provider.of<GroupRepo>(context, listen: false),
      ),
      child: BlocBuilder<PackBloc, PackState>(
        builder: (context, state) {
          if (state is PackInitial) {
            getPackMembers(context);
          } else if (state is PacksLoaded) {
            final List<Users> packMembers = state.groupMemebers;

            if (packMembers.length > 0) {
              return Container(
                child: Column(
                  children: [
                    SearchBar(
                      hintText: 'Search Packs',
                    ),
                    Expanded(
                      child: NotificationListener(
                        onNotification: (ScrollNotification notification) {
                          final metrics = notification.metrics;
                          double scrollPercent =
                              (metrics.pixels / metrics.maxScrollExtent) * 100;
                          if (scrollPercent.roundToDouble() == 60.0) {
                            context
                                .bloc<PackBloc>()
                                .add(FetchMorePacksMembers());
                            return true;
                          }
                          return false;
                        },
                        child: ListView(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          children: packMembers
                              .map(
                                (dynamic packMember) =>
                                    MemberPreview(profile: packMember.user),
                              )
                              .toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return FeedPlaceholder(
                placeholderText: 'No pack members yet!',
                image: 'assets/images/junto-mobile__bench.png',
              );
            }
          } else if (state is PacksError) {
            return JuntoErrorWidget(errorMessage: 'Hmm, something went wrong');
          }
          return Center(
            child: JuntoProgressIndicator(),
          );
        },
      ),
    );
  }
}

class BlockBuilder {}
