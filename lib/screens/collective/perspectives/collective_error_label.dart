import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:junto_beta_mobile/screens/collective/bloc/collective_bloc.dart';

class CollectiveErrorLabel extends StatelessWidget {
  const CollectiveErrorLabel({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FlatButton(
        child: Text(
          'Hmm, something is up... If this persists, please try logging out and back in.',
          style: Theme.of(context).textTheme.caption,
          textAlign: TextAlign.center,
        ),
        onPressed: () =>
            context.read<CollectiveBloc>().add(RefreshCollective()),
      ),
    );
  }
}
