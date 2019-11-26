import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/backend/repositories.dart';
import 'package:junto_beta_mobile/models/expression.dart';
import 'package:junto_beta_mobile/widgets/previews/expression_preview/expression_preview.dart';
import 'package:junto_beta_mobile/widgets/utils/hide_fab.dart';
import 'package:provider/provider.dart';

/// This screen shows a list of public expressions that can be filtered
/// by channel or perspective
class JuntoCollective extends StatefulWidget {
  const JuntoCollective({Key key, this.currentPerspective, this.visibility})
      : super(key: key);

  final String currentPerspective;
  final ValueNotifier<bool> visibility;

  @override
  State<StatefulWidget> createState() => JuntoCollectiveState();
}

class JuntoCollectiveState extends State<JuntoCollective> with HideFab {
  bool isLoading = false;
  List<CentralizedExpressionResponse> initialData =
      <CentralizedExpressionResponse>[];

  ScrollController _collectiveController;

  @override
  void initState() {
    super.initState();
    _collectiveController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _collectiveController.addListener(_onScrollingHasChanged);
      if (_collectiveController.hasClients)
        _collectiveController.position.isScrollingNotifier.addListener(
          _onScrollingHasChanged,
        );
    });
  }

  @override
  void dispose() {
    super.dispose();
    _collectiveController.removeListener(_onScrollingHasChanged);
    _collectiveController.dispose();
  }

  @override
  void didChangeDependencies() {
    initialData
        .addAll(Provider.of<ExpressionRepo>(context).collectiveExpressions);
    super.didChangeDependencies();
  }

  // ignore: unused_element
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

  void _onScrollingHasChanged() {
    super.hideFabOnScroll(_collectiveController, widget.visibility);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.background,
      child: FutureBuilder<List<CentralizedExpressionResponse>>(
        future:
            Provider.of<ExpressionRepo>(context).getCollectiveExpressions(),
        builder: (
          BuildContext context,
          AsyncSnapshot<List<CentralizedExpressionResponse>> snapshot,
        ) {
          if (snapshot.hasError) {
            return Container(
              child: const Text('Error occured'),
            );
          }
          if (!snapshot.hasData) {
            return Container(
              child: SizedBox.fromSize(
                size: const Size.fromHeight(25.0),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          }
          return ListView.builder(
            controller: _collectiveController,
            itemCount: snapshot.data.length,
            cacheExtent: MediaQuery.of(context).size.height * 1.5,
            itemBuilder: (BuildContext context, int index) {
              return ExpressionPreview(expression: snapshot.data[index]);
            },
          );
        },
      ),
    );
  }
//  @override
//  Widget build(BuildContext context) {
//    return Container(
//      color: Theme.of(context).colorScheme.background,
//      child: ListView(
//        controller: _collectiveController,
//        children: <Widget>[
//          Row(
//            mainAxisAlignment: MainAxisAlignment.start,
//            crossAxisAlignment: CrossAxisAlignment.start,
//            children: <Widget>[
//              Container(
//                width: MediaQuery.of(context).size.width * .5,
//                padding: const EdgeInsets.only(left: 10, right: 5, top: 10),
//                child: Column(
//                  mainAxisAlignment: MainAxisAlignment.start,
//                  children: <Widget>[
//                    for (int index = 0; index < initialData.length + 1; index++)
//                      if (index == initialData.length)
//                        const SizedBox()
//                      else if (index.isEven)
//                        ExpressionPreview(expression: initialData[index])
//                  ],
//                ),
//              ),
//              Container(
//                width: MediaQuery.of(context).size.width * .5,
//                padding: const EdgeInsets.only(left: 5, right: 10, top: 10),
//                child: Column(
//                  mainAxisAlignment: MainAxisAlignment.start,
//                  children: <Widget>[
//                    for (int index = 0; index < initialData.length + 1; index++)
//                      if (index == initialData.length)
//                        const SizedBox()
//                      else if (index.isOdd)
//                        ExpressionPreview(expression: initialData[index])
//                  ],
//                ),
//              ),
//            ],
//          )
//        ],
//      ),
//    );
//  }
}
