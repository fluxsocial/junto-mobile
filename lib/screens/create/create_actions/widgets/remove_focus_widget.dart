import 'package:flutter/material.dart';

class RemoveFocusWidget extends StatelessWidget {
  const RemoveFocusWidget({this.focusNode});

  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: GestureDetector(
        onTap: () {
          focusNode.unfocus();
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border(
              top: BorderSide(
                color: Theme.of(context).dividerColor,
                width: .75,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                height: 50,
                width: 50,
                alignment: Alignment.center,
                color: Colors.transparent,
                child: Icon(
                  Icons.keyboard_arrow_down,
                  color: Theme.of(context).primaryColor,
                  size: 24,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
