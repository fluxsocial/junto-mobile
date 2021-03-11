import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:junto_beta_mobile/app/logger/logger.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/groups/circles/bloc/circle_bloc.dart';
import 'package:junto_beta_mobile/screens/groups/circles/sphere_open/sphere_open_members/sphere_search.dart';
import 'package:junto_beta_mobile/widgets/dialogs/confirm_dialog.dart';

// This component is used in ExpressionPreview and ExpressionOpen
// as the 'more' icon is pressed to view the action items
// available for each expression
class CircleActionItemsMember extends StatelessWidget {
  const CircleActionItemsMember({
    Key key,
    @required this.sphere,
    @required this.userProfile,
    @required this.members,
    @required this.circleCreator,
    this.goBack,
  }) : super(key: key);

  final Group sphere;
  final UserProfile userProfile;
  final List<Users> members;
  final UserProfile circleCreator;
  final Function goBack;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CircleBloc, CircleState>(builder: (context, state) {
      return Container(
        color: Colors.transparent,
        child: Container(
          height: MediaQuery.of(context).size.height * .4,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => ConfirmDialog(
                          buildContext: context,
                          confirm: () {
                            try {
                              context.read<CircleBloc>().add(
                                    LeaveCircle(
                                      sphereAdress: sphere.address,
                                      userAddress: userProfile.address,
                                    ),
                                  );

                              goBack();
                            } catch (e, s) {
                              logger.logException(e, s);
                            }
                          },
                          confirmationText:
                              'Are you sure you want to leave this community?',
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
                        Text('Leave Community',
                            style: Theme.of(context).textTheme.headline5),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}
