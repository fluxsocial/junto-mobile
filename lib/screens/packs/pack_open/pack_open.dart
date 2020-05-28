import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:junto_beta_mobile/screens/packs/pack_open/pack_open_appbar.dart';
import 'package:junto_beta_mobile/screens/packs/pack_open/pack_tabs.dart';
import 'package:junto_beta_mobile/screens/packs/packs_bloc/pack_bloc.dart';
import 'package:junto_beta_mobile/utils/junto_overlay.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/end_drawer_relationships/error_widget.dart';
import 'package:junto_beta_mobile/screens/packs/pack_open/pack_actions_button.dart';

class PackOpen extends StatelessWidget {
  const PackOpen({
    Key key,
    this.packsViewNav,
    this.isVisible,
  }) : super(key: key);

  final Function packsViewNav;
  final ValueNotifier<bool> isVisible;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PackBloc, PackState>(
      builder: (context, state) {
        if (state is PacksLoaded) {
          return PacksLoadedScaffold(
            state,
            packsViewNav: packsViewNav,
            isVisible: isVisible,
          );
        }
        if (state is PacksError) {
          return JuntoErrorWidget(
            errorMessage: 'Something went wrong',
          );
        } else {
          return JuntoLoader();
        }
      },
    );
  }
}

class PacksLoadedScaffold extends StatelessWidget {
  const PacksLoadedScaffold(
    this.state, {
    Key key,
    this.packsViewNav,
    this.isVisible,
  }) : super(key: key);

  final PacksLoaded state;
  final List<String> _tabs = const <String>['Pack', 'Private', 'Members'];
  final Function packsViewNav;
  final ValueNotifier<bool> isVisible;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: PacksActionButtons(
        isVisible: isVisible,
      ),
      body: DefaultTabController(
        length: _tabs.length,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool boxIsScrolled) {
            return <Widget>[
              SliverPersistentHeader(
                delegate: PackOpenAppbar(
                  pack: state.pack,
                  expandedHeight: MediaQuery.of(context).size.height * .11 + 50,
                  tabs: _tabs,
                  packsViewNav: packsViewNav,
                ),
                floating: true,
                pinned: false,
              ),
            ];
          },
          body: PackTabs(group: state.pack),
        ),
      ),
    );
  }
}
