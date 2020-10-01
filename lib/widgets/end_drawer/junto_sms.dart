import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/widgets/logos/junto_logo_outline.dart';
import 'package:junto_beta_mobile/widgets/dialogs/single_action_dialog.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';

import 'junto_invite_appbar.dart';
import 'junto_invite_cta.dart';
import 'junto_invite_dialog.dart';

class JuntoSms extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return JuntoSmsState();
  }
}

class JuntoSmsState extends State<JuntoSms> {
  Iterable<Contact> _contacts = [];

  @override
  void initState() {
    super.initState();
    _getPermission();
    getContacts();
  }

  getContacts() async {
    print('printing contacts');
    Iterable<Contact> contacts = await ContactsService.getContacts();
    setState(() {
      _contacts = contacts;
    });
  }

  //Check contacts permission
  Future<PermissionStatus> _getPermission() async {
    print('getting permission');
    final PermissionStatus permission = await Permission.contacts.status;
    print('can continue');
    print(permission);
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.denied) {
      final Map<Permission, PermissionStatus> permissionStatus =
          await [Permission.contacts].request();
      print(permissionStatus);
      return permissionStatus[Permission.contacts] ??
          PermissionStatus.undetermined;
    } else {
      return permission;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(45),
        child: JuntoInviteAppBar(),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _contacts.length,
              itemBuilder: (BuildContext context, int index) {
                final Contact contact = _contacts.elementAt(index);
                return Container(
                  child: Row(
                    children: [
                      Text(contact.displayName),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
