import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/widgets/utils/hide_fab.dart';

class PackOpenPrivate extends StatefulWidget {
  const PackOpenPrivate({
    Key key,
    @required this.fabVisible,
  }) : super(key: key);
  final ValueNotifier<bool> fabVisible;

  @override
  _PackOpenPrivateState createState() => _PackOpenPrivateState();
}

class _PackOpenPrivateState extends State<PackOpenPrivate> with HideFab {
  ScrollController _packOpenClosedController;

  @override
  void initState() {
    super.initState();
    _packOpenClosedController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _packOpenClosedController.addListener(_onScrollingHasChanged);
      _packOpenClosedController.position.isScrollingNotifier.addListener(
        _onScrollingHasChanged,
      );
    });
  }

  void _onScrollingHasChanged() {
    super.hideFabOnScroll(_packOpenClosedController, widget.fabVisible);
  }

  @override
  void dispose() {
    _packOpenClosedController.removeListener(_onScrollingHasChanged);
    _packOpenClosedController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(height: 15),
        Text(
          'Placeholder - this will contain private expressions of pack owner..',
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 15),
        Expanded(
          child: ListView(
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
          ),
        )
      ],
    );
  }
}
