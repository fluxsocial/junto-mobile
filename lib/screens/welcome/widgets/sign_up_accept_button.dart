import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:junto_beta_mobile/generated/l10n.dart';
import 'package:junto_beta_mobile/screens/welcome/bloc/bloc.dart';

class AcceptButton extends StatelessWidget {
  const AcceptButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 40),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            stops: const <double>[0.1, 0.9],
            colors: <Color>[
              Theme.of(context).colorScheme.secondary,
              Theme.of(context).colorScheme.primary
            ],
          ),
          borderRadius: BorderRadius.circular(40.0),
        ),
        child: FlatButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40.0),
          ),
          onPressed: () =>
              BlocProvider.of<AuthBloc>(context).add(AcceptAgreements()),
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20,
          ),
          color: Colors.transparent,
          child: Text(
            S.of(context).count_me_in,
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
