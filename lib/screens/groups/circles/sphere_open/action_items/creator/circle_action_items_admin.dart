import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:junto_beta_mobile/app/logger/logger.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/groups/circles/bloc/circle_bloc.dart';
import 'package:junto_beta_mobile/screens/groups/circles/sphere_open/action_items/creator/edit_group.dart';
import 'package:junto_beta_mobile/widgets/dialogs/confirm_dialog.dart';

// This component is used in ExpressionPreview and ExpressionOpen
// as the 'more' icon is pressed to view the action items
// available for each expression
class CircleActionItemsAdmin extends StatefulWidget {
  const CircleActionItemsAdmin({
    Key key,
    @required this.sphere,
    @required this.userProfile,
    @required this.isCreator,
    this.goBack,
  }) : super(key: key);

  final Group sphere;
  final UserProfile userProfile;
  final bool isCreator;
  final Function goBack;

  @override
  _CircleActionItemsAdminState createState() => _CircleActionItemsAdminState();
}

class _CircleActionItemsAdminState extends State<CircleActionItemsAdmin> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CircleBloc, CircleState>(
      builder: (context, state) {
        return Container(
          height: MediaQuery.of(context).size.height * .4,
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
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
                            color: Theme.of(context).dividerColor,
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ListTile(
                      contentPadding: const EdgeInsets.all(0),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (BuildContext context) =>
                                EditCircle(sphere: widget.sphere),
                          ),
                        );
                      },
                      title: Row(
                        children: <Widget>[
                          Icon(
                            Icons.edit,
                            size: 17,
                            color: Theme.of(context).primaryColor,
                          ),
                          const SizedBox(width: 15),
                          Text(
                            'Edit Sphere',
                            style: Theme.of(context).textTheme.headline5,
                          ),
                        ],
                      ),
                    ),
                    if (widget.isCreator)
                      ListTile(
                        contentPadding: const EdgeInsets.all(0),
                        onTap: () {
                          Navigator.pop(context);
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => ConfirmDialog(
                              buildContext: context,
                              confirm: () {
                                try {
                                  context.bloc<CircleBloc>().add(DeleteCircle(
                                        sphereAddress: widget.sphere.address,
                                      ));

                                  widget.goBack();
                                } catch (e, s) {
                                  logger.logException(e, s);
                                }
                              },
                              confirmationText:
                                  'Are you sure you want to delete this circle?',
                            ),
                          );
                        },
                        title: Row(
                          children: <Widget>[
                            Icon(
                              Icons.delete,
                              size: 17,
                              color: Theme.of(context).primaryColor,
                            ),
                            const SizedBox(width: 15),
                            Text(
                              'Delete Circle',
                              style: Theme.of(context).textTheme.headline5,
                            ),
                          ],
                        ),
                      ),
                    if (!widget.isCreator)
                      ListTile(
                        contentPadding: const EdgeInsets.all(0),
                        onTap: () {
                          Navigator.pop(context);
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => ConfirmDialog(
                              buildContext: context,
                              confirm: () {
                                try {
                                  context.bloc<CircleBloc>().add(LeaveCircle(
                                        sphereAdress: widget.sphere.address,
                                        userAddress: widget.userProfile.address,
                                      ));

                                  widget.goBack();
                                } catch (e, s) {
                                  logger.logException(e, s);
                                }
                              },
                              confirmationText:
                                  'Are you sure you want to leave this circle?',
                            ),
                          );
                        },
                        title: Row(
                          children: <Widget>[
                            Icon(
                              Icons.block,
                              size: 17,
                              color: Theme.of(context).primaryColor,
                            ),
                            const SizedBox(width: 15),
                            Text(
                              'Leave Circle',
                              style: Theme.of(context).textTheme.headline5,
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
