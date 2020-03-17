import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/models/user_model.dart';
import 'package:junto_beta_mobile/screens/groups/groups_actions/packs/packs.dart';
import 'package:junto_beta_mobile/screens/groups/groups_actions/spheres/spheres_temp.dart';

class JuntoGroupsActions extends StatefulWidget {
  const JuntoGroupsActions({
    @required this.changeGroup,
    @required this.spheresVisible,
    this.userProfile,
  });

  final UserData userProfile;
  final Function changeGroup;
  final bool spheresVisible;

  @override
  State<StatefulWidget> createState() => JuntoGroupsActionsState();
}

class JuntoGroupsActionsState extends State<JuntoGroupsActions> {
  ValueNotifier<bool> _spheresVisible;

  @override
  void initState() {
    super.initState();
    _spheresVisible = ValueNotifier<bool>(widget.spheresVisible);
  }

  @override
  void didUpdateWidget(JuntoGroupsActions oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.spheresVisible != _spheresVisible.value) {
      _spheresVisible.value = widget.spheresVisible;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      color: Theme.of(context).backgroundColor,
      height: MediaQuery.of(context).size.height - 90,
      child: ValueListenableBuilder<bool>(
        valueListenable: _spheresVisible,
        builder: (BuildContext context, bool snapshot, _) {
          return Stack(
            children: <Widget>[
              if (snapshot) SpheresTemp(),
              if (!snapshot)
                Packs(
                  userProfile: widget.userProfile,
                  changeGroup: widget.changeGroup,
                ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: OverlayMenu(spheresVisible: _spheresVisible),
              ),
            ],
          );
        },
      ),
    );
  }
}

class OverlayMenu extends StatelessWidget {
  const OverlayMenu({
    Key key,
    @required this.spheresVisible,
  }) : super(key: key);
  final ValueNotifier<bool> spheresVisible;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).backgroundColor,
        border: Border.all(
          color: Theme.of(context).dividerColor,
          width: .75,
        ),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: GestureDetector(
              onTap: () {
                spheresVisible.value = false;
              },
              child: Container(
                color: Colors.transparent,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      CustomIcons.packs,
                      size: 20,
                      color: spheresVisible.value
                          ? Theme.of(context).primaryColorLight
                          : Theme.of(context).primaryColorDark,
                    ),
                    const SizedBox(height: 7),
                    Text(
                      'PACKS',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: spheresVisible.value
                            ? Theme.of(context).primaryColorLight
                            : Theme.of(context).primaryColorDark,
                        decoration: TextDecoration.none,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => spheresVisible.value = true,
              child: Container(
                color: Colors.transparent,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      CustomIcons.spheres,
                      size: 20,
                      color: spheresVisible.value
                          ? Theme.of(context).primaryColorDark
                          : Theme.of(context).primaryColorLight,
                    ),
                    const SizedBox(height: 7),
                    Text(
                      'CIRCLES',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: spheresVisible.value
                            ? Theme.of(context).primaryColorDark
                            : Theme.of(context).primaryColorLight,
                        decoration: TextDecoration.none,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
