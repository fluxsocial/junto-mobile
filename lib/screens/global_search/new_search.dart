import 'dart:async';

import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:provider/provider.dart';

class NewSearchScreen extends StatefulWidget {
  const NewSearchScreen({Key key, this.onProfileSelected}) : super(key: key);

  static Route<dynamic> route(ValueChanged<UserProfile> onProfileSelected) {
    return MaterialPageRoute<dynamic>(builder: (BuildContext context) {
      return NewSearchScreen(onProfileSelected: onProfileSelected);
    });
  }

  final ValueChanged<UserProfile> onProfileSelected;

  @override
  _NewSearchScreenState createState() => _NewSearchScreenState();
}

class _NewSearchScreenState extends State<NewSearchScreen> {
  SearchRepo _searchRepo;
  Future<QueryResults<UserProfile>> _searchFuture;
  Timer debounceTimer;
  TextEditingController _textEditingController;

  String get query => _textEditingController.value.text;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
    _searchFuture = _searchRepo.searchMembers(query);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _searchRepo = Provider.of<SearchRepo>(context);
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
        title: const Text(
          'Search Members',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Column(
            children: <Widget>[
              TextField(
                autocorrect: true,
                controller: _textEditingController,
                onChanged: onTextChange,
                textInputAction: TextInputAction.search,
              ),
              Expanded(
                child: FutureBuilder<QueryResults<UserProfile>>(
                  future: _searchFuture,
                  builder: (BuildContext context,
                      AsyncSnapshot<QueryResults<UserProfile>> snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: Container(
                          height: 50.0,
                          width: 50.0,
                          child: const CircularProgressIndicator(),
                        ),
                      );
                    }
                    if (snapshot.hasError) {
                      return Container(
                        child: Center(
                          child: Text(snapshot.error),
                        ),
                      );
                    }
                    if (snapshot.hasData && snapshot.data.results.isEmpty)
                      return Container(
                        child: const Center(
                          child: Text('Search PUJS by username'),
                        ),
                      );
                    return ListView.builder(
                      itemCount: snapshot.data.results.length,
                      itemBuilder: (BuildContext context, int index) {
                        final UserProfile data = snapshot.data.results[index];
                        return ListTile(
                          title: Text(data.name),
                          subtitle: Text(data.username),
                        );
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
