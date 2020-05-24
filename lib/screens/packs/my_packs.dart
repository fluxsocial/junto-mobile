import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/groups/bloc/group_bloc.dart';
import 'package:junto_beta_mobile/screens/packs/packs_bloc/pack_bloc.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/end_drawer_relationships/error_widget.dart';
import 'package:junto_beta_mobile/widgets/previews/pack_preview/pack_preview.dart';
import 'package:junto_beta_mobile/widgets/progress_indicator.dart';
import 'package:junto_beta_mobile/widgets/custom_refresh/custom_refresh.dart';

import 'package:provider/provider.dart';

class MyPacks extends StatelessWidget {
  MyPacks({this.packsViewNav});

  final Function packsViewNav;
  final Completer<void> refreshCompleter = Completer<void>();

  Widget _loader() {
    return Expanded(
      child: Center(
        child: Transform.translate(
          offset: const Offset(0.0, -50),
          child: JuntoProgressIndicator(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserDataProvider>(
      builder: (context, data, child) {
        return Column(
          children: <Widget>[
            BlocBuilder<GroupBloc, GroupBlocState>(
              builder: (context, state) {
                if (state is GroupLoading) {
                  return _loader();
                }
                if (state is GroupLoaded) {
                  return Expanded(
                      child: CustomRefresh(
                    refresh: () async {
                      await context.bloc<GroupBloc>().add(
                            RefreshPack(),
                          );
                      await Future.delayed(Duration(milliseconds: 500));
                      return refreshCompleter.future;
                    },
                    child: ListView(
                      physics: AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(0),
                      children: <Widget>[
                        for (Group group in state.groups)
                          GestureDetector(
                            onTap: () {
                              packsViewNav();
                              context
                                  .bloc<PackBloc>()
                                  .add(FetchPacks(group: group.address));
                            },
                            child: PackPreview(
                              group: group,
                              userProfile: data?.userProfile,
                            ),
                          )
                      ],
                    ),
                  ));
                }
                if (state is GroupError) {
                  print(state.groupError);
                  JuntoErrorWidget(
                    errorMessage: state.groupError,
                  );
                }
                return SizedBox();
              },
            ),
          ],
        );
      },
    );
  }
}
