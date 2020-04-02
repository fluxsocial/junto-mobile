import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/backend/repositories.dart';
import 'package:junto_beta_mobile/generated/l10n.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/widgets/dialogs/single_action_dialog.dart';
import 'package:junto_beta_mobile/utils/junto_exception.dart';
import 'package:junto_beta_mobile/utils/junto_overlay.dart';
import 'package:junto_beta_mobile/widgets/progress_indicator.dart';
import 'package:provider/provider.dart';

class NotificationScreen extends StatefulWidget {
  static Route<dynamic> route() {
    return MaterialPageRoute<dynamic>(
      builder: (BuildContext context) => NotificationScreen(),
    );
  }

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    with SingleTickerProviderStateMixin {
  NotificationRepo notificationService;
  TabController _tabController;
  UserRepo userRepo;
  GroupRepo groupRepo;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    notificationService = Provider.of<NotificationRepo>(context);
    userRepo = Provider.of<UserRepo>(context, listen: false);
    groupRepo = Provider.of<GroupRepo>(context, listen: false);
  }

  Future<void> acceptConnection(final UserProfile user) async {
    try {
      JuntoLoader.showLoader(context);
      userRepo.respondToConnection(user.address, true);
      JuntoLoader.hide();
      setState(() {});
    } on JuntoException catch (error) {
      JuntoLoader.hide();
      showDialog(
        context: context,
        builder: (BuildContext context) => SingleActionDialog(
          dialogText: S.of(context).common_network_error,
        ),
      );
    }
  }

  Future<void> rejectConnection(final UserProfile user) async {
    try {
      JuntoLoader.showLoader(context);
      userRepo.respondToConnection(user.address, false);
      JuntoLoader.hide();
      setState(() {});
    } on JuntoException catch (error) {
      JuntoLoader.hide();
      showDialog(
        context: context,
        builder: (BuildContext context) => SingleActionDialog(
          dialogText: S.of(context).common_network_error,
        ),
      );
    }
  }

  Future<void> acceptGroupConnection(final Group group) async {
    try {
      JuntoLoader.showLoader(context);
      groupRepo.respondToGroupRequest(group.address, true);
      JuntoLoader.hide();
      setState(() {});
    } on JuntoException catch (error) {
      JuntoLoader.hide();
      showDialog(
        context: context,
        builder: (BuildContext context) => SingleActionDialog(
          dialogText: S.of(context).common_network_error,
        ),
      );
    }
  }

  Future<void> rejectGroupConnection(final Group group) async {
    try {
      JuntoLoader.showLoader(context);
      groupRepo.respondToGroupRequest(group.address, false);
      JuntoLoader.hide();
      setState(() {});
    } on JuntoException catch (error) {
      JuntoLoader.hide();
      showDialog(
        context: context,
        builder: (BuildContext context) => SingleActionDialog(
          dialogText: S.of(context).common_network_error,
        ),
      );
    }
  }

  Widget _buildGroupBody(
      final NotificationResultsModel data, BuildContext context) {
    return ListView(
      children: <Widget>[
        if (data.groupJoinNotifications.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: _EmptyResults(
              name: S.of(context).notifications_no_new_group_notif,
            ),
          ),
        if (data.groupJoinNotifications.isNotEmpty)
          for (Group item in data.groupJoinNotifications)
            _ActionTile(
              key: ValueKey<String>(item.address),
              onPrimaryAction: () => acceptGroupConnection(item),
              onSecondaryAction: () => rejectGroupConnection(item),
              subtitle: S.of(context).notifications_creator,
              title: item.groupData.name,
            ),
      ],
    );
  }

  Widget _buildConnectionBody(
      final NotificationResultsModel data, BuildContext context) {
    return ListView(
      children: <Widget>[
        if (data.connectionNotifications.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: _EmptyResults(
              name: S.of(context).notifications_no_new_connection_notif,
            ),
          ),
        if (data.connectionNotifications.isNotEmpty)
          for (UserProfile item in data.connectionNotifications)
            _ActionTile(
              key: ValueKey<String>(item.address),
              onPrimaryAction: () => acceptConnection(item),
              onSecondaryAction: () => rejectConnection(item),
              subtitle: '@${item.username}',
              title: item.name,
            ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1.0,
        title: Text(
          S.of(context).notifications_title,
          style: Theme.of(context).textTheme.headline6,
        ),
        brightness: Theme.of(context).brightness,
        bottom: TabBar(
          controller: _tabController,
          tabs: <Widget>[
            Tab(
              child: Text(
                S.of(context).notifications_group,
                style: Theme.of(context).textTheme.caption,
              ),
            ),
            Tab(
              child: Text(
                S.of(context).notifications_connection,
                style: Theme.of(context).textTheme.caption,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: FutureBuilder<NotificationResultsModel>(
            future: notificationService.getNotifications(
              const NotificationQuery(
                connectionRequests: true,
                groupJoinRequests: true,
                paginationPosition: 0,
              ),
            ),
            builder: (
              BuildContext context,
              AsyncSnapshot<NotificationResultsModel> snapshot,
            ) {
              if (snapshot.hasError) {
                return Container(
                  height: 500.0,
                  width: 500.0,
                  child: Center(
                    child: _EmptyResults(
                      name: S.of(context).common_try_again_later,
                    ),
                  ),
                );
              }
              if (snapshot.hasData) {
                return TabBarView(
                  controller: _tabController,
                  children: <Widget>[
                    _buildGroupBody(snapshot.data, context),
                    _buildConnectionBody(snapshot.data, context),
                  ],
                );
              }
              if (!snapshot.hasData && !snapshot.hasError) {
                return Center(
                  child: JuntoProgressIndicator(),
                );
              }
              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }
}

class _EmptyResults extends StatelessWidget {
  const _EmptyResults({Key key, this.name}) : super(key: key);
  final String name;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Image.asset(
          'assets/images/moonlight.png',
          height: 120,
          fit: BoxFit.scaleDown,
        ),
        const SizedBox(height: 4.0),
        Text(
          name,
          style: Theme.of(context).textTheme.headline6,
        ),
      ],
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    Key key,
    @required this.title,
    @required this.subtitle,
    @required this.onPrimaryAction,
    @required this.onSecondaryAction,
  }) : super(key: key);

  final String title;
  final String subtitle;
  final VoidCallback onPrimaryAction;
  final VoidCallback onSecondaryAction;

  @override
  Widget build(BuildContext context) {
    const TextStyle _style = TextStyle(color: Colors.white);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                child: Text(title),
              ),
              FlatButton(
                visualDensity: const VisualDensity(
                  vertical: -2.5,
                  horizontal: -3.0,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.0),
                ),
                onPressed: onPrimaryAction,
                color: Theme.of(context).accentColor,
                child: Text(
                  S.of(context).common_accept,
                  style: _style,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                child: Text(subtitle),
              ),
              FlatButton(
                visualDensity: const VisualDensity(
                  vertical: -2.5,
                  horizontal: -3,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.0),
                ),
                onPressed: onSecondaryAction,
                color: Colors.redAccent,
                child: Text(
                  S.of(context).common_reject,
                  style: _style,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
