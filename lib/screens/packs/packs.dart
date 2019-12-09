import 'package:async/async.dart' show AsyncMemoizer;
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/utils/utils.dart';
import 'package:junto_beta_mobile/widgets/previews/pack_preview.dart';
import 'package:junto_beta_mobile/widgets/utils/hide_fab.dart';
import 'package:provider/provider.dart';
import 'package:junto_beta_mobile/widgets/progress_indicator.dart';

// This class renders the screen of packs a user belongs to
class JuntoPacks extends StatefulWidget {
  const JuntoPacks({this.visibility});

  final ValueNotifier<bool> visibility;

  @override
  State<StatefulWidget> createState() => JuntoPacksState();
}

class JuntoPacksState extends State<JuntoPacks> with ListDistinct, HideFab {
  UserRepo _userProvider;
  final AsyncMemoizer<UserGroupsResponse> _memoizer =
      AsyncMemoizer<UserGroupsResponse>();

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
    _userProvider = Provider.of<UserRepo>(context);
  }

  Future<UserGroupsResponse> getUserPacks() async {
    final UserData _profile = await _userProvider.readLocalUser();
    return _memoizer.runOnce(
      () async => _userProvider.getUserGroups(_profile.user.address),
    );
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
      child: FutureBuilder<UserGroupsResponse>(
        future: getUserPacks(),
        builder:
            (BuildContext context, AsyncSnapshot<UserGroupsResponse> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Transform.translate(
                offset: const Offset(0.0, -50),
                child: const Text('Hmmm, something is up with our servers'),
              ),
            );
          }
          if (snapshot.hasData && !snapshot.hasError) {
            final List<Group> ownedGroups = snapshot.data.owned;
            final List<Group> associatedGroups = snapshot.data.associated;
            final List<Group> userGroups =
                distinct<Group>(ownedGroups, associatedGroups)
                    .where((Group group) => group.groupType == 'Pack')
                    .toList();
            return ListView(
              controller: _packsScrollController,
              children: <Widget>[
                for (Group group in userGroups)
                  PackPreview(
                    group: group,
                  ),
              ],
            );
          }
          return Center(
            child: Transform.translate(
              offset: const Offset(0.0, -50),
              child: JuntoProgressIndicator(),
            ),
          );
        },
      ),
    );
  }
}
