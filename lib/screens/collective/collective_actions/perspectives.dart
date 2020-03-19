import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/collective/bloc/collective_bloc.dart';
import 'package:junto_beta_mobile/screens/collective/collective_actions/create_perspective.dart';
import 'package:junto_beta_mobile/screens/collective/collective_actions/edit_perspective.dart';
import 'package:junto_beta_mobile/screens/collective/perspectives/bloc/perspectives_bloc.dart';
import 'package:junto_beta_mobile/utils/junto_overlay.dart';
import 'package:junto_beta_mobile/widgets/dialogs/single_action_dialog.dart';
import 'package:junto_beta_mobile/widgets/dialogs/confirm_dialog.dart';
import 'package:junto_beta_mobile/utils/junto_exception.dart'
    show JuntoException;
import 'package:provider/provider.dart';

class JuntoPerspectives extends StatefulWidget {
  const JuntoPerspectives({this.onChanged});

  final Function(BuildContext, PerspectiveModel) onChanged;

  @override
  State<StatefulWidget> createState() {
    return JuntoPerspectivesState();
  }
}

class JuntoPerspectivesState extends State<JuntoPerspectives> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    const juntoPerspective = const PerspectiveModel(
      address: null,
      name: 'JUNTO',
      about: null,
      creator: null,
      createdAt: null,
      isDefault: true,
      userCount: null,
      users: null,
    );
    return Container(
      height: MediaQuery.of(context).size.height - 150,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            height: 100,
            padding: const EdgeInsets.symmetric(vertical: 10),
            color: Theme.of(context).backgroundColor,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Perspectives',
                  style: Theme.of(context).textTheme.headline4,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute<dynamic>(
                        builder: (BuildContext ctx) => CreatePerspectivePage(
                          refreshPerspectives: () => context
                              .bloc<PerspectivesBloc>()
                              .add(FetchPerspectives()),
                        ),
                      ),
                    );
                  },
                  child: Icon(
                    Icons.add,
                    size: 24,
                    color: Theme.of(context).primaryColor,
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(0),
              children: <Widget>[
                PerspectiveItem(
                  perspective: juntoPerspective,
                  onTap: () => widget.onChanged(context, juntoPerspective),
                ),
                PerspectivesList(onChanged: widget.onChanged),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class PerspectivesList extends StatelessWidget {
  const PerspectivesList({
    Key key,
    this.onChanged,
  }) : super(key: key);

  final Function(BuildContext, PerspectiveModel) onChanged;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PerspectivesBloc, PerspectivesState>(
      builder: (
        BuildContext context,
        PerspectivesState state,
      ) {
        if (state is PerspectivesError) {
          return Container(
            child: const Text(
              'hmm, something is up...',
              style: TextStyle(fontSize: 14, color: Colors.white),
            ),
          );
        }
        if (state is PerspectivesFetched) {
          return Column(
            children: <Widget>[
              // display Subscriptions perspective first
              ListView(
                padding: const EdgeInsets.all(0),
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                children:
                    state.perspectives.map((PerspectiveModel perspective) {
                  if (perspective.isDefault == true) {
                    return PerspectiveItem(
                      perspective: perspective,
                      onTap: () => onChanged(context, perspective),
                    );
                  } else {
                    return const SizedBox();
                  }
                }).toList(),
              ),
              // display rest of perspectives
              ListView(
                padding: const EdgeInsets.all(0),
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                children: state.perspectives.map(
                  (PerspectiveModel perspective) {
                    if (perspective.name != 'Connections' &&
                        perspective.name != 'Subscriptions') {
                      return GestureDetector(
                        child: PerspectiveItem(
                          perspective: perspective,
                          onTap: () => onChanged(context, perspective),
                          // context.bloc<CollectiveBloc>().add(
                          //       ChangePerspective(perspective),
                          //     ),
                        ),
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                ).toList(),
              )
            ],
          );
        }
        return Container();
      },
    );
  }
}

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
                    refreshPerspectives: () => _refreshPerspectives(context),
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
                      _deletePerspective(context, perspective);
                    },
                  ),
                );
              }),
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
                child: Image.asset('assets/images/junto-mobile__binoculars.png',
                    height: 15, color: Colors.white),
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
                        'Expressions from everyone in Junto.',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    if (perspective.name == 'Connections')
                      Text(
                        'Expressions from people you are connected with.',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    if (perspective.name == 'Subscriptions')
                      Text(
                        'Expressions from specific people you\'re subscribed to.',
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

  Future<void> _deletePerspective(
      BuildContext context, PerspectiveModel perspective) async {
    print(perspective);
    try {
      //TODO(dominik): replace with bloc
      JuntoLoader.showLoader(context);
      await Provider.of<UserRepo>(context, listen: false)
          .deletePerspective(perspective.address);
      context.bloc<PerspectivesBloc>().add(FetchPerspectives());
      JuntoLoader.hide();
      Navigator.pop(context);
    } catch (error) {
      print(error);
      JuntoLoader.hide();
    }
  }

  Future<void> _refreshPerspectives(BuildContext context) async {
    try {
      context.bloc<PerspectivesBloc>().add(FetchPerspectives());
    } on JuntoException catch (error) {
      //TODO replace with bloc
      showDialog(
        context: context,
        builder: (BuildContext context) => SingleActionDialog(
          dialogText: error.message,
        ),
      );
    }
  }
}
