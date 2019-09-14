import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/screens/collective/filter_fab/filter_fab.dart';
import 'package:junto_beta_mobile/palette.dart';
import 'package:junto_beta_mobile/styles.dart';

class CollectiveFilterScreen extends StatelessWidget {
  const CollectiveFilterScreen({
    Key key,
    @required this.isVisible,
    @required this.toggleFilter,
  }) : super(key: key);

  /// ValueNotifier which controls whether the Filter screen is shown or not.
  final ValueNotifier<bool> isVisible;

  /// Callback triggered when the user toggle's the filter
  final Function toggleFilter;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      bottomNavigationBar: Container(color: Colors.white, height: 45),
      floatingActionButton:
          CollectiveFilterFAB(isVisible: isVisible, toggleFilter: toggleFilter),
      body: Stack(
        children: <Widget>[
          Positioned(
            top: 0,
            left: 0,
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: JuntoStyles.horizontalPadding, vertical: 45),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: <Widget>[
                  Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: JuntoPalette.juntoFade,
                          width: 1,
                        ),
                      ),
                    ),
                    child: TextField(
                      buildCounter: (
                        BuildContext context, {
                        int currentLength,
                        int maxLength,
                        bool isFocused,
                      }) =>
                          null,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'filter by channel',
                      ),
                      cursorColor: JuntoPalette.juntoGrey,
                      cursorWidth: 2,
                      style: JuntoStyles.filterChannelText,
                      maxLines: 1,
                      maxLength: 80,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
