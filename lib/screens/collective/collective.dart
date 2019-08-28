import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/components/expression_preview/expression_preview.dart';
import 'package:junto_beta_mobile/models/expression.dart';
import 'package:junto_beta_mobile/providers/collective_provider/collective_provider.dart';
import 'package:junto_beta_mobile/screens/collective/degrees/degrees.dart';
import 'package:junto_beta_mobile/typography/palette.dart';
import 'package:provider/provider.dart';

/// This screen shows a list of public expressions that can be filtered
/// by channel or perspective
class JuntoCollective extends StatefulWidget {
  const JuntoCollective(this.controller, this._currentPerspective);
  final String _currentPerspective;

  /// This controller is used to detect the scroll of the ListView
  /// to render the FAB dynamically
  final ScrollController controller;

  @override
  State<StatefulWidget> createState() => JuntoCollectiveState();
}

class JuntoCollectiveState extends State<JuntoCollective> {
  String currentScreen = 'collective';
  bool isLoading = false;
  List<Expression> initialData = <Expression>[];
  ScrollController controller;
  @override
  void initState() {
    super.initState();
    controller = ScrollController();
    widget.controller.addListener(scollListener);
  }

  @override
  void dispose() {
    super.dispose();
    widget.controller.removeListener(scollListener);
    controller.dispose();
  }

  @override
  void didChangeDependencies() {
    initialData
        .addAll(Provider.of<CollectiveProvider>(context).collectiveExpressions);
    super.didChangeDependencies();
  }

  void scollListener() {
    if (controller.position.pixels ==
        controller.position.maxScrollExtent * 0.25) {
      _getData();
    }
  }

  Future<void> _getData() async {
    if (!isLoading) {
      setState(() => isLoading = true);
    }
    await Future<void>.delayed(const Duration(seconds: 2), () {});
    setState(() {
      isLoading = false;
      initialData.addAll(
          Provider.of<CollectiveProvider>(context).collectiveExpressions);
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
      decoration: BoxDecoration(color: JuntoPalette.juntoWhite),
      child: ListView(
        controller: widget.controller,
        children: <Widget>[
          /// Degrees of Separation Widget rendered only when on the 'JUNTO'
          /// perspective
          widget._currentPerspective == 'degrees of separation'
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
          Consumer<CollectiveProvider>(builder: (
            BuildContext context,
            CollectiveProvider collective,
            Widget child,
          ) {
            return ListView.builder(
              controller: controller,
              shrinkWrap: true,
              itemCount: initialData.length + 1,
              itemBuilder: (BuildContext context, int index) {
                if (index == initialData.length) {
                  return _buildProgressIndicator();
                } else {
                  return ExpressionPreview(initialData[index]);
                }
              },
            );
          })
        ],
      ),
    );
  }

  /// Default colors for degrees
  Color _oneDegreeColor = const Color(0xff999999);
  Color _twoDegreesColor = const Color(0xff999999);
  Color _threeDegreesColor = const Color(0xff999999);
  Color _fourDegreesColor = const Color(0xff999999);
  Color _fiveDegreesColor = const Color(0xff999999);
  Color _sixDegreesColor = const Color(0xff999999);

  /// Reset all degree colors to inactive
  void _resetDegrees() {
    setState(() {
      _oneDegreeColor = const Color(0xff999999);
      _twoDegreesColor = const Color(0xff999999);
      _threeDegreesColor = const Color(0xff999999);
      _fourDegreesColor = const Color(0xff999999);
      _fiveDegreesColor = const Color(0xff999999);
      _sixDegreesColor = const Color(0xff999999);
    });
  }

  /// Switch degrees
  void _changeDegree(String degree) {
    setState(() {
      _resetDegrees();
      if (degree == 'one') {
        _oneDegreeColor = const Color(0xff333333);
      } else if (degree == 'two') {
        _twoDegreesColor = const Color(0xff333333);
      } else if (degree == 'three') {
        _threeDegreesColor = const Color(0xff333333);
      } else if (degree == 'four') {
        _fourDegreesColor = const Color(0xff333333);
      } else if (degree == 'five') {
        _fiveDegreesColor = const Color(0xff333333);
      } else if (degree == 'six') {
        _sixDegreesColor = const Color(0xff333333);
      }
    });
  }
}
