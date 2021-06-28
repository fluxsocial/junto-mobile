import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/screens/global_search/global_search.dart';

class GlobalSearchIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          CupertinoPageRoute<dynamic>(
            builder: (BuildContext context) => GlobalSearch(),
          ),
        );
      },
      child: Container(
        color: Colors.transparent,
        height: 50,
        width: 50,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Icon(
          Icons.search,
          color: Theme.of(context).primaryColor,
          size: 24,
        ),
      ),
    );
  }
}
