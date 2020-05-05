import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/backend/repositories.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:provider/provider.dart';

class AcceptConnectionRequest extends StatefulWidget {
  const AcceptConnectionRequest({this.userAddress});

  final String userAddress;

  @override
  State<StatefulWidget> createState() {
    return AcceptConnectionRequestState();
  }
}

class AcceptConnectionRequestState extends State<AcceptConnectionRequest> {
  bool isConnected = false;
  @override
  void initState() {
    super.initState();
    checkUserRelation();
  }

  Future<bool> checkUserRelation() async {
    String address =
        await Provider.of<UserDataProvider>(context, listen: false).userAddress;
    final bool isConnectedToUser =
        await Provider.of<UserRepo>(context, listen: false)
            .isConnected(address, widget.userAddress);

    setState(() {
      isConnected = isConnectedToUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await Provider.of<UserRepo>(context, listen: false)
            .respondToConnection(widget.userAddress, true);
        checkUserRelation();
      },
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryVariant,
          // border: Border.all(
          //   color: Theme.of(context).primaryColor,
          //   width: 1,
          // ),
          borderRadius: BorderRadius.circular(5),
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 5,
          horizontal: 10,
        ),
        child: Text(
          isConnected ? 'Connected' : 'Connect',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            // color: Theme.of(context).primaryColor,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
