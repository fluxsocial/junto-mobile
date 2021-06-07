import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:junto_beta_mobile/app/theme/custom_icons.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/backend/repositories.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/widgets/previews/member_preview/member_preview.dart';
import 'package:junto_beta_mobile/widgets/progress_indicator.dart';
import 'package:provider/provider.dart';

import 'bloc/bloc.dart';

class GlobalSearch extends StatefulWidget {
  const GlobalSearch({Key key, this.onProfileSelected}) : super(key: key);

  static Route<dynamic> route(ValueChanged<UserProfile> onProfileSelected) {
    return MaterialPageRoute<dynamic>(builder: (BuildContext context) {
      return GlobalSearch(onProfileSelected: onProfileSelected);
    });
  }

  final ValueChanged<UserProfile> onProfileSelected;

  @override
  _GlobalSearchState createState() => _GlobalSearchState();
}

class _GlobalSearchState extends State<GlobalSearch> {
  final ValueNotifier<bool> _searchByUsername = ValueNotifier(true);
  Timer debounceTimer;
  TextEditingController _textEditingController;

  String get query => _textEditingController.value.text;
  String searchType = 'members';

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
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              height: MediaQuery.of(context).size.height * .1,
              alignment: Alignment.bottomCenter,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Theme.of(context).dividerColor,
                    width: .75,
                  ),
                ),
              ),
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      color: Colors.transparent,
                      alignment: Alignment.centerLeft,
                      height: 48,
                      width: 38,
                      child: Icon(
                        CustomIcons.back,
                        size: 17,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
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
                  // TO DO: Fayeed - add support for searching by specific group
                  // Container(
                  //   child: Row(
                  //     children: [
                  //       Container(
                  //         padding: const EdgeInsets.symmetric(
                  //           horizontal: 10,
                  //           vertical: 5,
                  //         ),
                  //         decoration: BoxDecoration(
                  //           color: Theme.of(context).colorScheme.primary,
                  //           borderRadius: BorderRadius.circular(5),
                  //         ),
                  //         child: Icon(
                  //           Icons.people,
                  //           color: Colors.white,
                  //           size: 20,
                  //         ),
                  //       ),
                  //       Container(
                  //         padding: const EdgeInsets.symmetric(
                  //           horizontal: 10,
                  //           vertical: 5,
                  //         ),
                  //         decoration: BoxDecoration(
                  //           color: Theme.of(context).dividerColor,
                  //           borderRadius: BorderRadius.circular(5),
                  //         ),
                  //         child: Icon(
                  //           CustomIcons.newcollective,
                  //           size: 20,
                  //           color: Theme.of(context).primaryColor,
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
        body: _SearchBody(username: _searchByUsername, query: query),
      ),
    );
  }
}

class _SearchBody extends StatefulWidget {
  const _SearchBody({
    Key key,
    this.username,
    this.query,
  }) : super(key: key);
  final ValueNotifier<bool> username;
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
            child: BlocBuilder<SearchBloc, SearchState>(
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
                      return MemberPreview(profile: data);
                    },
                  );
                }
                if (state is EmptySearchState || state is InitialSearchState) {
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
            ),
          ),
        ],
      ),
    );
  }
}
