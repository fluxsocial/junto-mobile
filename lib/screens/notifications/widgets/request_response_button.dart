import 'package:flutter/material.dart';

class RequestResponseButton extends StatelessWidget {
  const RequestResponseButton({
    this.userAddress,
    this.groupAddress,
    this.buttonTitle,
    this.onTap,
  });

  final String userAddress;
  final String groupAddress;
  final String buttonTitle;
  final Function onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        onTap();
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).primaryColor,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 5,
          horizontal: 10,
        ),
        child: Text(
          buttonTitle,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }
}
