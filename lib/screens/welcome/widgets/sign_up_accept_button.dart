import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:junto_beta_mobile/generated/l10n.dart';
import 'package:junto_beta_mobile/screens/welcome/bloc/bloc.dart';

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
          onPressed: () {
            if (pageView == 0) {
              nextPage();
            } else {
              BlocProvider.of<AuthBloc>(context).add(
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
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 14,
              letterSpacing: 1.4,
            ),
          ),
        ),
      ),
    );
  }
}
