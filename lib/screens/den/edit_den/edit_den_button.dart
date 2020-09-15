import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EditDenButton extends StatelessWidget {
  final VoidCallback onTap;

  const EditDenButton({Key key, this.onTap}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).size.width / 2 + 10,
      right: 10,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(left: 15),
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 5,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              color: Theme.of(context).primaryColor,
              width: 1,
            ),
          ),
          child: Text(
            'EDIT',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ),
    );
  }
}
