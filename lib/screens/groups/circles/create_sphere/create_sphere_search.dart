import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/backend/repositories.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/global_search/search_bloc/bloc.dart';
import 'package:junto_beta_mobile/screens/groups/circles/bloc/circle_bloc.dart';
import 'package:junto_beta_mobile/widgets/progress_indicator.dart';
import 'package:provider/provider.dart';
import 'package:junto_beta_mobile/widgets/previews/member_preview/member_preview_select.dart';

class CreateSphereSearch extends StatefulWidget {
  const CreateSphereSearch({
    Key key,
    this.onSelect,
    this.onDeselect,
    this.selectedMembers,
  }) : super(key: key);

  final ValueChanged<UserProfile> onSelect;
  final ValueChanged<UserProfile> onDeselect;
  final List<String> selectedMembers;

  @override
  _CreateSphereSearchState createState() => _CreateSphereSearchState();
}

class _CreateSphereSearchState extends State<CreateSphereSearch> {
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
                Icon(
                  Icons.search,
                  color: Theme.of(context).primaryColorLight,
                  size: 17,
                ),
                const SizedBox(width: 10),
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
                        border: InputBorder.none,
                        hintText: 'Search',
                        hintStyle: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).primaryColorLight,
                        ),
                      ),
                      cursorColor: Theme.of(context).primaryColor,
                      cursorWidth: 1,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 17,
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
          onSelect: widget.onSelect,
          onDeselect: widget.onDeselect,
          selectedMembers: widget.selectedMembers,
          query: query,
        ),
      ),
    );
  }
}

class _SearchBody extends StatefulWidget {
  const _SearchBody({
    Key key,
    this.onSelect,
    this.onDeselect,
    this.selectedMembers,
    this.query,
  }) : super(key: key);

  final ValueChanged<UserProfile> onSelect;
  final ValueChanged<UserProfile> onDeselect;
  final List<String> selectedMembers;
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
      // print('test: what 1 ${percent.roundToDouble()} | $direction');
      if (percent.roundToDouble() == 60 &&
          direction == ScrollDirection.reverse) {
        context
            .bloc<SearchBloc>()
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

                          return MemberPreviewSelect(
                            profile: data,
                            onSelect: widget.onSelect,
                            onDeselect: widget.onDeselect,
                            isSelected:
                                widget.selectedMembers.contains(data.address),
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
