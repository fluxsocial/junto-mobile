import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';

class FilterColumnRow extends StatelessWidget {
  const FilterColumnRow({this.switchColumnView, this.twoColumnView});

  final Function switchColumnView;
  final bool twoColumnView;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Image.asset('assets/images/junto-mobile__filter.png', height: 17),
          Row(
            children: <Widget>[
              GestureDetector(
                onTap: () => switchColumnView('two'),
                child: Container(
                  child: Icon(
                    CustomIcons.twocolumn,
                    size: 20,
                    color: twoColumnView
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).primaryColorLight,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () => switchColumnView('single'),
                child: Container(
                  child: Icon(
                    CustomIcons.singlecolumn,
                    size: 20,
                    color: twoColumnView
                        ? Theme.of(context).primaryColorLight
                        : Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
