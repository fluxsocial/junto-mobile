import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/backend/repositories.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/utils/junto_dialog.dart';
import 'package:junto_beta_mobile/utils/junto_exception.dart';
import 'package:junto_beta_mobile/utils/junto_overlay.dart';
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

  void _onTileTap(BuildContext context, UserProfile _connection) {
    JuntoDialog.showJuntoDialog(
        context,
        'Accept or Reject',
        <Widget>[
          FlatButton(
            onPressed: () => _acceptConnection(context, _connection),
            child: const Text('Accept'),
          ),
          FlatButton(
            onPressed: () => _rejectConnection(context, _connection),
            child: const Text('Reject'),
          ),
        ],
        true);
  }

  Future<void> _acceptConnection(
    BuildContext context,
    UserProfile _connection,
  ) async {
    try {
      await Provider.of<UserRepo>(context).respondToConnection(
        userAddress,
        true,
      );
      Navigator.pop(context);
    } on JuntoException catch (error) {
      print('Error accepting connection ${error.message}');
    }
  }

  Future<void> _rejectConnection(
    BuildContext context,
    UserProfile _connection,
  ) async {
    try {
      JuntoLoader.showLoader(context);
      await Provider.of<UserRepo>(context).respondToConnection(
        userAddress,
        false,
      );
      JuntoLoader.hide();
      Navigator.pop(context);
    } on JuntoException catch (error) {
      JuntoLoader.hide();
      Navigator.pop(context);
      print('Error rejecting connection ${error.message}');
    }
  }

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
                    onTap: () => _onTileTap(context, data),
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
