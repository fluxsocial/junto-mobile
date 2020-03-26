import 'package:flutter/material.dart';

class ResetFilterButton extends StatelessWidget {
  const ResetFilterButton({
    Key key,
    @required this.onTap,
  }) : super(key: key);

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 16.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: FlatButton(
          color: const Color(0xff444444),
          onPressed: onTap,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40.0),
          ),
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Text(
              'RESET',
              style: TextStyle(
                letterSpacing: 1.7,
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
