import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/widgets/progress_indicator.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/screens/groups/bloc/group_bloc.dart';
import 'package:junto_beta_mobile/widgets/previews/pack_preview/pack_request.dart';

class PendingPackMembers extends StatelessWidget {
  const PendingPackMembers();
  @override
  Widget build(BuildContext context) {
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

    return Consumer<UserDataProvider>(builder: (context, user, _) {
      return Column(
        children: <Widget>[
          BlocBuilder<GroupBloc, GroupBlocState>(
            builder: (BuildContext context, GroupBlocState state) {
              if (state is GroupLoading) {
                return _loader();
              }
              if (state is GroupLoaded) {
                return Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    children: <Widget>[
                      for (Group packRequest
                          in state.notifications.groupJoinNotifications)
                        if (packRequest.groupType == 'Pack')
                          PackRequest(
                            userProfile: user.userProfile,
                            pack: packRequest,
                            refreshGroups: () async {
                              await context.bloc<GroupBloc>().add(
                                    FetchMyPack(),
                                  );
                            },
                          )
                    ],
                  ),
                );
              }
              if (state is GroupError) {
                return Expanded(
                  child: Center(
                    child: Transform.translate(
                      offset: const Offset(0.0, -50),
                      child: const Text('Hmm, something is up'),
                    ),
                  ),
                );
              }
              return _loader();
            },
          ),
        ],
      );
    });
  }
}
