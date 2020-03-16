import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/widgets/drawer/channel_preview.dart';
import 'package:provider/provider.dart';

class FilterDrawerContent extends StatefulWidget {
  const FilterDrawerContent({
    @required this.filterByChannel,
    @required this.channels,
    @required this.resetChannels,
  });

  final ValueChanged<Channel> filterByChannel;
  final List<String> channels;
  final Function resetChannels;

  @override
  _FilterDrawerContentState createState() => _FilterDrawerContentState();
}

class _FilterDrawerContentState extends State<FilterDrawerContent> {
  TextEditingController textEditingController;
  SearchRepo _searchRepo;
  List<Channel> channels;

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController()
      ..addListener(_onSearchChanged);
  }

  Future<void> _onSearchChanged() async {
    final QueryResults<Channel> newChannels =
        await _searchRepo.searchChannel(textEditingController.text);
    setState(() {
      print(channels);
      channels = newChannels.results;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _searchRepo = Provider.of<SearchRepo>(context);
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xff2A2A2A),
      width: MediaQuery.of(context).size.width * .93,
      child: SafeArea(
        child: GestureDetector(
          onTap: () {
            if (FocusScope.of(context).hasFocus) {
              FocusScope.of(context).unfocus();
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const FilterLogo(),
                Flexible(
                  child: Column(
                    children: <Widget>[
                      FilterDrawerTextField(
                        textEditingController: textEditingController,
                      ),
                      if (widget.channels.isNotEmpty)
                        SelectedChannel(channels: widget.channels),
                      if (channels != null)
                        Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.all(0),
                            itemCount: channels.length,
                            itemBuilder: (BuildContext context, int index) {
                              final Channel item = channels[index];
                              if (item != null) {
                                return InkWell(
                                  onTap: () {
                                    widget.filterByChannel(item);
                                    textEditingController.clear();
                                    Navigator.pop(context);
                                  },
                                  child: FilterDrawerChannelPreview(
                                    channel: item,
                                  ),
                                );
                              } else {
                                return Container();
                              }
                            },
                          ),
                        ),
                    ],
                  ),
                ),
                ResetFilterButton(onTap: widget.resetChannels)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SelectedChannel extends StatelessWidget {
  const SelectedChannel({
    Key key,
    @required this.channels,
  }) : super(key: key);

  final List<String> channels;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.topStart,
      child: Wrap(
          alignment: WrapAlignment.start,
          direction: Axis.horizontal,
          children: <SelectedChannelChip>[
            ...channels.map(
              (String e) => SelectedChannelChip(channel: e),
            )
          ]),
    );
  }
}

class SelectedChannelChip extends StatelessWidget {
  const SelectedChannelChip({
    Key key,
    @required this.channel,
  }) : super(key: key);

  final String channel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      margin: const EdgeInsets.only(top: 15),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColorLight,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        channel,
        style: const TextStyle(fontSize: 12, color: Colors.white),
      ),
    );
  }
}

class ResetFilterButton extends StatelessWidget {
  const ResetFilterButton({
    Key key,
    @required this.onTap,
  }) : super(key: key);

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 16.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: FlatButton(
          color: const Color(0xff444444),
          onPressed: onTap,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40.0),
          ),
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Text(
              'RESET',
              style: TextStyle(
                letterSpacing: 1.7,
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class FilterDrawerTextField extends StatelessWidget {
  const FilterDrawerTextField({
    Key key,
    @required this.textEditingController,
  }) : super(key: key);

  final TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xff444444),
            width: .75,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: textEditingController,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(0),
                border: InputBorder.none,
                counter: Container(),
                hintText: 'Filter by channel',
                hintStyle: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xff999999),
                ),
              ),
              cursorColor: Colors.white,
              cursorWidth: 1,
              maxLines: 1,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
              maxLength: 80,
              textInputAction: TextInputAction.done,
            ),
          ),
          GestureDetector(
            onTap: () {
              textEditingController.clear();
            },
            child: Container(
              padding: const EdgeInsets.only(left: 15),
              child: Icon(
                CustomIcons.cancel,
                size: 24,
                color: const Color(0xff999999),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class FilterLogo extends StatelessWidget {
  const FilterLogo({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      child: Row(
        children: <Widget>[
          Image.asset(
            'assets/images/junto-mobile__logo.png',
            color: Colors.white,
            height: 24,
          ),
        ],
      ),
    );
  }
}
