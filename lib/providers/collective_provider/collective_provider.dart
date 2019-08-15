
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/expression.dart'; 

class CollectiveProvider with ChangeNotifier {
  List<Expression> _collectiveExpressions = Expression.fetchAll(); 
  List _perspectives = [];

  List<Expression> get collectiveExpressions { 
    return [..._collectiveExpressions]; 
  }

  List get perspectives {
    return [..._perspectives]; 
  }

  void addCollectiveExpression() {
    
    notifyListeners();
  }
} 