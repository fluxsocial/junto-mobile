import 'dart:async';

import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/widgets/previews/sphere_preview/sphere_preview.dart';
import 'package:provider/provider.dart';

class SpheresSearch extends StatefulWidget {
  const SpheresSearch({Key key, this.changeGroup}) : super(key: key);

  final Function changeGroup;

  @override
  _SpheresSearchState createState() => _SpheresSearchState();
}

class _SpheresSearchState extends State<SpheresSearch> {
  SearchRepo _searchRepo;
  Future<QueryResults<Group>> _searchFuture;
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
    _searchRepo = Provider.of<SearchRepo>(context, listen: false);
    _searchFuture = searchSphere(query);
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _searchFuture = null;
    super.dispose();
  }

  Future<QueryResults<Group>> searchSphere(String searchText) async {
    try {
      return await _searchRepo.searchSphere(searchText, handle: true);
    } catch (error) {
      print(error);
      return null;
    }
  }

  void onTextChange(String query) {
    setState(() {
      _searchFuture = searchSphere(query);
    });
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
                  padding: const EdgeInsets.only(
                      left: 15, right: 10, top: 10, bottom: 10),
                  color: Colors.transparent,
                  alignment: Alignment.centerLeft,
                  child: Icon(CustomIcons.back,
                      color: Theme.of(context).primaryColor, size: 17),
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
                    hintText: 'search circles',
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).primaryColorLight),
                  ),
                  cursorColor: Theme.of(context).primaryColor,
                  cursorWidth: 1,
                  maxLines: 1,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).primaryColor),
                  maxLength: 80,
                  textInputAction: TextInputAction.search,
                ),
              ),
              const SizedBox(width: 15),
              GestureDetector(
                onTap: () {
                  if (_textEditingController.text != '') {
                    _textEditingController.text = '';
                    onTextChange('');
                  }
                },
                child: Container(
                  padding: const EdgeInsets.only(
                      left: 10, right: 15, top: 10, bottom: 10),
                  color: Colors.transparent,
                  alignment: Alignment.centerRight,
                  child: Text(
                    'X',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).primaryColorLight),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: FutureBuilder<QueryResults<Group>>(
                  future: _searchFuture,
                  builder: (BuildContext context,
                      AsyncSnapshot<QueryResults<Group>> snapshot) {
                    if (snapshot.hasData) {
                      print(snapshot.data);
                      return ListView(
                        children: <Widget>[
                          for (Group group in snapshot.data.results)
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                                widget.changeGroup(group);
                              },
                              child: SpherePreview(group: group),
                            )
                        ],
                      );
                    }
                    if (snapshot.hasError) {
                      return Container(
                        child: Center(
                          child: Text(snapshot.error),
                        ),
                      );
                    }
                    return const SizedBox();
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
