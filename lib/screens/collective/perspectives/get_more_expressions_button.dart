import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:junto_beta_mobile/screens/collective/bloc/collective_bloc.dart';

class GetMoreExpressionsButton extends StatelessWidget {
  const GetMoreExpressionsButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 100.0),
      child: FlatButton(
        onPressed: () =>
            BlocProvider.of<CollectiveBloc>(context).add(FetchMoreCollective()),
        child: const Text('Get more'),
      ),
    );
  }
}
