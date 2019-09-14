import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/components/utils/hide_fab.dart';
import 'package:junto_beta_mobile/models/pack.dart';
import 'package:junto_beta_mobile/providers/packs_provider/packs_provider.dart';
import 'package:provider/provider.dart';

class PackOpenPublic extends StatefulWidget {
  const PackOpenPublic({
    Key key,
    @required this.fabVisible,
  }) : super(key: key);
  final ValueNotifier<bool> fabVisible;

  @override
  _PackOpenPublicState createState() => _PackOpenPublicState();
}

class _PackOpenPublicState extends State<PackOpenPublic> with HideFab {
  ScrollController _packOpenPublicController;
  PacksProvider _packsProvider;

  @override
  void initState() {
    super.initState();
    _packOpenPublicController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _packOpenPublicController.addListener(_onScrollingHasChanged);
      _packOpenPublicController.position.isScrollingNotifier.addListener(
        _onScrollingHasChanged,
      );
    });
  }

  void _onScrollingHasChanged() {
    super.hideFabOnScroll(_packOpenPublicController, widget.fabVisible);
  }

  @override
  void didChangeDependencies() {
    _packsProvider = Provider.of<PacksProvider>(context);
    printPackResponse();
    super.didChangeDependencies();
  }

  //TODO(Nash): We need to store the user address
  Future<void> printPackResponse() async {
    final List<PackResponse> response = await _packsProvider
        .getUserPacks('QmchnP6FXRC7k9bg1oSmXr7DePyYyV4hSB33XAd3K7mCJo,');
    print(response.toString());
  }

  @override
  void dispose() {
    _packOpenPublicController.removeListener(_onScrollingHasChanged);
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
