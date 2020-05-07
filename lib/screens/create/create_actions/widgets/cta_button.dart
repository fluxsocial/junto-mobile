import 'package:flutter/material.dart';

class CreateCTAButton extends StatelessWidget {
  const CreateCTAButton({
    this.cta,
    this.title,
  });

  final Function cta;
  final String title;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: cta,
      child: Container(
        padding: const EdgeInsets.only(
          left: 10,
          right: 10,
          top: 5,
          bottom: 5,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
