import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/app_config.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/packs/packs_bloc/pack_bloc.dart';
import 'package:junto_beta_mobile/utils/junto_overlay.dart';
import 'package:junto_beta_mobile/widgets/custom_feeds/custom_listview.dart';
import 'package:junto_beta_mobile/widgets/custom_feeds/filter_column_row.dart';
import 'package:junto_beta_mobile/widgets/custom_feeds/single_listview.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/end_drawer_relationships/error_widget.dart';
import 'package:junto_beta_mobile/widgets/fetch_more.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Linear list of expressions created by the given [userProfile].
class GroupExpressions extends StatefulWidget {
  const GroupExpressions({
    Key key,
    @required this.group,
    @required this.privacy,
  }) : super(key: key);

  /// Group
  final Group group;
  final String privacy;

  @override
  _GroupExpressionsState createState() => _GroupExpressionsState();
}

class _GroupExpressionsState extends State<GroupExpressions> {
  bool twoColumnView = true;

  bool get isPrivate => widget.privacy != 'Public';

  @override
  void initState() {
    super.initState();
    getUserInformation();
  }

  Future<void> _switchColumnView(String columnType) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      if (columnType == 'two') {
        twoColumnView = true;
        prefs.setBool('two-column-view', true);
      } else if (columnType == 'single') {
        twoColumnView = false;
        prefs.setBool('two-column-view', false);
      }
    });
  }

  Future<void> getUserInformation() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        if (prefs.getBool('two-column-view') != null) {
          twoColumnView = prefs.getBool('two-column-view');
        }
      });
    }
  }

  void _fetchMore() {
    context.bloc<PackBloc>().add(FetchMorePacks());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PackBloc, PackState>(
      builder: (context, state) {
        if (state is PacksLoading) {
          return JuntoLoader();
        }
        if (state is PacksLoaded) {
          final _results = isPrivate
              ? state.privateExpressions.results
              : state.publicExpressions.results;
          return Column(
            children: [
              FilterColumnRow(
                twoColumnView: twoColumnView,
                switchColumnView: _switchColumnView,
              ),
              Container(
                color: Theme.of(context).colorScheme.background,
                child: AnimatedCrossFade(
                  crossFadeState: twoColumnView
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                  duration: const Duration(
                    milliseconds: 200,
                  ),
                  firstChild: TwoColumnSliverListView(
                    data: _results,
                  ),
                  secondChild: SingleColumnSliverListView(
                    data: _results,
                    privacyLayer: widget.privacy,
                  ),
                ),
              ),
              if (appConfig.flavor == Flavor.dev)
                FetchMoreButton(
                  onPressed: _fetchMore,
                )
            ],
          );
        }
        if (state is PacksEmpty) {
          //TODO(Eric): Handle empty state
          return Container();
        }
        if (state is PacksError) {
          return JuntoErrorWidget(errorMessage: state.message ?? '');
        }
        return JuntoLoader();
      },
    );
  }
}
