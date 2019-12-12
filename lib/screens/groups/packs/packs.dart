import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/utils/utils.dart';
import 'package:junto_beta_mobile/widgets/previews/pack_preview.dart';
import 'package:junto_beta_mobile/widgets/utils/hide_fab.dart';

// This class renders the screen of packs a user belongs to
class JuntoPacks extends StatefulWidget {
  const JuntoPacks({this.visibility, this.userProfile, this.userPacks});

  final ValueNotifier<bool> visibility;
  final UserData userProfile;
  final userPacks;

  @override
  State<StatefulWidget> createState() => JuntoPacksState();
}

class JuntoPacksState extends State<JuntoPacks> with ListDistinct, HideFab {
  ScrollController _packsScrollController;

  @override
  void initState() {
    super.initState();
    _packsScrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _packsScrollController.addListener(_onScrollingHasChanged);
      if (_packsScrollController.hasClients)
        _packsScrollController.position.isScrollingNotifier.addListener(
          _onScrollingHasChanged,
        );
    });
  }

  void _onScrollingHasChanged() {
    super.hideFabOnScroll(_packsScrollController, widget.visibility);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _packsScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: ListView(
        controller: _packsScrollController,
        children: <Widget>[
          for (Group group in widget.userPacks)
            PackPreview(
              group: group,
            ),
        ],
      ),
    );
  }
}
