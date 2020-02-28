import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:provider/provider.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/widgets/drawer/channel_preview.dart';

class FilterDrawer extends StatefulWidget {
  const FilterDrawer({this.filterByChannel, this.channels, this.resetChannels});
  final ValueChanged<Channel> filterByChannel;
  final List<String> channels;
  final Function resetChannels;

  @override
  _FilterDrawerState createState() => _FilterDrawerState();
}

class _FilterDrawerState extends State<FilterDrawer> {
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
    final double statusBarHeight = MediaQuery.of(context).padding.top + 12.0;
    return SizedBox(
      width: MediaQuery.of(context).size.width * .93,
      child: Drawer(
        elevation: 0,
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xff333333),
          ),
          padding: EdgeInsets.only(top: statusBarHeight),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                  border: Border(
                    bottom: BorderSide(color: Color(0xff444444), width: .75),
                  ),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
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
                          hintText: 'Filter by channel',
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).primaryColorLight),
                        ),
                        onChanged: _onTextChange,
                        cursorColor: Colors.white,
                        cursorWidth: 1,
                        maxLines: 1,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                        maxLength: 80,
                        textInputAction: TextInputAction.done,
                      ),
                    ),
                  ],
                ),
              ),
              widget.channels.isNotEmpty
                  ? Container(
                      margin:
                          const EdgeInsets.only(left: 10, top: 15, bottom: 15),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      decoration: BoxDecoration(
                          color: const Color(0xff555555),
                          borderRadius: BorderRadius.circular(10)),
                      child: Text(
                        widget.channels[0],
                        style:
                            const TextStyle(fontSize: 14, color: Colors.white),
                      ),
                    )
                  : const SizedBox(),
              Expanded(
                child: FutureBuilder<QueryResults<Channel>>(
                  future: _searchRepo.searchChannel(query),
                  builder: (
                    BuildContext context,
                    AsyncSnapshot<QueryResults<Channel>> snapshot,
                  ) {
                    if (snapshot.hasData && !snapshot.hasError) {
                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 0),
                        itemCount: snapshot.data.results.length,
                        itemBuilder: (BuildContext context, int index) {
                          final Channel item = snapshot.data.results[index];

                          return InkWell(
                            onTap: () {
                              widget.filterByChannel(item);
                              Navigator.pop(context);
                            },
                            child: FilterDrawerChannelPreview(
                              channel: item,
                            ),
                          );
                        },
                      );
                    }
                    if (snapshot.hasError) {
                      return Container(
                        child: Center(
                          child: Text(
                            snapshot.error.toString(),
                          ),
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
              GestureDetector(
                onTap: () {
                  widget.resetChannels();
                },
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    bottom: 25,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xff3F3F3F),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.center,
                        child: const Text(
                          'RESET',
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              letterSpacing: 1.7),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
