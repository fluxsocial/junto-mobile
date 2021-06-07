import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:junto_beta_mobile/screens/collective/bloc/collective_bloc.dart';

class GetMoreExpressionsButton extends StatelessWidget {
  const GetMoreExpressionsButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        bottom: 100.0,
        top: 25,
      ),
      decoration: BoxDecoration(
        border: Border(),
      ),
      child: FlatButton(
        onPressed: () =>
            BlocProvider.of<CollectiveBloc>(context).add(FetchMoreCollective()),
        child: Text(
          'GET 50 MORE EXPRESSIONS',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: Theme.of(context).primaryColorLight,
          ),
        ),
      ),
    );
  }
}
