import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/screens/create/create_actions/create_actions_appbar.dart';
import 'package:junto_beta_mobile/palette.dart';

class CreateActions extends StatefulWidget {
  const CreateActions({
    Key key,
    @required this.expressionLayer,
  }) : super(key: key);

  final String expressionLayer;

  @override
  State<StatefulWidget> createState() => CreateActionsState();
}

class CreateActionsState extends State<CreateActions> {
  final List<String> _channels = <String>[];
  String _selectedType = 'Collective';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(45),
        child: CreateActionsAppbar(),
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
              _buildLayersModal(context);
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
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(width: 1),
                  Icon(Icons.keyboard_arrow_down,
                      color: Color(0xff333333), size: 17)
                ],
              ),
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
      builder: (context) => Container(
            color: Color(0xff737373),
            child: Container(
              height: MediaQuery.of(context).size.height * .9,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width - 60,
                        decoration: BoxDecoration(
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
                            hintStyle: const TextStyle(
                                color: Color(0xff999999),
                                fontSize: 17,
                                fontWeight: FontWeight.w500),
                          ),
                          cursorColor: Color(0xff333333),
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
          ),
    );
  }

  // Build bottom modal to add channels to expression
  void _buildLayersModal(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => Container(
            color: Color(0xff737373),
            child: Container(
              height: MediaQuery.of(context).size.height * .9,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 10),
                  Text(
                    'Where would you like to share?',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff333333),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Will build when API is 100%.. members can choose between collective, any spheres they belong to, pack, and den',
                    style: TextStyle(fontSize: 15),
                  )
                ],
              ),
            ),
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
                        ? [
                            JuntoPalette.juntoSecondary,
                            JuntoPalette.juntoPrimary
                          ]
                        : [Colors.white, Colors.white],
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight),
                // color: widget.isSelected ? JuntoPalette.juntoPrimary : null,
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
