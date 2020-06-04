import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/widgets/previews/channel_preview.dart';
import 'package:provider/provider.dart';

class ChannelSearchModal extends StatefulWidget {
  const ChannelSearchModal({
    Key key,
    @required this.channels,
  }) : super(key: key);
  final ValueNotifier<List<String>> channels;

  @override
  _ChannelSearchModalState createState() => _ChannelSearchModalState();
}

class _ChannelSearchModalState extends State<ChannelSearchModal> {
  SearchRepo _searchRepo;
  TextEditingController _channelController;
  String query;
  List<String> _channels;
  Timer _timer;

  @override
  void initState() {
    super.initState();
    _channelController = TextEditingController();
    _channels = widget.channels.value;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _searchRepo = Provider.of<SearchRepo>(context);
  }

  @override
  void didUpdateWidget(ChannelSearchModal oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.channels != widget.channels) {
      _channels = widget.channels.value;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _channelController.dispose();
  }

  void _addSelected() {
    if (_channelController.value.text != '' && _channels.length < 3) {
      setState(() {
        widget.channels.value.add(_channelController.value.text);
        widget.channels.value = _channels;
      });
      _channelController.value = const TextEditingValue(text: '');
    }
  }

  void _addItem(String name) {
    if (name != '' && _channels.length < 3) {
      setState(() {
        _channels.add(name);
      });
      _channelController.value = const TextEditingValue(text: '');
      widget.channels.value = _channels;
    }
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

  Widget _buildSearchField() {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Theme.of(context).dividerColor, width: .75),
        ),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _channelController,
              buildCounter: (
                BuildContext context, {
                int currentLength,
                int maxLength,
                bool isFocused,
              }) =>
                  null,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(0.0),
                hintText: 'add up to three channels',
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
              onChanged: _onTextChange,
            ),
          ),
          GestureDetector(
            onTap: _addSelected,
            child: Container(
              padding: const EdgeInsets.only(
                left: 10,
                right: 10,
                top: 5,
                bottom: 5,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                'Add',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBottomSelection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      // decoration: BoxDecoration(
      //   color: Theme.of(context).backgroundColor,
      //   border: Border(
      //     bottom: BorderSide(color: Theme.of(context).dividerColor, width: .75),
      //   ),
      // ),
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: <Widget>[
            for (String channel in _channels)
              GestureDetector(
                onDoubleTap: () {
                  setState(() {
                    _channels.removeAt(
                      _channels.indexOf(channel),
                    );
                  });
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 15),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).dividerColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    channel,
                    style: TextStyle(
                        fontSize: 14, color: Theme.of(context).primaryColor),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.opaque,
        child: Container(
          height: MediaQuery.of(context).size.height * .6,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildSearchField(),
              if (_channels.isNotEmpty) _buildBottomSelection(),
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
                              onTap: () => _addItem(item.name),
                              child: ChannelPreview(
                                channel: item,
                                resultCount: snapshot.data.resultCount,
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
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
