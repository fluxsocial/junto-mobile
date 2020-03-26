import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/groups/bloc/group_bloc.dart';
import 'package:junto_beta_mobile/utils/utils.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/end_drawer_relationships/error_widget.dart';
import 'package:junto_beta_mobile/widgets/previews/pack_preview/pack_preview.dart';
import 'package:junto_beta_mobile/widgets/progress_indicator.dart';
import 'package:provider/provider.dart';

class MyPacks extends StatefulWidget {
  const MyPacks({
    Key key,
    @required this.selectedGroup,
  }) : super(key: key);
  final ValueChanged<Group> selectedGroup;

  @override
  _MyPacksState createState() => _MyPacksState();
}

class _MyPacksState extends State<MyPacks> with ListDistinct {
  UserData _userProfile;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _userProfile = Provider.of<UserDataProvider>(context).userProfile;
  }

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
    return Column(
      children: <Widget>[
        BlocBuilder<GroupBloc, GroupBlocState>(
          builder: (context, state) {
            if (state is GroupLoading) {
              return _loader();
            }
            if (state is GroupLoaded) {
              return Expanded(
                  child: ListView(
                padding: const EdgeInsets.all(0),
                children: <Widget>[
                  for (Group group in state.groups)
                    GestureDetector(
                      onTap: () => widget.selectedGroup(group),
                      child: PackPreview(
                        group: group,
                        userProfile: _userProfile,
                      ),
                    )
                ],
              ));
            }
            if (state is GroupError) {
              JuntoErrorWidget(
                errorMessage: state.groupError,
              );
            }
            return SizedBox();
          },
        ),
      ],
    );
  }
}
