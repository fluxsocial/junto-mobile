import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:junto_beta_mobile/filters/bloc/channel_filtering_bloc.dart';
import 'package:junto_beta_mobile/models/expression_query_params.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/widgets/drawer/channel_preview.dart';
import 'package:junto_beta_mobile/widgets/drawer/widgets/widgets.dart';
import 'package:junto_beta_mobile/screens/collective/perspectives/perspectves_list.dart';
import './filter_reset_button.dart';

class FilterDrawerNew extends StatefulWidget {
  const FilterDrawerNew({this.collectiveScreen});

  final bool collectiveScreen;
  @override
  State<StatefulWidget> createState() {
    return FilterDrawerNewState();
  }
}

class FilterDrawerNewState extends State<FilterDrawerNew> {
  FocusNode focusNode;
  double channelsContainerHeight = 200.0;
  TextEditingController textEditingController;
  int _currentIndex = 0;
  PageController pageViewController;

  animateChannelsContainer() {
    if (focusNode.hasFocus) {
      setState(() {
        channelsContainerHeight = 500.0;
      });
    } else {
      setState(() {
        channelsContainerHeight = 200.0;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode()..addListener(animateChannelsContainer);

    textEditingController = TextEditingController()
      ..addListener(_onSearchChanged);
    pageViewController = PageController();

    context.bloc<ChannelFilteringBloc>().add(FilterClear());
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

  void setCurrentIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChannelFilteringBloc, ChannelFilteringState>(
        builder: (BuildContext context, ChannelFilteringState state) {
      List<Channel> filteredList = [];

      if (state is ChannelsPopulatedState) {
        final selectedSet = state.selectedChannel != null
            ? state.selectedChannel.map((e) => e.name).toList()
            : [];
        filteredList = focusNode.hasFocus
            ? state.channels
                .where((element) => !selectedSet.contains(element.name))
                .toList()
            : [];
      }
      return Container(
        color: Colors.transparent,
        child: Container(
          height: MediaQuery.of(context).size.height * .9,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(
                  top: 15,
                  bottom: 15,
                ),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Transform.translate(
                        offset: Offset(-10, 0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: Icon(
                              Icons.keyboard_arrow_down,
                              size: 38,
                              color: Theme.of(context).primaryColorLight,
                            ),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              pageViewController.animateToPage(
                                0,
                                duration: Duration(milliseconds: 200),
                                curve: Curves.easeIn,
                              );
                            },
                            child: ClipOval(
                              child: Container(
                                height: 38,
                                width: 38,
                                color: _currentIndex == 0
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context).dividerColor,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/images/junto-mobile__custom-filter.png',
                                      height: 15,
                                      color: _currentIndex == 0
                                          ? Colors.white
                                          : Theme.of(context).primaryColorDark,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          if (widget.collectiveScreen)
                            GestureDetector(
                              onTap: () {
                                pageViewController.animateToPage(
                                  1,
                                  duration: Duration(milliseconds: 200),
                                  curve: Curves.easeIn,
                                );
                              },
                              child: Container(
                                margin: const EdgeInsets.only(left: 10),
                                child: ClipOval(
                                  child: Container(
                                    height: 38,
                                    width: 38,
                                    color: _currentIndex == 1
                                        ? Theme.of(context).colorScheme.primary
                                        : Theme.of(context).dividerColor,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          'assets/images/junto-mobile__perspective--white.png',
                                          height: 15,
                                          color: _currentIndex == 1
                                              ? Colors.white
                                              : Theme.of(context)
                                                  .primaryColorDark,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ]),
              ),

              // Filter Pages
              Expanded(
                child: PageView(
                  controller: pageViewController,
                  physics: NeverScrollableScrollPhysics(),
                  onPageChanged: (int index) {
                    setCurrentIndex(index);
                  },
                  children: [
                    // Custom Filter (starting with channels in V1)
                    Stack(
                      alignment: AlignmentDirectional.centerStart,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Filter',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            const SizedBox(height: 25),
                            AnimatedContainer(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Theme.of(context).dividerColor,
                                borderRadius: BorderRadius.circular(25),
                              ),
                              width: MediaQuery.of(context).size.width,
                              height: channelsContainerHeight,
                              duration: Duration(milliseconds: 200),
                              child: Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 5),
                                      child: Text(
                                        'Channels',
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Theme.of(context)
                                              .primaryColorDark,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                    FilterDrawerTextField(
                                      textEditingController:
                                          textEditingController,
                                      focusNode: focusNode,
                                    ),
                                    if (state is ChannelsPopulatedState &&
                                        state.selectedChannel != null)
                                      Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 5),
                                        child: Row(
                                          children: [
                                            ...state.selectedChannel
                                                .map((e) => SelectedChannelChip(
                                                    channel: e.name,
                                                    onTap: () {
                                                      context
                                                          .bloc<
                                                              ChannelFilteringBloc>()
                                                          .add(
                                                            FilterSelected(
                                                              state
                                                                  .selectedChannel
                                                                  .where((element) =>
                                                                      element
                                                                          .name !=
                                                                      e.name)
                                                                  .toList(),
                                                              ExpressionContextType
                                                                  .Collective,
                                                            ),
                                                          );
                                                    }))
                                                .toList(),
                                          ],
                                        ),
                                      ),
                                    if (state is ChannelsPopulatedState)
                                      Expanded(
                                        child: ListView.builder(
                                          padding: const EdgeInsets.all(0),
                                          itemCount: filteredList.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            final Channel item =
                                                filteredList[index];
                                            if (item != null) {
                                              return InkWell(
                                                onTap: () {
                                                  context
                                                      .bloc<
                                                          ChannelFilteringBloc>()
                                                      .add(FilterSelected(
                                                        [
                                                          if (state
                                                                  .selectedChannel !=
                                                              null)
                                                            ...state
                                                                .selectedChannel,
                                                          item
                                                        ],
                                                        ExpressionContextType
                                                            .Collective,
                                                      ));
                                                  textEditingController.clear();
                                                  // Navigator.pop(context);
                                                },
                                                child:
                                                    FilterDrawerChannelPreview(
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
                            ),
                          ],
                        ),
                        Positioned(
                          bottom: 0.0,
                          left: -4.0,
                          child: FilterResetButton(
                            onTap: () {
                              context
                                  .bloc<ChannelFilteringBloc>()
                                  .add(FilterReset());
                            },
                          ),
                        )
                      ],
                    ),
                    if (widget.collectiveScreen)
                      // Perspectives
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Relations',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          const SizedBox(height: 25),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'ALL',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: Theme.of(context).primaryColor,
                                    letterSpacing: .5,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Theme.of(context).dividerColor,
                                  ),
                                  child: Icon(
                                    Icons.add,
                                    color: Theme.of(context).primaryColor,
                                    size: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          PerspectivesList()
                        ],
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 10),
            ],
          ),
        ),
      );
    });
  }
}
