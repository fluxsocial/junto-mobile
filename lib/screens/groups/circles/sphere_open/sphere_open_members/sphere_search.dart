import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/backend/repositories.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/global_search/search_bloc/bloc.dart';
import 'package:junto_beta_mobile/screens/groups/circles/bloc/circle_bloc.dart';
import 'package:junto_beta_mobile/widgets/dialogs/single_action_dialog.dart';
import 'package:junto_beta_mobile/widgets/previews/member_preview/member_preview.dart';
import 'package:junto_beta_mobile/widgets/progress_indicator.dart';
import 'package:junto_beta_mobile/utils/junto_overlay.dart';
import 'package:provider/provider.dart';
import 'community_member_invite.dart';

class SphereSearch extends StatefulWidget {
  const SphereSearch({
    Key key,
    this.onProfileSelected,
    this.group,
    this.permission,
  }) : super(key: key);

  static Route<dynamic> route(ValueChanged<UserProfile> onProfileSelected) {
    return MaterialPageRoute<dynamic>(builder: (BuildContext context) {
      return SphereSearch(onProfileSelected: onProfileSelected);
    });
  }

  final ValueChanged<UserProfile> onProfileSelected;
  final Group group;
  final String permission;

  @override
  _SphereSearchState createState() => _SphereSearchState();
}

class _SphereSearchState extends State<SphereSearch> {
  final ValueNotifier<bool> _searchByUsername = ValueNotifier(true);
  Timer debounceTimer;
  TextEditingController _textEditingController;

  String get query => _textEditingController.value.text;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  void onTextChange(String query, BuildContext context) {
    if (mounted) {
      context.read<SearchBloc>().add(
            SearchingEvent(query, QueryUserBy.BOTH),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => SearchBloc(
        Provider.of<SearchRepo>(context, listen: false),
      )..add(SearchingEvent(
          "",
          QueryUserBy.BOTH,
        )),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: <Widget>[Container()],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(.75),
            child: Container(
              height: .75,
              color: Theme.of(context).dividerColor,
            ),
          ),
          brightness: Theme.of(context).brightness,
          elevation: 0,
          titleSpacing: 0.0,
          title: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Builder(builder: (context) {
                    return TextField(
                      controller: _textEditingController,
                      onChanged: (val) => onTextChange(val, context),
                      buildCounter: (
                        BuildContext context, {
                        int currentLength,
                        int maxLength,
                        bool isFocused,
                      }) =>
                          null,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(0.0),
                        hintText: 'search members',
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).primaryColorLight,
                        ),
                      ),
                      cursorColor: Theme.of(context).primaryColor,
                      cursorWidth: 1,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).primaryColor,
                      ),
                      maxLength: 80,
                      textInputAction: TextInputAction.search,
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
        body: _SearchBody(
          username: _searchByUsername,
          group: widget.group,
          permission: widget.permission,
          query: query,
        ),
      ),
    );
  }
}

class _SearchBody extends StatefulWidget {
  const _SearchBody({
    Key key,
    this.username,
    this.group,
    this.permission,
    this.query,
  }) : super(key: key);
  final ValueNotifier<bool> username;
  final Group group;
  final String permission;
  final String query;

  @override
  __SearchBodyState createState() => __SearchBodyState();
}

class __SearchBodyState extends State<_SearchBody> {
  ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _controller.addListener(_fetchMore);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.removeListener(_fetchMore);
    _controller.dispose();
  }

  void _fetchMore() {
    print('test: called');
    if (_controller.hasClients) {
      final ScrollDirection direction =
          _controller.position.userScrollDirection;
      final double pixels = _controller.position.pixels;
      final double maxExtent = _controller.position.maxScrollExtent;
      double percent = (pixels / maxExtent) * 100;
      if (percent.roundToDouble() == 60 &&
          direction == ScrollDirection.reverse) {
        context
            .read<SearchBloc>()
            .add(FetchMoreSearchResEvent(widget.query, QueryUserBy.BOTH));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: BlocBuilder<CircleBloc, CircleState>(
              builder: (context, state) {
                return BlocBuilder<SearchBloc, SearchState>(
                  builder: (BuildContext context, SearchState state) {
                    if (state is LoadingSearchState) {
                      return JuntoProgressIndicator();
                    }
                    if (state is LoadedSearchState) {
                      return ListView.builder(
                        controller: _controller,
                        physics: AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(
                          vertical: 0,
                          horizontal: 15,
                        ),
                        itemCount: state.results.length,
                        itemBuilder: (BuildContext context, int index) {
                          final UserProfile data = state.results[index];
                          return CommunityMemberInvite(
                            profile: data,
                            onUserTap: () async {
                              try {
                                JuntoLoader.showLoader(context);
                                context
                                    .read<CircleBloc>()
                                    .add(AddMemberToCircle(
                                      sphereAddress: widget.group.address,
                                      user: [data],
                                      permissionLevel: widget.permission,
                                    ));
                                JuntoLoader.hide();

                                Navigator.pop(context);
                              } catch (e) {
                                JuntoLoader.hide();

                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      SingleActionDialog(
                                    context: context,
                                    dialogText:
                                        'Something went wrong trying to add this member to this group.',
                                  ),
                                );
                              }
                            },
                          );
                        },
                      );
                    }
                    if (state is EmptySearchState ||
                        state is InitialSearchState) {
                      return SizedBox();
                    }
                    if (state is ErrorSearchState) {
                      return Center(
                        child: Transform.translate(
                          offset: const Offset(0.0, -50),
                          child: Text('Hmm, something is up...'),
                        ),
                      );
                    }
                    return Container();
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
