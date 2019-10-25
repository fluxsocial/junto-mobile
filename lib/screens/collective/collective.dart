import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/backend/repositories/expression_repo.dart';
import 'package:junto_beta_mobile/models/expression.dart';
import 'package:junto_beta_mobile/screens/collective/degrees/degrees.dart';
import 'package:junto_beta_mobile/app/palette.dart';
import 'package:junto_beta_mobile/widgets/expression_preview/expression_preview.dart';
import 'package:provider/provider.dart';

/// This screen shows a list of public expressions that can be filtered
/// by channel or perspective
class JuntoCollective extends StatefulWidget {
  const JuntoCollective({
    Key key,
    this.currentPerspective,
    this.controller,
  }) : super(key: key);

  final String currentPerspective;

  /// This controller is used to detect the scroll of the ListView
  /// to render the FAB dynamically
  final ScrollController controller;

  @override
  State<StatefulWidget> createState() => JuntoCollectiveState();
}

class JuntoCollectiveState extends State<JuntoCollective> {
  String currentScreen = 'collective';
  bool isLoading = false;
  List<CentralizedExpressionResponse> initialData =
      <CentralizedExpressionResponse>[];

  @override
  void initState() {
    super.initState();

    widget.controller.addListener(scollListener);
  }

  @override
  void dispose() {
    super.dispose();
    widget.controller.removeListener(scollListener);
  }

  @override
  void didChangeDependencies() {
    initialData
        .addAll(Provider.of<ExpressionRepo>(context).collectiveExpressions);
    super.didChangeDependencies();
  }

  void scollListener() {
    if (widget.controller.position.pixels ==
        widget.controller.position.maxScrollExtent) {
      _getData();
    }
  }

  Future<void> _getData() async {
    if (!isLoading) {
      setState(() => isLoading = true);
    }
    await Future<void>.delayed(const Duration(seconds: 2), () {});
    isLoading = false;
    if (mounted)
      setState(() {
        isLoading = true;
        initialData.addAll(
            Provider.of<ExpressionRepo>(context).collectiveExpressions);
      });
  }

  Widget _buildProgressIndicator() {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Center(
        child: Opacity(
          opacity: 1.0,
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: JuntoPalette.juntoWhite),
      child: ListView(
        controller: widget.controller,
        children: <Widget>[
          /// Degrees of Separation Widget rendered only when on the 'Degrees of separation'
          /// perspective
          widget.currentPerspective == 'Degrees of separation'
              ? DegreesOfSeparation(
                  _changeDegree,
                  _oneDegreeColor,
                  _twoDegreesColor,
                  _threeDegreesColor,
                  _fourDegreesColor,
                  _fiveDegreesColor,
                  _sixDegreesColor,
                )
              : const SizedBox(),

          for (int index = 0; index < initialData.length + 1; index++)
            if (index == initialData.length)
              _buildProgressIndicator()
            else
              ExpressionPreview(expression: initialData[index])
        ],
      ),
    );
  }

  /// Default colors for degrees
  Color _oneDegreeColor = JuntoPalette.juntoGreyLight;
  Color _twoDegreesColor = JuntoPalette.juntoGreyLight;
  Color _threeDegreesColor = JuntoPalette.juntoGreyLight;
  Color _fourDegreesColor = JuntoPalette.juntoGreyLight;
  Color _fiveDegreesColor = JuntoPalette.juntoGreyLight;
  Color _sixDegreesColor = JuntoPalette.juntoGreyLight;

  /// Reset all degree colors to inactive
  void _resetDegrees() {
    setState(() {
      _oneDegreeColor = JuntoPalette.juntoGreyLight;
      _twoDegreesColor = JuntoPalette.juntoGreyLight;
      _threeDegreesColor = JuntoPalette.juntoGreyLight;
      _fourDegreesColor = JuntoPalette.juntoGreyLight;
      _fiveDegreesColor = JuntoPalette.juntoGreyLight;
      _sixDegreesColor = JuntoPalette.juntoGreyLight;
    });
  }

  /// Switch degrees
  void _changeDegree(String degree) {
    setState(() {
      _resetDegrees();
      if (degree == 'one') {
        _oneDegreeColor = JuntoPalette.juntoGrey;
      } else if (degree == 'two') {
        _twoDegreesColor = JuntoPalette.juntoGrey;
      } else if (degree == 'three') {
        _threeDegreesColor = JuntoPalette.juntoGrey;
      } else if (degree == 'four') {
        _fourDegreesColor = JuntoPalette.juntoGrey;
      } else if (degree == 'five') {
        _fiveDegreesColor = JuntoPalette.juntoGrey;
      } else if (degree == 'six') {
        _sixDegreesColor = JuntoPalette.juntoGrey;
      }
    });
  }
}
