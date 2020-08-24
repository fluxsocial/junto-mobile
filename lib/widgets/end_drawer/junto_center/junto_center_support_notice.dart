import 'package:flutter/material.dart';

class JuntoCenterSupportNotice extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 15,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Theme.of(context).dividerColor, width: .5),
        ),
      ),
      child: Row(
        children: [
          Image.asset(
            'assets/images/junto-mobile__sprout.png',
            height: 15,
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              'Email hi@junto.support if you need support!',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
