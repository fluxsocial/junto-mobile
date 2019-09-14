import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/screens/create/create_actions/create_actions_appbar/create_actions_appbar.dart';
import 'package:junto_beta_mobile/palette.dart';

class CreateActions extends StatefulWidget {
  const CreateActions({
    Key key,
    @required this.expressionLayer,
  }) : super(key: key);

  final String expressionLayer;

  @override
  State<StatefulWidget> createState() => CreateActionsState();
}

class CreateActionsState extends State<CreateActions> {
  final List<String> _channels = <String>[];

  // instantiate TextEditingController to pass to TextField widget
  TextEditingController _channelController;

  @override
  void initState() {
    super.initState();
    _channelController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _channelController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(45),
        child: CreateActionsAppbar(),
      ),
      body: ListView(
        children: <Widget>[
          GestureDetector(
            onTap: () => _buildChannelsModal(context),
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Color(0xffeeeeee),
                    width: 1,
                  ),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: const Text(
                'add channels',
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              _buildLayersModal(context);
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Color(0xffeeeeee),
                    width: 1,
                  ),
                ),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 20,
              ),
              child: Text(
                'sharing to ' + widget.expressionLayer,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Build bottom modal to add channels to expression
  void _buildChannelsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        // Use StatefulBuilder to pass state of CreateActions
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter state) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width * .75,
                          child: TextField(
                            controller: _channelController,
                            buildCounter: (BuildContext context,
                                    {int currentLength,
                                    int maxLength,
                                    bool isFocused}) =>
                                null,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: '# add up to three channels',
                            ),
                            cursorColor: JuntoPalette.juntoGrey,
                            cursorWidth: 2,
                            style: const TextStyle(
                              color: Color(
                                0xff333333,
                              ),
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                            maxLines: 1,
                            maxLength: 80,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          child: GestureDetector(
                            onTap: () {
                              // Update channels list in state until there are 3
                              _channels.length < 3
                                  ? _updateChannels(
                                      state,
                                      _channelController.text,
                                    )
                                  : _nullChannels();
                            },
                            child: const Text(
                              'add',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Color(0xff333333),
                              ),
                            ),
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: const Color(0xff333333), width: 1),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ],
                    ),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Color(0xffeeeeee),
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: _channels.isEmpty
                        ? const EdgeInsets.all(0)
                        : const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        _channels.isEmpty
                            ? const SizedBox()
                            : Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                child: const Text(
                                  'DOUBLE TAP TO REMOVE CHANNEL',
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                        Wrap(
                          runSpacing: 5,
                          alignment: WrapAlignment.start,
                          direction: Axis.horizontal,
                          children: _channels
                              .map(
                                (String channel) => GestureDetector(
                                      onDoubleTap: () =>
                                          _removeChannel(state, channel),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          border: Border.all(
                                            color: const Color(0xff333333),
                                            width: 1,
                                          ),
                                        ),
                                        margin: const EdgeInsets.only(
                                          right: 10,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 5,
                                        ),
                                        child: Text(
                                          channel,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ),
                              )
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // Update the list of channels in state
  void _updateChannels(StateSetter updateState, String channel) {
    updateState(() {
      if (channel != '') {
        _channels.add(channel);

        _channelController.text = '';
      }
    });
  }

  // Remove a channel from the list of channels in state
  void _removeChannel(StateSetter updateState, String channel) {
    updateState(() {
      _channels.remove(channel);
    });
  }

  // Called when channels.length > x
  void _nullChannels() {
    return;
  }

  // Build bottom modal to add channels to expression
  void _buildLayersModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        // Use StatefulBuilder to pass state of CreateActions
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter state) {
            return Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width * .75,
                          color: Colors.white,
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
                              border: InputBorder.none,
                              hintText: 'choose where to share your expression',
                            ),
                            cursorColor: JuntoPalette.juntoGrey,
                            cursorWidth: 2,
                            style: const TextStyle(
                              color: Color(0xff333333),
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                            maxLines: 1,
                            maxLength: 80,
                          ),
                        ),
                      ],
                    ),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Color(0xffeeeeee), width: 1),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
