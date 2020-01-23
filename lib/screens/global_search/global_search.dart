import 'dart:async';

import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:provider/provider.dart';
import 'package:junto_beta_mobile/widgets/previews/member_preview/member_preview.dart';

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
  SearchRepo _searchRepo;
  Future<QueryResults<UserProfile>> _searchFuture;
  Timer debounceTimer;
  TextEditingController _textEditingController;

  String get query => _textEditingController.value.text;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _searchRepo = Provider.of<SearchRepo>(context);
    _searchFuture = _searchRepo.searchMembers(query);
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _searchFuture = null;
    super.dispose();
  }

  void onTextChange(String query) {
    debounceTimer?.cancel();
    debounceTimer = Timer.periodic(
      const Duration(milliseconds: 600),
      (_) async {
        if (mounted)
          setState(() {
            _searchFuture = _searchRepo.searchMembers(query, username: true);
          });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: <Widget>[Container()],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(.75),
          child: Container(height: .75, color: Theme.of(context).dividerColor),
        ),
        brightness: Brightness.light,
        elevation: 0,
        titleSpacing: 0.0,
        title: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  padding: const EdgeInsets.only(left: 10),
                  color: Colors.transparent,
                  height: 48,
                  child: Icon(CustomIcons.back,
                      size: 17, color: Theme.of(context).primaryColor),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: TextField(
                  controller: _textEditingController,
                  onChanged: onTextChange,
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
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).primaryColorLight),
                  ),
                  cursorColor: Theme.of(context).primaryColor,
                  cursorWidth: 1,
                  maxLines: 1,
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).primaryColor),
                  maxLength: 80,
                  textInputAction: TextInputAction.search,
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            children: <Widget>[
              Expanded(
                child: FutureBuilder<QueryResults<UserProfile>>(
                  future: _searchFuture,
                  builder: (BuildContext context,
                      AsyncSnapshot<QueryResults<UserProfile>> snapshot) {
                    if (!snapshot.hasData) {
                      return const SizedBox();
                    }
                    if (snapshot.hasError) {
                      return Container(
                        child: Center(
                          child: Text(snapshot.error),
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: snapshot.data.results.length,
                      itemBuilder: (BuildContext context, int index) {
                        final UserProfile data = snapshot.data.results[index];
                        return MemberPreview(profile: data);
                      },
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
