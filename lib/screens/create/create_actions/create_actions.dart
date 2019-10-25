import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/expression.dart';
import 'package:junto_beta_mobile/providers/provider.dart';
import 'package:junto_beta_mobile/screens/create/create_actions/create_actions_appbar.dart';
import 'package:junto_beta_mobile/custom_icons.dart';
import 'package:junto_beta_mobile/palette.dart';
import 'package:provider/provider.dart';

class CreateActions extends StatefulWidget {
  const CreateActions({
    Key key,
    @required this.expressionLayer,
    @required this.expressionType,
    @required this.expression,
    @required this.address,
  }) : super(key: key);

  final String expressionLayer;
  final String expressionType;
  final dynamic expression;
  final String address;

  @override
  State<StatefulWidget> createState() => CreateActionsState();
}

class CreateActionsState extends State<CreateActions> {
  //ignore: unused_field
  final List<String> _channels = <String>[];

  //ignore: unused_field
  final String _selectedType = 'Collective';

  // instantiate TextEditingController to pass to TextField widget
  TextEditingController _channelController;

  @override
  void initState() {
    super.initState();
    _channelController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _channelController.dispose();
  }

  Future<void> _createExpression() async {
    final CentralizedExpression _expression = CentralizedExpression(
      type: widget.expressionType,
      context: <String, dynamic>{
        'Group': <String, dynamic>{'address': widget.address}
      },
      expressionData: widget.expression.toMap(),
    );
    final CentralizedExpressionResponse result =
        await Provider.of<CollectiveProvider>(context)
            .createExpression(_expression);
    print(result.address);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(45),
        child: CreateActionsAppbar(
          onCreateTap: _createExpression,
        ),
      ),
      body: ListView(
        children: <Widget>[
          GestureDetector(
            onTap: () => _buildChannelsModal(context),
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Color(0xffeeeeee),
                    width: 1,
                  ),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: const Text('# add channels',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
            ),
          ),
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (BuildContext context) {
                  return _ExpressionLayerBottomSheet();
                },
              );
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Color(0xffeeeeee),
                    width: 1,
                  ),
                ),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 20,
              ),
              child: Row(
                children: <Widget>[
                  Text(
                    'sharing to ' + widget.expressionLayer,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(width: 1),
                  Icon(Icons.keyboard_arrow_down,
                      color: const Color(0xff333333), size: 17)
                ],
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Color(0xffeeeeee),
                  width: 1,
                ),
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: TextField(
              buildCounter: (
                BuildContext context, {
                int currentLength,
                int maxLength,
                bool isFocused,
              }) =>
                  null,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintStyle: const TextStyle(
                    color: Color(0xff333333),
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                  hintText: 'set an intention (optional)'),
              cursorColor: const Color(0xff333333),
              cursorWidth: 2,
              maxLines: null,
              style: const TextStyle(
                  color: Color(0xff333333),
                  fontSize: 15,
                  fontWeight: FontWeight.w500),
              maxLength: 240,
              textInputAction: TextInputAction.done,
            ),
          ),
        ],
      ),
    );
  }

  // Build bottom modal to add channels to expression
  void _buildChannelsModal(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: const Color(0xff737373),
          child: Container(
            height: MediaQuery.of(context).size.height * .6,
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: 5,
                      width: MediaQuery.of(context).size.width * .1,
                      decoration: BoxDecoration(
                          color: Color(0xffeeeeee),
                          borderRadius: BorderRadius.circular(100)),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width - 60,
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Color(0xffeeeeee),
                            width: .75,
                          ),
                        ),
                      ),
                      child: TextField(
                        controller: _channelController,
                        buildCounter: (
                          BuildContext context, {
                          int currentLength,
                          int maxLength,
                          bool isFocused,
                        }) =>
                            null,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Add up to five channels',
                          hintStyle: TextStyle(
                              color: Color(0xff999999),
                              fontSize: 17,
                              fontWeight: FontWeight.w500),
                        ),
                        cursorColor: const Color(0xff333333),
                        cursorWidth: 2,
                        maxLines: null,
                        style: const TextStyle(
                            color: Color(0xff333333),
                            fontSize: 17,
                            fontWeight: FontWeight.w500),
                        maxLength: 80,
                        textInputAction: TextInputAction.done,
                      ),
                    ),
                    Container(
                      child: Icon(Icons.add, size: 20),
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ExpressionLayerBottomSheet extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ExpressionLayerBottomSheetState();
  }
}

