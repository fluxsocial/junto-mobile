import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:junto_beta_mobile/backend/repositories.dart';
import 'package:junto_beta_mobile/generated/l10n.dart';
import 'package:junto_beta_mobile/screens/welcome/bloc/bloc.dart';
import 'package:junto_beta_mobile/app/themes_provider.dart';
import 'package:provider/provider.dart';
import 'package:junto_beta_mobile/app/palette.dart';
import 'package:junto_beta_mobile/backend/backend.dart';

class AcceptButton extends StatelessWidget {
  const AcceptButton({
    Key key,
    @required this.pageView,
    @required this.nextPage,
  }) : super(key: key);

  final int pageView;
  final Function nextPage;

  @override
  Widget build(BuildContext context) {
    return Consumer2<JuntoThemesProvider, UserDataProvider>(builder:
        (context, JuntoThemesProvider theme, UserDataProvider user, child) {
      return InkWell(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 40),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Theme.of(context).accentColor,
            borderRadius: BorderRadius.circular(40.0),
          ),
          child: FlatButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40.0),
            ),
            onPressed: () async {
              if (pageView == 0) {
                nextPage();
              } else {
                // Add member to community center on sign up
                await Provider.of<GroupRepo>(context, listen: false)
                    .addGroupMember('48b97134-1a4d-deb0-b27c-9bcdfc33f386',
                        [user.userProfile.user], 'Member');
                // Add member to updates on sign up
                await Provider.of<GroupRepo>(context, listen: false)
                    .addGroupMember('2eb976b4-4473-2436-ccb2-e512e868bcac',
                        [user.userProfile.user], 'Member');
                // accept agreements
                await BlocProvider.of<AuthBloc>(context).add(
                  AcceptAgreements(),
                );
              }
            },
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 20,
            ),
            color: Colors.transparent,
            child: Text(
              pageView == 0 ? 'NEXT' : S.of(context).count_me_in,
              style: TextStyle(
                color: JuntoPalette().juntoWhite(theme: theme),
                fontWeight: FontWeight.w700,
                fontSize: 14,
                letterSpacing: 1.4,
              ),
            ),
          ),
        ),
      );
    });
  }
}
