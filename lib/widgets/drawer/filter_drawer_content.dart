import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/widgets/drawer/channel_preview.dart';
import 'package:provider/provider.dart';

class FilterDrawerContent extends StatefulWidget {
  const FilterDrawerContent(
      {this.filterByChannel, this.channels, this.resetChannels});

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
      color: Theme.of(context).primaryColorDark,
      width: MediaQuery.of(context).size.width * .93,
      child: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: FitlerDrawerTextField(
                        textEditingController: textEditingController,
                      ),
                    ),
                    if (widget.channels.isNotEmpty)
                      SelectedChannel(channels: widget.channels),
                    if (channels != null)
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 0),
                          itemCount: channels.length,
                          itemBuilder: (BuildContext context, int index) {
                            final Channel item = channels[index];

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Selected channel',
              style: TextStyle(color: Theme.of(context).primaryColorLight),
            ),
          ),
          Wrap(
            alignment: WrapAlignment.start,
            direction: Axis.horizontal,
            children: channels
                .map(
                  (String e) => SelectedChannelChip(channel: e),
                )
                .toList(),
          )
        ],
      ),
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
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(10)),
        child: Text(
          channel,
          style: const TextStyle(fontSize: 14, color: Colors.white),
        ),
      ),
    );
  }
}

class ResetFilterButton extends StatelessWidget {
  const ResetFilterButton({
    Key key,
    @required this.onTap,
  }) : super(key: key);

  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      child: FlatButton(
        color: Theme.of(context).primaryColor,
        onPressed: onTap,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.0)),
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
    );
  }
}

class FitlerDrawerTextField extends StatelessWidget {
  const FitlerDrawerTextField({
    Key key,
    @required this.textEditingController,
  }) : super(key: key);

  final TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        const FilterLogo(),
        Flexible(
          child: TextField(
            controller: textEditingController,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12.0,
              ),
              counter: Container(),
              hintText: 'Filter by channel',
              border: InputBorder.none,
              hintStyle: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).primaryColorLight,
              ),
              filled: true,
              fillColor: Theme.of(context).primaryColor,
              suffixIcon: ClearIcon(controller: textEditingController),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(color: Colors.black26),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(color: Colors.white24),
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
            keyboardAppearance: Theme.of(context).brightness,
          ),
        ),
      ],
    );
  }
}

class FilterLogo extends StatelessWidget {
  const FilterLogo({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 8.0,
        right: 8.0,
      ),
      child: Container(
        child: Image.asset(
          'assets/images/junto-mobile__logo--white.png',
          height: 24,
        ),
      ),
    );
  }
}

class ClearIcon extends StatelessWidget {
  const ClearIcon({
    Key key,
    @required this.controller,
  }) : super(key: key);

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      color: Colors.white54,
      icon: Icon(
        Icons.clear,
      ),
      onPressed: () {
        controller.clear();
      },
    );
  }
}
