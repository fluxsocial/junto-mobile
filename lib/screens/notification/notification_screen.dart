import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/backend/repositories.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/widgets/progress_indicator.dart';
import 'package:provider/provider.dart';

class NotificationScreen extends StatefulWidget {
  static Route<dynamic> route() {
    return MaterialPageRoute<dynamic>(
        builder: (BuildContext context) => NotificationScreen());
  }

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  NotificationRepo notificationService;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    notificationService = Provider.of<NotificationRepo>(context);
  }

  Widget _buildListBody(final NotificationResultsModel data) {
    return ListView(
      children: <Widget>[
        const SizedBox(
          height: 20.0,
        ),
        Text(
          'Group Notifications',
          style: Theme.of(context).textTheme.headline4,
        ),
        if (data.groupJoinNotifications.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 24.0),
            child: _EmptyResults(
              name: 'No new group notifications',
            ),
          ),
        const SizedBox(
          height: 80.0,
        ),
        if (data.groupJoinNotifications.isNotEmpty)
          for (Group item in data.groupJoinNotifications)
            ListTile(
              title: Text(item.groupData.name),
              subtitle: Text(item.incomingCreator.name),
            ),
        Text(
          'Connection Notifications',
          style: Theme.of(context).textTheme.headline4,
        ),
        if (data.connectionNotifications.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 24.0),
            child: _EmptyResults(
              name: 'No new connection notifications',
            ),
          ),
        if (data.connectionNotifications.isNotEmpty)
          for (UserProfile item in data.connectionNotifications)
            ListTile(
              title: Text(item.name),
              subtitle: Text(item.username),
            ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notifications',
          style: Theme.of(context).textTheme.caption,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: FutureBuilder<NotificationResultsModel>(
            future: notificationService.getNotifications(),
            builder: (
              BuildContext context,
              AsyncSnapshot<NotificationResultsModel> snapshot,
            ) {
              if (snapshot.hasError) {
                return Container(
                  height: 500.0,
                  width: 500.0,
                  child: const Center(
                    child: _EmptyResults(
                      name: 'Try again later',
                    ),
                  ),
                );
              }
              if (snapshot.hasData) {
                print(snapshot.data);
                return _buildListBody(snapshot.data);
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
