import 'dart:async';

import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/widgets/previews/member_preview/member_preview.dart';
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
  SearchRepo _searchRepo;
  Future<QueryResults<UserProfile>> _searchFuture;
  Timer debounceTimer;
  TextEditingController _textEditingController;
  bool _fullName = false;

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
    _searchFuture = _searchRepo.searchMembers(query, username: !_fullName);
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _searchFuture = null;
    super.dispose();
  }

  void onTextChange(String query) {
    debounceTimer?.cancel();
    debounceTimer = Timer(
      const Duration(milliseconds: 600),
      () async {
        if (mounted) {
          setState(() {
            _searchFuture =
                _searchRepo.searchMembers(query, username: !_fullName);
          });
        }
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
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
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
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Transform.scale(
                      scale: .8,
                      child: Switch.adaptive(
                        activeColor: Theme.of(context).primaryColor,
                        value: _fullName,
                        onChanged: (bool value) => setState(
                          () => _fullName = value,
                        ),
                      ),
                    ),
                    Text(
                      _fullName ? 'by full name' : 'by username',
                      style: TextStyle(
                        color: Theme.of(context).primaryColorLight,
                        fontSize: 15.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
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
                      padding: const EdgeInsets.symmetric(
                        vertical: 0,
                        horizontal: 15,
                      ),
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
