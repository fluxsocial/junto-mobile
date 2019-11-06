import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/palette.dart';
import 'package:junto_beta_mobile/backend/repositories.dart';
import 'package:junto_beta_mobile/models/expression.dart';
import 'package:junto_beta_mobile/screens/collective/degrees/degrees.dart';
import 'package:junto_beta_mobile/widgets/previews/expression_preview/expression_preview.dart';
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
  String _perspective;
  bool isLoading = false;
  List<CentralizedExpressionResponse> initialData =
      <CentralizedExpressionResponse>[];

  @override
  void initState() {
    super.initState();
    _perspective = widget.currentPerspective;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    initialData
        .addAll(Provider.of<ExpressionRepo>(context).collectiveExpressions);
    super.didChangeDependencies();
  }

  Future<void> _getData() async {
    if (!isLoading) {
      setState(() => isLoading = true);
    }
    await Future<void>.delayed(const Duration(milliseconds: 500), () {});
    isLoading = false;
    if (mounted)
      setState(() {
        isLoading = true;
        initialData
            .addAll(Provider.of<ExpressionRepo>(context).collectiveExpressions);
      });
  }

  Widget _buildLoadExpressions() {
    return GestureDetector(
      onTap: () {
        _getData();
      },
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            stops: <double>[0.2, 0.9],
            colors: <Color>[
              Theme.of(context).colorScheme.secondary,
              Theme.of(context).colorScheme.primary
            ],
          ),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 15,
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'view 10 more expressions',
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w700),
            ),
            const SizedBox(width: 2.5),
            Icon(Icons.keyboard_arrow_down,
                size: 13, color: Theme.of(context).colorScheme.onPrimary)
          ],
        ),
      ),
    );
  }

  Widget _displayDegrees() {
    if (_perspective == 'Degrees of separation') {
      return DegreesOfSeparation(
        _changeDegree,
        _oneDegreeColor,
        _twoDegreesColor,
        _threeDegreesColor,
        _fourDegreesColor,
        _fiveDegreesColor,
        _sixDegreesColor,
      );
    } else {
      return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.background,
      child: ListView(
        controller: widget.controller,
        children: <Widget>[
          /// Degrees of Separation Widget rendered only when on the 'Degrees of separation'
          /// perspective
          _displayDegrees(),

          for (int index = 0; index < initialData.length + 1; index++)
            if (index == initialData.length)
              _buildLoadExpressions()
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
