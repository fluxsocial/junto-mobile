import 'package:flutter/material.dart';

class FutureBuilderErrorWidget extends StatelessWidget {
  const FutureBuilderErrorWidget({this.errorMessage});
  final String errorMessage;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        errorMessage,
        style: Theme.of(context).textTheme.caption,
      ),
    );
  }
}
