import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/backend/repositories.dart';
import 'package:junto_beta_mobile/models/sphere.dart';
import 'package:junto_beta_mobile/screens/template/template.dart';
import 'package:junto_beta_mobile/app/palette.dart';
import 'package:junto_beta_mobile/utils/junto_dialog.dart';
import 'package:junto_beta_mobile/utils/junto_exception.dart';
import 'package:junto_beta_mobile/utils/junto_overlay.dart';
import 'package:provider/provider.dart';

class CreateSphereNext extends StatefulWidget {
  const CreateSphereNext({
    Key key,
    this.sphere,
  }) : super(key: key);

  static Route<dynamic> route(CentralizedSphere sphere) {
    return MaterialPageRoute<dynamic>(
      builder: (BuildContext context) {
        return CreateSphereNext(
          sphere: sphere,
        );
      },
    );
  }

  final CentralizedSphere sphere;

  @override
  _CreateSphereNextState createState() => _CreateSphereNextState();
}

class _CreateSphereNextState extends State<CreateSphereNext> {
  String _selectedType = 'Public';

  Future<void> _createSphere() async {
    JuntoOverlay.showLoader(context);
    final CentralizedSphere updatedSphere = widget.sphere.copyWith(
      privacy: _selectedType,
    );
    try {
      await Provider.of<GroupRepo>(context).createSphere(updatedSphere);
      JuntoOverlay.hide();
      Navigator.pushAndRemoveUntil(
          context,
          CupertinoPageRoute<dynamic>(
            builder: (BuildContext context) => JuntoTemplate(),
          ),
          (_) => false);
    } on JuntoException catch (error) {
      JuntoOverlay.hide();
      JuntoDialog.showJuntoDialog(
        context,
        error.message,
        <Widget>[
          FlatButton(
            onPressed: () => Navigator.of(context).pop,
            child: const Text('Ok'),
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(45),
        child: AppBar(
          automaticallyImplyLeading: false,
          brightness: Brightness.light,
          iconTheme: const IconThemeData(
            color: Color(0xff555555),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          titleSpacing: 0,
          title: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      color: Colors.white,
                      width: 38,
                      alignment: Alignment.centerLeft,
                      child: const Icon(
                        CustomIcons.back_arrow_left,
                        color: JuntoPalette.juntoSleek,
                        size: 28,
                      ),
                    )),
                const Text(
                  'Sphere Privacy',
                  style: TextStyle(
                      color: Color(0xff333333),
                      fontWeight: FontWeight.w700,
                      fontSize: 15),
                ),
                GestureDetector(
                    onTap: _createSphere,
                    child: Container(
                      color: Colors.white,
                      width: 38,
                      alignment: Alignment.centerRight,
                      child: const Text(
                        'create',
                        style:
                            TextStyle(color: Color(0xff333333), fontSize: 14),
                      ),
                    ))
              ],
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(
              height: 1,
              width: MediaQuery.of(context).size.width,
              color: const Color(0xffeeeeee),
            ),
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
              child: ListView(
            children: <Widget>[
              _SelectionTile(
                name: 'Public',
                desc: 'Anyone can join this sphere, read its, '
                    'expressions and share to it',
                onClick: (String privacy) {
                  setState(() => _selectedType = privacy);
                },
                isSelected: _selectedType == 'Public',
              ),
              _SelectionTile(
                name: 'Shared',
                desc: 'Only members can read expressions '
                    'and share to it. Facilitators can invite members or accept their request to join.',
                onClick: (String privacy) {
                  setState(() => _selectedType = privacy);
                },
                isSelected: _selectedType == 'Shared',
              ),
              _SelectionTile(
                name: 'Private',
                desc:
                    'Members must be invited into this sphere. This sphere is only searchable by members.',
                onClick: (String privacy) {
                  setState(() => _selectedType = privacy);
                },
                isSelected: _selectedType == 'Private',
              ),
            ],
          ))
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
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
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
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    widget.desc,
                  )
                ],
              ),
            ),
            AnimatedContainer(
              duration: kThemeChangeDuration,
              height: 22,
              width: 22,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: widget.isSelected
                        ? <Color>[
                            JuntoPalette.juntoSecondary,
                            JuntoPalette.juntoPrimary
                          ]
                        : <Color>[Colors.white, Colors.white],
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
