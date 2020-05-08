import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/backend/repositories.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/global_search/search_bloc/bloc.dart';
import 'package:junto_beta_mobile/widgets/previews/member_preview/member_preview.dart';
import 'package:junto_beta_mobile/widgets/progress_indicator.dart';
import 'package:provider/provider.dart';

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
      context.bloc<SearchBloc>().add(
            SearchingEvent(
              query,
              _searchByUsername.value,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => SearchBloc(
        Provider.of<SearchRepo>(context, listen: false),
      )..add(SearchingEvent("", _searchByUsername.value)),
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
              ],
            ),
          ),
        ),
        body: _SearchBody(username: _searchByUsername),
      ),
    );
  }
}

class _SearchBody extends StatefulWidget {
  const _SearchBody({Key key, this.username}) : super(key: key);
  final ValueNotifier<bool> username;

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
        context.bloc<SearchBloc>().add(FetchMoreSearchResEvent());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
              ),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Theme.of(context).dividerColor,
                    width: .75,
                  ),
                ),
              ),
              child: ValueListenableBuilder<bool>(
                  valueListenable: widget.username,
                  builder: (context, value, _) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Transform.scale(
                          scale: .8,
                          child: Switch.adaptive(
                            activeColor: Theme.of(context).primaryColor,
                            value: value,
                            onChanged: (bool value) => setState(
                              () => widget.username.value = value,
                            ),
                          ),
                        ),
                        Text(
                          value ? 'by username' : 'by full name',
                          style: TextStyle(
                            color: Theme.of(context).primaryColorLight,
                            fontSize: 15.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    );
                  }),
            ),
            Expanded(
              child: BlocBuilder<SearchBloc, SearchState>(
                builder: (BuildContext context, SearchState state) {
                  if (state is LoadingSearchState) {
                    return JuntoProgressIndicator();
                  }
                  if (state is LoadedSearchState) {
                    return ListView.builder(
                      controller: _controller,
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
