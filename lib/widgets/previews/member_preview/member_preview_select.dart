import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/user_model.dart';

class MemberPreviewSelect extends StatefulWidget {
  const MemberPreviewSelect(
      {Key key, this.profile, this.onSelect, this.onDeselect})
      : super(key: key);

  final UserProfile profile;
  final Function onSelect;
  final Function onDeselect;
  @override
  State<StatefulWidget> createState() {
    return MemberPreviewSelectState();
  }
}

class MemberPreviewSelectState extends State<MemberPreviewSelect> {
  bool _isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.background,
      child: Row(
        children: <Widget>[
          Row(
            children: <Widget>[
              ClipOval(
                child: Image.asset(
                  'assets/images/junto-mobile__placeholder--member.png',
                  height: 45.0,
                  width: 45.0,
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width - 75,
                padding: const EdgeInsets.symmetric(
                  vertical: 15,
                ),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      width: .5,
                      color: Theme.of(context).dividerColor,
                    ),
                  ),
                ),
                margin: const EdgeInsets.only(left: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('sunyata',
                            textAlign: TextAlign.start,
                            style: Theme.of(context).textTheme.subhead),
                        Text('Eric Yang',
                            textAlign: TextAlign.start,
                            style: Theme.of(context).textTheme.body1)
                      ],
                    ),
                    _isSelected
                        ? GestureDetector(
                            onTap: () {
                              setState(() {
                                _isSelected = false;
                              });
                              widget.onDeselect();
                            },
                            child: Container(
                              height: 28,
                              width: 28,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  stops: const <double>[0.1, 0.9],
                                  colors: <Color>[
                                    Theme.of(context)
                                        .colorScheme
                                        .secondaryVariant,
                                    Theme.of(context)
                                        .colorScheme
                                        .primaryVariant,
                                  ],
                                ),
                                border: Border.all(
                                    color: Theme.of(context).backgroundColor,
                                    width: 1),
                              ),
                              alignment: Alignment.center,
                              child: Icon(Icons.add,
                                  color: Colors.white, size: 17),
                            ),
                          )
                        : GestureDetector(
                            onTap: () {
                              setState(() {
                                _isSelected = true;
                              });

                              widget.onSelect();
                            },
                            child: Container(
                              height: 28,
                              width: 28,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                border: Border.all(
                                    color: Theme.of(context).primaryColor,
                                    width: 1),
                              ),
                              alignment: Alignment.center,
                              child: Icon(Icons.add,
                                  color: Theme.of(context).primaryColor,
                                  size: 17),
                            ),
                          )
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
