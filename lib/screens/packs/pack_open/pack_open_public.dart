import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/models/expression.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/widgets/previews/expression_preview/expression_preview.dart';
import 'package:junto_beta_mobile/widgets/utils/hide_fab.dart';
import 'package:provider/provider.dart';

class PackOpenPublic extends StatefulWidget {
  const PackOpenPublic({
    Key key,
    @required this.fabVisible,
  }) : super(key: key);
  final ValueNotifier<bool> fabVisible;

  @override
  _PackOpenPublicState createState() => _PackOpenPublicState();
}

class _PackOpenPublicState extends State<PackOpenPublic> with HideFab {
  List<CentralizedExpressionResponse> expression =
      <CentralizedExpressionResponse>[];

  ScrollController _packOpenPublicController;

  ExpressionRepo _expressionRepo;

  @override
  void initState() {
    super.initState();
    _packOpenPublicController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _packOpenPublicController.addListener(_onScrollingHasChanged);
      _packOpenPublicController.position.isScrollingNotifier.addListener(
        _onScrollingHasChanged,
      );
    });
  }

  void _onScrollingHasChanged() {
    super.hideFabOnScroll(_packOpenPublicController, widget.fabVisible);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _expressionRepo = Provider.of<ExpressionRepo>(context);
    expression = _expressionRepo.collectiveExpressions;
  }

  @override
  void dispose() {
    _packOpenPublicController.removeListener(_onScrollingHasChanged);
    _packOpenPublicController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(controller: _packOpenPublicController, children: <Widget>[
      ExpressionPreview(expression: expression[0]),
      ExpressionPreview(expression: expression[1]),
      ExpressionPreview(expression: expression[2]),
      ExpressionPreview(expression: expression[3]),
      ExpressionPreview(expression: expression[4]),
      ExpressionPreview(expression: expression[5]),
      ExpressionPreview(expression: expression[6]),
      ExpressionPreview(expression: expression[7]),
    ]);
  }
}
