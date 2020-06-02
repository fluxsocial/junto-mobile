import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/widgets/previews/member_preview/member_preview.dart';
import 'package:flutter/cupertino.dart';
import 'package:junto_beta_mobile/app/logger/logger.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/widgets/progress_indicator.dart';
import 'package:provider/provider.dart';

class PerspectiveMembers extends StatelessWidget {
  const PerspectiveMembers({this.perspective});

  final PerspectiveModel perspective;

  Future<List<UserProfile>> fetchPerspectiveMembers(
      BuildContext context) async {
    final _members = await Provider.of<UserRepo>(context, listen: false)
        .getPerspectiveUsers(perspective.address);
    return _members;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(45),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Theme.of(context).backgroundColor,
          iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
          elevation: 0,
          titleSpacing: 0,
          brightness: Theme.of(context).brightness,
          title: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.only(left: 10),
                    width: 42,
                    height: 42,
                    alignment: Alignment.centerLeft,
                    color: Colors.transparent,
                    child: Icon(
                      CustomIcons.back,
                      color: Theme.of(context).primaryColorDark,
                      size: 17,
                    ),
                  ),
                ),
                Text(
                  'Members',
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                const SizedBox(width: 42)
              ],
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(.75),
            child: Container(
              height: .75,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Theme.of(context).dividerColor,
                    width: .75,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: FutureBuilder<List<UserProfile>>(
        future: fetchPerspectiveMembers(context),
        builder: (
          BuildContext context,
          AsyncSnapshot<List<UserProfile>> snapshot,
        ) {
          if (snapshot.hasError) {
            logger.logError(snapshot.error);
            return Container(
              child: const Text(
                'hmm, something is up...',
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
            );
          }
          if (snapshot.hasData) {
            return ListView(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 0,
              ),
              children: snapshot.data
                  .map(
                    (UserProfile user) => MemberPreview(
                      profile: user,
                    ),
                  )
                  .toList(),
            );
          }
          return Center(
            child: JuntoProgressIndicator(),
          );
        },
      ),
    );
  }
}
