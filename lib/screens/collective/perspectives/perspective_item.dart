import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/collective/collective_actions/edit_perspective.dart';
import 'package:junto_beta_mobile/screens/collective/perspectives/bloc/perspectives_bloc.dart';
import 'package:junto_beta_mobile/widgets/dialogs/confirm_dialog.dart';
import 'package:junto_beta_mobile/screens/collective/perspectives/about_perspective.dart';

class PerspectiveItem extends StatelessWidget {
  const PerspectiveItem({
    Key key,
    @required this.perspective,
    @required this.onTap,
  }) : super(key: key);
  final PerspectiveModel perspective;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _buildPerspective(
      context,
      perspective,
      onTap,
    );
  }

  Widget _buildPerspective(
      BuildContext context, PerspectiveModel perspective, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Slidable(
        enabled: !perspective.isDefault,
        actionPane: const SlidableDrawerActionPane(),
        actionExtentRatio: 0.2,
        secondaryActions: <Widget>[
          IconSlideAction(
            color: Theme.of(context).dividerColor,
            iconWidget: Icon(Icons.edit,
                size: 15, color: Theme.of(context).primaryColor),
            onTap: () {
              Navigator.push(
                context,
                CupertinoPageRoute<dynamic>(
                  builder: (BuildContext context) => EditPerspective(
                    perspective: perspective,
                  ),
                ),
              );
            },
          ),
          IconSlideAction(
            color: Colors.red,
            iconWidget: Icon(Icons.delete, size: 15, color: Colors.white),
            onTap: () async {
              showDialog(
                context: context,
                builder: (BuildContext context) => ConfirmDialog(
                  confirmationText:
                      'Are you sure you want to delete this perspective?',
                  confirm: () {
                    context
                        .bloc<PerspectivesBloc>()
                        .add(RemovePerspective(perspective));
                  },
                ),
              );
            },
          ),
        ],
        key: Key(perspective.address),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border(
              bottom: BorderSide(
                color: Theme.of(context).dividerColor,
                width: .75,
              ),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Image.asset(
                    'assets/images/junto-mobile__perspective--rainbow.png',
                    height: 20,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    perspective.name,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    builder: (BuildContext context) => AboutPerspective(
                      incomingPerspective: perspective,
                    ),
                  );
                },
                child: Container(
                  width: 38,
                  alignment: Alignment.centerRight,
                  color: Colors.transparent,
                  child: Icon(
                    CustomIcons.morevertical,
                    size: 17,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
