import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/collective/collective_actions/edit_perspective.dart';
import 'package:junto_beta_mobile/screens/collective/perspectives/bloc/perspectives_bloc.dart';
import 'package:junto_beta_mobile/widgets/dialogs/confirm_dialog.dart';

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
          padding: const EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border(
              bottom:
                  BorderSide(color: Theme.of(context).dividerColor, width: .75),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                height: 45.0,
                width: 45.0,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    stops: const <double>[0.2, 0.9],
                    colors: <Color>[
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.secondary,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Icon(
                  CustomIcons.newperspective,
                  size: 28,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(perspective.name,
                        style: Theme.of(context).textTheme.subtitle1),
                    if (perspective.name == 'JUNTO')
                      Text(
                        'Expressions from everyone on Junto.',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    if (perspective.name == 'Connections')
                      Text(
                        'Expressions from people you are connected with.',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    if (perspective.name == 'Subscriptions')
                      Text(
                        'Expressions from specific people you are subscribed to.',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    if (perspective.name != 'JUNTO' &&
                        perspective.name != 'Connections' &&
                        perspective.name != 'Subscriptions' &&
                        perspective.about != null)
                      Text(
                        perspective.about,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
