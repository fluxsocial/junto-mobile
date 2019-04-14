
import './../components/expression_preview/expression_preview.dart';

class Expression {
  final expressionType; 
  final expressionTitle;
  final expressionText;

  Expression(this.expressionType, this.expressionTitle, this.expressionText);

  List<Expression> fetchExpressions() {
    return [
      Expression(
        'longform',
        'The Medium is the Message',
        'Hellos, my name is Eric' )
    ];
  }
}