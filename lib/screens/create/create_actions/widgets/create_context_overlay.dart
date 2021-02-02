import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/screens/create/create_actions/widgets/create_choose_context.dart';

class CreateContextOverlay extends StatelessWidget {
  const CreateContextOverlay({
    this.currentExpressionContext = ExpressionContext.Collective,
    this.selectExpressionContext,
    this.toggleSocialContextVisibility,
  });

  final ExpressionContext currentExpressionContext;
  final Function selectExpressionContext;
  final Function toggleSocialContextVisibility;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.black.withOpacity(.7),
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).backgroundColor,
              borderRadius: BorderRadius.circular(15),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 25),
            height: MediaQuery.of(context).size.height * .5,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(
                    top: 25,
                    left: 10,
                    right: 10,
                  ),
                  child: Text(
                    'Where would you like to share?',
                    style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.only(
                      top: 25,
                    ),
                    children: [
                      ChooseExpressionContext(
                        expressionContext: ExpressionContext.Collective,
                        currentExpressionContext: currentExpressionContext,
                        selectExpressionContext: selectExpressionContext,
                      ),
                      ChooseExpressionContext(
                        expressionContext: ExpressionContext.Group,
                        currentExpressionContext: currentExpressionContext,
                        selectExpressionContext: selectExpressionContext,
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    toggleSocialContextVisibility(false);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(25),
                    color: Colors.transparent,
                    alignment: Alignment.center,
                    child: Text(
                      'CLOSE',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
