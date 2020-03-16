import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:junto_beta_mobile/filters/bloc/channel_filtering_bloc.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/widgets/drawer/channel_preview.dart';
import 'package:junto_beta_mobile/widgets/drawer/widgets/widgets.dart';

class FilterDrawerContent extends StatefulWidget {
  const FilterDrawerContent(this.contextType);

  final String contextType;

  @override
  _FilterDrawerContentState createState() => _FilterDrawerContentState();
}

class _FilterDrawerContentState extends State<FilterDrawerContent> {
  TextEditingController textEditingController;

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController()
      ..addListener(_onSearchChanged);
  }

  Future<void> _onSearchChanged() async {
    context
        .bloc<ChannelFilteringBloc>()
        .add(FilterQueryUpdated(textEditingController.text));
  }

  @override
  void dispose() {
    textEditingController.removeListener(_onSearchChanged);
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChannelFilteringBloc, ChannelFilteringState>(
        builder: (BuildContext context, ChannelFilteringState state) {
      return FilterDrawerWrapper(
        children: <Widget>[
          const FilterLogo(),
          Flexible(
            child: Column(
              children: <Widget>[
                FilterDrawerTextField(
                  textEditingController: textEditingController,
                ),
                if (state is ChannelsPopulatedState &&
                    state.selectedChannel != null)
                  SelectedChannel(channel: state.selectedChannel),
                if (state is ChannelsPopulatedState)
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(0),
                      itemCount: state.channels.length,
                      itemBuilder: (BuildContext context, int index) {
                        final Channel item = state.channels[index];
                        if (item != null) {
                          return InkWell(
                            onTap: () {
                              context.bloc<ChannelFilteringBloc>().add(
                                  FilterSelected(item, widget.contextType));
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
          ResetFilterButton(
            onTap: () =>
                context.bloc<ChannelFilteringBloc>().add(FilterReset()),
          ),
        ],
      );
    });
  }
}

class FilterDrawerWrapper extends StatelessWidget {
  const FilterDrawerWrapper({Key key, @required this.children})
      : super(key: key);

  final List<Widget> children;

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
              children: children,
            ),
          ),
        ),
      ),
    );
  }
}
