import 'package:flutter/material.dart';

class ExpressionOpenInteractions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Row(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                _buildRespondModal(context);
              },
              child: Container(
                  width: MediaQuery.of(context).size.width * .5 - 10,
                  alignment: Alignment.center,
                  child: const Text('Respond')),
            ),
            GestureDetector(
              child: Container(
                  width: MediaQuery.of(context).size.width * .5 - 10,
                  alignment: Alignment.center,
                  child: const Text('Resonate')),
            ),
          ],
        ));
  }

  // Build bottom modal to add channels to expression
  void _buildRespondModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        // Use StatefulBuilder to pass state of CreateActions
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter state) {
            return Container(
              height: MediaQuery.of(context).size.height,
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: const Text(''),
            );
          },
        );
      },
    );
  }
}
