import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/collective/collective_fab.dart';
import 'package:junto_beta_mobile/screens/collective/perspectives/bloc/perspectives_bloc.dart';
import 'package:junto_beta_mobile/screens/collective/perspectives/perspective_item.dart';
import 'package:junto_beta_mobile/screens/collective/perspectives/perspectives_header.dart';
import 'package:junto_beta_mobile/screens/collective/perspectives/perspectves_list.dart';

class JuntoPerspectives extends StatelessWidget {
  const JuntoPerspectives();

  @override
  Widget build(BuildContext context) {
    final perspectivesBloc = context.bloc<PerspectivesBloc>();
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
    return Scaffold(
      floatingActionButton: CollectiveActionButton(
        isVisible: ValueNotifier(true),
        actionsVisible: true,
        onTap: () {
          Navigator.maybePop(context);
        },
        onUpTap: () {},
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Container(
                color: Theme.of(context).backgroundColor,
                child: PerspectivesHeader(),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(0),
                children: <Widget>[
                  PerspectiveItem(
                    perspective: juntoPerspective,
                    onTap: () => perspectivesBloc
                        .add(ChangePerspective(juntoPerspective)),
                  ),
                  PerspectivesList(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
