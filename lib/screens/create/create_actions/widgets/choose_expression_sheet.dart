import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/expressions.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';

class ChooseExpressionSheet extends StatelessWidget {
  const ChooseExpressionSheet({
    this.currentExpressionType,
    this.chooseExpressionType,
  });

  final ExpressionType currentExpressionType;
  final Function chooseExpressionType;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: DraggableScrollableSheet(
              minChildSize: .1,
              maxChildSize: .3,
              initialChildSize: .3,
              expand: false,
              builder: (context, scrollController) {
                return Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).backgroundColor,
                    border: Border(
                      top: BorderSide(
                        color: Theme.of(context).dividerColor,
                        width: .75,
                      ),
                    ),
                  ),
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(0),
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 7.5,
                            width: 100,
                            margin: const EdgeInsets.symmetric(vertical: 15),
                            decoration: BoxDecoration(
                              color: Theme.of(context).dividerColor,
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Container(
                        height: 100,
                        color: Theme.of(context).backgroundColor,
                        margin: EdgeInsets.only(bottom: 15),
                        child: Row(
                          children: [
                            CreateExpressionIcon(
                              expressionType: ExpressionType.dynamic,
                              currentExpressionType: currentExpressionType,
                              switchExpressionType: chooseExpressionType,
                            ),
                            CreateExpressionIcon(
                              expressionType: ExpressionType.shortform,
                              currentExpressionType: currentExpressionType,
                              switchExpressionType: chooseExpressionType,
                            ),
                            CreateExpressionIcon(
                              expressionType: ExpressionType.link,
                              currentExpressionType: currentExpressionType,
                              switchExpressionType: chooseExpressionType,
                            ),
                            CreateExpressionIcon(
                              expressionType: ExpressionType.photo,
                              currentExpressionType: currentExpressionType,
                              switchExpressionType: chooseExpressionType,
                            ),
                            CreateExpressionIcon(
                              expressionType: ExpressionType.audio,
                              currentExpressionType: currentExpressionType,
                              switchExpressionType: chooseExpressionType,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                          children: [
                            Icon(
                              CustomIcons.create,
                              size: 20,
                              color: Theme.of(context).primaryColor,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
        ),
      ],
    );
  }
}

class CreateExpressionIcon extends StatelessWidget {
  const CreateExpressionIcon({
    this.expressionType,
    this.currentExpressionType,
    this.switchExpressionType,
  });

  final ExpressionType expressionType;
  final ExpressionType currentExpressionType;
  final Function switchExpressionType;

  Map<String, dynamic> expressionTypeTraits(BuildContext context) {
    String expressionTypeText;
    Icon expressionTypeIcon;

    Color color;
    if (currentExpressionType == expressionType) {
      color = Theme.of(context).primaryColorDark;
    } else {
      color = Theme.of(context).primaryColorLight;
    }

    switch (expressionType) {
      case ExpressionType.dynamic:
        expressionTypeText = 'DYNAMIC';
        expressionTypeIcon = Icon(
          CustomIcons.pen,
          size: 33,
          color: color,
        );
        break;
      case ExpressionType.shortform:
        expressionTypeText = 'SHORTFORM';
        expressionTypeIcon = Icon(
          CustomIcons.feather,
          size: 20,
          color: color,
        );
        break;
      case ExpressionType.link:
        expressionTypeText = 'LINK';
        expressionTypeIcon = Icon(
          Icons.link,
          size: 24,
          color: color,
        );
        break;
      case ExpressionType.photo:
        expressionTypeIcon = Icon(
          CustomIcons.camera,
          size: 20,
          color: color,
        );
        expressionTypeText = 'PHOTO';
        break;
      case ExpressionType.audio:
        expressionTypeIcon = Icon(
          Icons.mic,
          size: 20,
          color: color,
        );
        expressionTypeText = 'AUDIO';
        break;

      default:
        expressionTypeText = 'DYNAMIC';
        expressionTypeIcon = Icon(
          CustomIcons.pen,
          size: 36,
          color: color,
        );
        break;
    }

    return {
      'expressionTypeText': expressionTypeText,
      'expressionTypeIcon': expressionTypeIcon,
      'color': color,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () => switchExpressionType(expressionType),
        child: Container(
          color: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 38,
                child: expressionTypeTraits(context)['expressionTypeIcon'],
              ),
              const SizedBox(height: 5),
              Text(expressionTypeTraits(context)['expressionTypeText'],
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: expressionTypeTraits(context)['color'],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
