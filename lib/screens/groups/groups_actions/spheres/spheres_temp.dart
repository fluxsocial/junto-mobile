import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SpheresTemp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height - 150,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          const SizedBox(height: 45),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 5),
            color: Theme.of(context).backgroundColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text( 
                  'Circles',
                  style: Theme.of(context).textTheme.headline4,
                ),
                const SizedBox(),
              ],
            ),
          ),
          // todo: Eric will add illustration + test to fill blank space
          const Expanded(
            child: SizedBox(),
          ),
        ],
      ),
    );
  }
}
