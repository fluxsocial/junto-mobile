
// import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../models/expression.dart';

class ScopedExpressions extends Model {
  List<Expression> _expressions = Expression.fetchAll();

  List get expressions {
    return List.from(_expressions);
  }

  void addExpression(expression) {
    _expressions.add(expression);

    notifyListeners();
  }
}