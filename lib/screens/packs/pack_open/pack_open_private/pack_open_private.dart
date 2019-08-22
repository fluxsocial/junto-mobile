import 'package:flutter/material.dart';

class PackOpenPrivate extends StatefulWidget {
  const PackOpenPrivate({
    Key key,
    @required this.onScrollChanged,
  }) : super(key: key);
  final ValueChanged<bool> onScrollChanged;

  @override
  _PackOpenPrivateState createState() => _PackOpenPrivateState();
}

class _PackOpenPrivateState extends State<PackOpenPrivate> {
  ScrollController _packOpenClosedController;

  @override
  void initState() {
    super.initState();
    _packOpenClosedController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _packOpenClosedController.position.isScrollingNotifier.addListener(
        _onScrollingHasChanged,
      );
    });
  }

  void _onScrollingHasChanged() {
    widget.onScrollChanged(
      !_packOpenClosedController.position.isScrollingNotifier.value,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: _packOpenClosedController,
      children: List<Widget>.generate(
        35,
        (int index) {
          return const Padding(
            padding: EdgeInsets.all(8.0),
            child: Placeholder(),
          );
        },
      ),
    );
  }
}
