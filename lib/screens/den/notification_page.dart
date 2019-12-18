import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/backend/repositories.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:provider/provider.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({
    Key key,
    @required this.userAddress,
  }) : super(key: key);

  static Route<dynamic> route(String userAddress) {
    return MaterialPageRoute<dynamic>(
      builder: (BuildContext context) =>
          NotificationPage(userAddress: userAddress),
    );
  }

  final String userAddress;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Pending Connections',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: FutureBuilder<List<UserProfile>>(
          future:
              Provider.of<UserRepo>(context).pendingConnections(userAddress),
          builder: (BuildContext context,
              AsyncSnapshot<List<UserProfile>> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  final UserProfile data = snapshot.data[index];
                  return ListTile(
                    title: Text(data.name),
                    subtitle: Text('Address: ${data.address}'),
                  );
                },
              );
            }
            return Container(
              child: const Center(
                child: Text('No Data!'),
              ),
            );
          },
        ),
      ),
    );
  }
}
