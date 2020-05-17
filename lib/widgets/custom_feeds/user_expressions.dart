import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/app_config.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:junto_beta_mobile/backend/user_data_provider.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/den/bloc/den_bloc.dart';
import 'package:junto_beta_mobile/widgets/custom_feeds/custom_listview.dart';
import 'package:junto_beta_mobile/widgets/custom_feeds/filter_column_row.dart';
import 'package:junto_beta_mobile/widgets/custom_feeds/single_listview.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/end_drawer_relationships/error_widget.dart';
import 'package:junto_beta_mobile/widgets/fetch_more.dart';
import 'package:junto_beta_mobile/widgets/progress_indicator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Linear list of expressions created by the given [userProfile].
class UserExpressions extends StatefulWidget {
  const UserExpressions({
    Key key,
    @required this.userProfile,
    @required this.privacy,
  }) : super(key: key);

  /// [UserProfile] of the user
  final UserProfile userProfile;

  /// Either Public or Private;
  final String privacy;

  @override
  _UserExpressionsState createState() => _UserExpressionsState();
}

class _UserExpressionsState extends State<UserExpressions> {
  bool twoColumnView = true;

  Future<void> getUserInformation() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      if (prefs.getBool('two-column-view') != null) {
        twoColumnView = prefs.getBool('two-column-view');
      }
    });
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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DenBloc, DenState>(
      builder: (BuildContext context, DenState state) {
        if (state is DenLoadingState) {
          return JuntoProgressIndicator();
        }
        if (state is DenLoadedState) {
          final results = state.expressions;
          // TODO:Eric - implement custom refresh indicator
          return RefreshIndicator(
            onRefresh: () async {
              context.bloc<DenBloc>().add(RefreshDen());
            },
            child: Container(
              color: Theme.of(context).colorScheme.background,
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverToBoxAdapter(
                    child: FilterColumnRow(
                      twoColumnView: twoColumnView,
                      switchColumnView: _switchColumnView,
                    ),
                  ),
                  Consumer<UserDataProvider>(
                    builder: (BuildContext context, UserDataProvider data, _) {
                      if (data.twoColumnView) {
                        return TwoColumnList(
                          data: results,
                          useSliver: true,
                        );
                      }
                      return SingleColumnSliverListView(
                        data: results,
                        privacyLayer: widget.privacy,
                      );
                    },
                  ),
                  if (appConfig.flavor == Flavor.dev)
                    SliverToBoxAdapter(
                      child: FetchMoreButton(
                        onPressed: () {
                          context.bloc<DenBloc>().add(
                                LoadMoreDen(),
                              );
                        },
                      ),
                    )
                ],
              ),
            ),
          );
        }
        if (state is DenEmptyState) {
          // TODO(Eric): Update with empty state graphic
          return const SizedBox();
        }
        if (state is DenErrorState) {
          return JuntoErrorWidget(
            errorMessage: state.message,
          );
        }
        return SizedBox();
      },
    );
  }
}
