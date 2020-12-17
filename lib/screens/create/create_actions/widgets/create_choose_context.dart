import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/backend/backend.dart';

class ChooseExpressionContext extends StatelessWidget {
  const ChooseExpressionContext({
    this.expressionContext,
    this.currentExpressionContext,
    this.selectExpressionContext,
  });
  final ExpressionContext expressionContext;
  final ExpressionContext currentExpressionContext;
  final Function selectExpressionContext;

  Map<String, dynamic> _expressionContextTraits() {
    dynamic icon;
    String socialContext;
    String description;
    switch (expressionContext) {
      case ExpressionContext.Collective:
        socialContext = 'Collective';
        description = 'Share publicy on Junto';
        icon = Icon(
          CustomIcons.newcollective,
          color: Colors.white,
          size: 33,
        );
        break;
      case ExpressionContext.Group:
        socialContext = 'My Pack';
        description = 'Share to just my Pack members';
        icon = Icon(
          CustomIcons.newpacks,
          color: Colors.white,
          size: 28,
        );
        break;
      default:
        socialContext = 'Collective';
        description = 'Share publicy on Junto';
        icon = Icon(
          CustomIcons.newcollective,
          color: Colors.white,
          size: 33,
        );
        break;
    }
    return {
      'icon': icon,
      'social_context': socialContext,
      'description': description,
    };
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        selectExpressionContext(expressionContext);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 15,
        ),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border(
            bottom: BorderSide(
              width: .75,
              color: Theme.of(context).dividerColor,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  height: 45,
                  width: 45,
                  margin: const EdgeInsets.only(right: 15),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      stops: const <double>[0.2, 0.9],
                      colors: <Color>[
                        Theme.of(context).colorScheme.primary,
                        Theme.of(context).colorScheme.secondary,
                      ],
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(1000),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: _expressionContextTraits()['icon'],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _expressionContextTraits()['social_context'],
                      style: TextStyle(
                        fontSize: 17,
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      _expressionContextTraits()['description'],
                    )
                  ],
                ),
              ],
            ),
            Radio(
              onChanged: (expressionContext) {
                selectExpressionContext(expressionContext);
              },
              value: expressionContext,
              groupValue: currentExpressionContext,
              activeColor: Theme.of(context).colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }
}
