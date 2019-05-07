
// import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../models/expression.dart';
import '../models/sphere.dart';
import '../models/pack.dart';

class ScopedUser extends Model {
  List<Expression> _collectiveExpressions = Expression.fetchAll();
  List<Sphere> _spheres = Sphere.fetchAll();
  List<Pack> _packs = Pack.fetchAll();

  List get collectiveExpressions {
    return List.from(_collectiveExpressions);
  }

  List get spheres {
    return _spheres;
  }  

  List get packs {
    return _packs;
  }    
}