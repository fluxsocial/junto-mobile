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
    return Container(
      color: Theme.of(context).colorScheme.background,
      child: ListView(
        controller: _packOpenPublicController,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * .5,
                padding: EdgeInsets.only(left: 10, right: 5, top: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    ExpressionPreview(expression: expression[0]),
                    ExpressionPreview(expression: expression[2]),
                    ExpressionPreview(expression: expression[4]),
                    ExpressionPreview(expression: expression[6]),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * .5,
                padding: EdgeInsets.only(left: 5, right: 10, top: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    ExpressionPreview(expression: expression[1]),
                    ExpressionPreview(expression: expression[3]),
                    ExpressionPreview(expression: expression[5]),
                    ExpressionPreview(expression: expression[7]),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
