import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:junto_beta_mobile/filters/bloc/channel_filtering_bloc.dart';
import 'package:junto_beta_mobile/models/expression_query_params.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/widgets/drawer/channel_preview.dart';
import 'package:junto_beta_mobile/widgets/drawer/widgets/widgets.dart';
import 'package:provider/provider.dart';

class FilterDrawerContent extends StatefulWidget {
  const FilterDrawerContent(this.contextType);

  final ExpressionContextType contextType;

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
    final focusNode = Provider.of<FocusNode>(context, listen: false);
    return BlocBuilder<ChannelFilteringBloc, ChannelFilteringState>(
        builder: (BuildContext context, ChannelFilteringState state) {
      List<Channel> filteredList = [];

      if (state is ChannelsPopulatedState) {
        final selectedSet = state.selectedChannel != null
            ? state.selectedChannel.map((e) => e.name).toList()
            : [];
        filteredList = state.channels
            .where((element) => !selectedSet.contains(element.name))
            .toList();
      }

      return FilterDrawerWrapper(
        focusNode: focusNode,
        children: <Widget>[
          const FilterLogo(),
          Flexible(
            child: Column(
              children: <Widget>[
                FilterDrawerTextField(
                  textEditingController: textEditingController,
                  focusNode: focusNode,
                ),
                if (state is ChannelsPopulatedState &&
                    state.selectedChannel != null)
                  Row(
                    children: [
                      ...state.selectedChannel
                          .map((e) => SelectedChannelChip(
                              channel: e.name,
                              onTap: () {
                                context.bloc<ChannelFilteringBloc>().add(
                                      FilterSelected(
                                        state.selectedChannel
                                            .where((element) =>
                                                element.name != e.name)
                                            .toList(),
                                        widget.contextType,
                                      ),
                                    );
                              }))
                          .toList(),
                    ],
                  ),
                if (state is ChannelsPopulatedState)
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(0),
                      itemCount: filteredList.length,
                      itemBuilder: (BuildContext context, int index) {
                        final Channel item = filteredList[index];
                        if (item != null) {
                          return InkWell(
                            onTap: () {
                              context.bloc<ChannelFilteringBloc>().add(
                                      FilterSelected([
                                    if (state.selectedChannel != null)
                                      ...state.selectedChannel,
                                    item
                                  ], widget.contextType));
                              textEditingController.clear();
                              // Navigator.pop(context);
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
  const FilterDrawerWrapper({
    Key key,
    @required this.children,
    this.focusNode,
  }) : super(key: key);

  final List<Widget> children;
  final FocusNode focusNode;

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
            focusNode.unfocus();
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
