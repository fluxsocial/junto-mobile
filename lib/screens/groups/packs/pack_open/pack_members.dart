import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/groups/packs/packs_bloc/pack_bloc.dart';
import 'package:junto_beta_mobile/utils/junto_overlay.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/end_drawer_relationships/error_widget.dart';
import 'package:junto_beta_mobile/widgets/previews/member_preview/member_preview.dart';

class PackOpenMembers extends StatelessWidget {
  const PackOpenMembers({
    Key key,
    this.packAddress,
  }) : super(key: key);
  final String packAddress;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PackBloc, PackState>(
      builder: (context, state) {
        if (state is PacksLoading) {
          return JuntoLoader();
        }
        if (state is PacksLoaded) {
          return ListView(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            children: <Widget>[
              for (Users user in state.groupMemebers)
                MemberPreview(profile: user.user)
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
        return SizedBox();
      },
    );
  }
}
