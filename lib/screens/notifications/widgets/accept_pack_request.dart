import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/backend/repositories.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:provider/provider.dart';

class AcceptPackRequest extends StatefulWidget {
  const AcceptPackRequest({this.userAddress, this.packAddress});

  final String userAddress;
  final String packAddress;

  @override
  State<StatefulWidget> createState() {
    return AcceptPackRequestState();
  }
}

class AcceptPackRequestState extends State<AcceptPackRequest> {
  bool isPackMember = false;
  @override
  void initState() {
    super.initState();
    checkUserRelation();
  }

  Future<bool> checkUserRelation() async {
    String address =
        await Provider.of<UserDataProvider>(context, listen: false).userAddress;
    final Map<String, dynamic> isRelated =
        await Provider.of<UserRepo>(context, listen: false)
            .isRelated(address, widget.userAddress);

    setState(() {
      isPackMember = isRelated['is_pack_member'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        print('yeo');
        await Provider.of<GroupRepo>(context, listen: false)
            .respondToGroupRequest(widget.packAddress, true);

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
          isPackMember ? 'In Pack' : 'Accept',
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