class _ExpressionLayerBottomSheetState
    extends State<_ExpressionLayerBottomSheet> {
  PageController _pageController;
  bool _chooseBase = true;
  bool _chooseSpheres = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xff737373),
      child: Container(
        height: MediaQuery.of(context).size.height * .6,
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: 5,
                      width: MediaQuery.of(context).size.width * .1,
                      decoration: BoxDecoration(
                          color: const Color(0xffeeeeee),
                          borderRadius: BorderRadius.circular(100)),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        _pageController.jumpToPage(0);
                      },
                      child: Text(
                        'Base',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: _chooseBase
                              ? const Color(0xff333333)
                              : const Color(0xff999999),
                        ),
                      ),
                    ),
                    const SizedBox(width: 25),
                    GestureDetector(
                      onTap: () {
                        _pageController.jumpToPage(1);
                      },
                      child: Text(
                        'Spheres',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: _chooseSpheres
                              ? const Color(0xff333333)
                              : const Color(0xff999999),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (int index) {
                      if (index == 0) {
                        setState(() {
                          _chooseBase = true;
                          _chooseSpheres = false;
                        });
                      } else if (index == 1) {
                        setState(() {
                          _chooseBase = false;
                          _chooseSpheres = true;
                        });
                      }
                    },
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Expanded(
                              child: ListView(
                            children: <Widget>[
                              _expressionLayerWidget('Collective'),
                              _expressionLayerWidget('My Pack'),
                              _expressionLayerWidget('Private Den'),
                            ],
                          )),
                        ],
                      ),
                      const Center(
                        child: Text('spheres'),
                      )
                    ],
                  ),
                )

                // Container(height: 50, color: Colors.green)
              ],
            ),
            Positioned(
              bottom: 15,
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: 9,
                      width: 9,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        gradient: _chooseBase
                            ? LinearGradient(
                                colors: [
                                  JuntoPalette.juntoSecondary,
                                  JuntoPalette.juntoPrimary
                                ],
                                begin: Alignment.bottomLeft,
                                end: Alignment.topRight,
                                stops: [0.1, 0.9])
                            : null,
                        color: _chooseBase ? null : Color(0xffeeeeee),
                      ),
                    ),
                    SizedBox(width: 6),
                    Container(
                      height: 9,
                      width: 9,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        gradient: _chooseSpheres
                            ? LinearGradient(
                                colors: [
                                  JuntoPalette.juntoSecondary,
                                  JuntoPalette.juntoPrimary
                                ],
                                begin: Alignment.bottomLeft,
                                end: Alignment.topRight,
                                stops: [0.1, 0.9])
                            : null,
                        color: _chooseSpheres ? null : Color(0xffeeeeee),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _expressionLayerWidget(layer) {
    var expressionLayerIcon;

    if (layer == 'Collective') {
      expressionLayerIcon = CustomIcons.lotus;
    } else if (layer == 'My Pack') {
      expressionLayerIcon = CustomIcons.packs;
    } else if (layer == 'Private Den') {
      expressionLayerIcon = CustomIcons.profile;
    }

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
      title: Row(
        children: <Widget>[
          Icon(
            expressionLayerIcon,
            size: 17,
            color: const Color(0xff555555),
          ),
          const SizedBox(width: 20),
          Text(
            layer,
            style: const TextStyle(
                fontSize: 17,
                color: Color(0xff333333),
                fontWeight: FontWeight.w500),
          )
        ],
      ),
    );
  }
}

class _SelectionTile extends StatefulWidget {
  const _SelectionTile({
    Key key,
    @required this.name,
    @required this.desc,
    @required this.onClick,
    @required this.isSelected,
  }) : super(key: key);

  final String name;
  final String desc;
  final bool isSelected;
  final ValueChanged<String> onClick;

  @override
  State createState() => _SelectionTileState();
}

class _SelectionTileState extends State<_SelectionTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xffeeeeee), width: 1),
        ),
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 15,
      ),
      child: InkWell(
        onTap: () => widget.onClick(widget.name),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width * .75,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            AnimatedContainer(
              duration: kThemeChangeDuration,
              height: 17,
              width: 17,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: widget.isSelected
                        ? <Color>[
                            JuntoPalette.juntoSecondary,
                            JuntoPalette.juntoPrimary
                          ]
                        : <Color>[
                            Colors.white,
                            Colors.white,
                          ],
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight),
                border: Border.all(
                  color: widget.isSelected
                      ? Colors.white
                      : const Color(0xffeeeeee),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(25),
              ),
            )
          ],
        ),
      ),
    );
  }
}
