import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:junto_beta_mobile/screens/packs/pack_open/pack_name.dart';
import 'package:junto_beta_mobile/screens/packs/pack_open/pack_open_appbar.dart';
import 'package:junto_beta_mobile/screens/packs/pack_open/pack_tabs.dart';
import 'package:junto_beta_mobile/screens/packs/packs_bloc/pack_bloc.dart';
import 'package:junto_beta_mobile/utils/junto_overlay.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/end_drawer_relationships/error_widget.dart';

class PackOpen extends StatelessWidget {
  const PackOpen({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PackBloc, PackState>(
      builder: (context, state) {
        if (state is PacksLoaded) {
          return PacksLoadedScaffold(state);
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
  }) : super(key: key);

  final PacksLoaded state;
  final List<String> _tabs = const <String>['Pack', 'Private', 'Members'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: PreferredSize(
      //   preferredSize: const Size.fromHeight(50),
      //   child: PackOpenAppbar(
      //     pack: state.pack,
      //   ),
      // ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: DefaultTabController(
        length: _tabs.length,
        child: CustomScrollView(
          slivers: <Widget>[
            SliverPersistentHeader(
              delegate: PackOpenAppbar(
                pack: state.pack,
                expandedHeight: MediaQuery.of(context).size.height * .1 + 50,
                tabs: _tabs,
              ),
              pinned: false,
              floating: true,
            ),

            // PackTabs(group: state.pack),
          ],
        ),
      ),
    );
  }
}
