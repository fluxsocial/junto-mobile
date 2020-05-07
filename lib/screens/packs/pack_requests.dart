import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/generated/l10n.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/groups/bloc/group_bloc.dart';
import 'package:junto_beta_mobile/widgets/previews/pack_preview/pack_request.dart';
import 'package:junto_beta_mobile/widgets/progress_indicator.dart';
import 'package:provider/provider.dart';

class PackRequests extends StatefulWidget {
  @override
  _PackRequestsState createState() => _PackRequestsState();
}

class _PackRequestsState extends State<PackRequests> {
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
                    padding: const EdgeInsets.all(0),
                    children: <Widget>[
                      for (Group packRequest in state.groupJoinNotifications)
                        if (packRequest.groupType == 'Pack')
                          PackRequest(
                            // userProfile: user.userProfile,
                            pack: packRequest,
                            refreshGroups: () async {
                              context.bloc<GroupBloc>().add(FetchMyPack());
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
                      child: Text(S.of(context).common_network_error),
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
