import 'dart:async';

import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/widgets/previews/channel_preview.dart';
import 'package:provider/provider.dart';

class JuntoChannels extends StatefulWidget {
  const JuntoChannels({this.currentPerspective, this.onChannelSelected});

  final String currentPerspective;
  final ValueChanged<Channel> onChannelSelected;

  @override
  State<StatefulWidget> createState() {
    return JuntoChannelsState();
  }
}

class JuntoChannelsState extends State<JuntoChannels> {
  TextEditingController textEditingController;
  SearchRepo _searchRepo;
  String query;
  Timer _timer;

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _searchRepo = Provider.of<SearchRepo>(context);
  }

  @override
  void dispose() {
    super.dispose();
    textEditingController.dispose();
  }

  void _onTextChange(String value) {
    if (_timer != null) {
      _timer.cancel();
    }
    _timer = Timer(
      const Duration(milliseconds: 300),
      () => _updateQuery(
        value,
      ),
    );
  }

  void _updateQuery(String value) {
    setState(() {
      query = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height - 150,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            height: 80,
            color: Theme.of(context).backgroundColor,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Image.asset('assets/images/junto-mobile__binoculars.png',
                    height: 17, color: Theme.of(context).primaryColor),
                const SizedBox(width: 10),
                Text(
                  widget.currentPerspective,
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).primaryColor),
                )
              ],
            ),
          ),
          Container(
            height: 70,
            color: Theme.of(context).backgroundColor,
            // color: Colors.green,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Transform.translate(
                    offset: const Offset(0.0, 10.0),
                    child: TextField(
                      controller: textEditingController,
                      buildCounter: (
                        BuildContext context, {
                        int currentLength,
                        int maxLength,
                        bool isFocused,
                      }) =>
                          null,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(0.0),
                        hintText: 'filter by channel',
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
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).primaryColor),
                      maxLength: 80,
                      textInputAction: TextInputAction.done,
                      onChanged: _onTextChange,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<QueryResults<Channel>>(
              future: _searchRepo.searchChannel(query),
              builder: (
                BuildContext context,
                AsyncSnapshot<QueryResults<Channel>> snapshot,
              ) {
                if (snapshot.hasData && !snapshot.hasError) {
                  return ListView.builder(
                    itemCount: snapshot.data.results.length,
                    itemBuilder: (BuildContext context, int index) {
                      final Channel item = snapshot.data.results[index];
                      return InkWell(
                        onTap: () => widget.onChannelSelected(item),
                        child: ChannelPreview(
                          channel: item.name,
                        ),
                      );
                    },
                  );
                }
                if (snapshot.hasData && snapshot.data.results.isEmpty) {
                  return Container(
                    child: const Center(
                      child: Text('Add new channel +'),
                    ),
                  );
                }
                if (snapshot.hasError) {
                  return Container(
                    child: Center(
                      child: Text(snapshot.error.toString()),
                    ),
                  );
                }
                return Container(
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
