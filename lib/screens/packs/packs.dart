import 'package:async/async.dart' show AsyncMemoizer;
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/styles.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/backend/mock/mock_packs.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/utils/utils.dart';
import 'package:junto_beta_mobile/widgets/previews/pack_preview.dart';
import 'package:provider/provider.dart';
import 'package:junto_beta_mobile/widgets/utils/hide_fab.dart';

// This class renders the screen of packs a user belongs to
class JuntoPacks extends StatefulWidget {
  const JuntoPacks({this.visibility});
  final visibility;
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
      _packsScrollController.position.isScrollingNotifier.addListener(
        _onScrollingHasChanged,
      );
    });
  }

  _onScrollingHasChanged() {
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

  Widget buildError() {
    return Center(
      child: Container(
        height: 300.0,
        width: 300.0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/images/junto-mobile__logo.png',
              height: 50.0,
            ),
            const SizedBox(height: 12.0),
            const Text(
              'Something went wrong :(',
              style: JuntoStyles.body,
            ),
          ],
        ),
      ),
    );
  }

  List<Group> _packs = MockPackService().packs;

  @override
  void dispose() {
    _packsScrollController.dispose();
    _packsScrollController.removeListener(
      _onScrollingHasChanged(),
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: ListView(controller: _packsScrollController, children: <Widget>[
        PackPreview(group: _packs[0]),
        PackPreview(group: _packs[1]),
        PackPreview(group: _packs[2]),
        PackPreview(group: _packs[3]),
        PackPreview(group: _packs[4]),
        PackPreview(group: _packs[5]),
        PackPreview(group: _packs[6]),
        PackPreview(group: _packs[7]),
        PackPreview(group: _packs[8]),
        PackPreview(group: _packs[9]),
        PackPreview(group: _packs[10]),
        PackPreview(group: _packs[11]),
        PackPreview(group: _packs[12]),
        PackPreview(group: _packs[13]),
      ]),
      // FutureBuilder<UserGroupsResponse>(
      //   future: getUserPacks(),
      //   builder:
      //       (BuildContext context, AsyncSnapshot<UserGroupsResponse> snapshot) {
      //     if (snapshot.hasError) {
      //       return buildError();
      //     }
      //     if (snapshot.hasData && !snapshot.hasError) {
      //       final List<Group> ownedGroups = snapshot.data.owned;
      //       final List<Group> associatedGroups = snapshot.data.associated;
      //       final List<Group> userGroups =
      //           distinct<Group>(ownedGroups, associatedGroups)
      //               .where((Group group) => group.groupType == 'Pack')
      //               .toList();
      //       return ListView(
      //         children: <Widget>[
      //           for (Group group in userGroups)
      //             PackPreview(
      //               group: group,
      //             ),
      //         ],
      //       );
      //     }
      //     return Container(
      //       height: 100.0,
      //       width: 100.0,
      //       child: const Center(
      //         child: CircularProgressIndicator(),
      //       ),
      //     );
      //   },
      // ),
    );
  }
}
