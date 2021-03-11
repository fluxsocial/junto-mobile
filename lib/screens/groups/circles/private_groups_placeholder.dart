import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// This screen displays the temporary page we'll display until private groups are released
class PrivateGroupsPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Center(
        child: Transform.translate(
          offset: Offset(0.0, -60),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/images/junto-mobile__groups--placeholder.png',
                height: 170,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(height: 25),
              Text(
                'We will open private groups soon.',
                style: TextStyle(
                  fontSize: 17,
                  color: Theme.of(context).primaryColor,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
