import 'package:flutter/material.dart';

class PackOpenPublic extends StatefulWidget {
  const PackOpenPublic({
    Key key,
    @required this.onScrollChanged,
  }) : super(key: key);
  final ValueChanged<bool> onScrollChanged;

  @override
  _PackOpenPublicState createState() => _PackOpenPublicState();
}

class _PackOpenPublicState extends State<PackOpenPublic> {
  ScrollController _packOpenPublicController;
  @override
  void initState() {
    super.initState();
    _packOpenPublicController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _packOpenPublicController.position.isScrollingNotifier.addListener(
        _onScrollingHasChanged,
      );
    });
  }

  void _onScrollingHasChanged() {
    widget.onScrollChanged(
      !_packOpenPublicController.position.isScrollingNotifier.value,
    );
  }

  @override
  void dispose() {
    _packOpenPublicController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: _packOpenPublicController,
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
