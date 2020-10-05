import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/models/user_model.dart';
import 'package:junto_beta_mobile/widgets/dialogs/single_action_dialog.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:junto_beta_mobile/widgets/avatars/member_avatar_placeholder.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'junto_invite_appbar.dart';

class JuntoContacts extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return JuntoContactsState();
  }
}

class JuntoContactsState extends State<JuntoContacts> {
  TextEditingController searchController;
  List<Contact> _contacts = [];
  List<Contact> _filteredContacts = [];
  UserData _userProfile;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    getUserInformation();
    _getPermission();
    getContacts();
  }

  Future<void> getUserInformation() async {
    final UserData userProfile =
        await Provider.of<UserDataProvider>(context, listen: false).userProfile;
    setState(() {
      _userProfile = userProfile;
    });
  }

  Future<void> getContacts() async {
    // Retrieve contacts from agent's device
    Iterable<Contact> contacts = await ContactsService.getContacts();

    // Create a temp list
    final List<Contact> tempContactsAsList = [];

    // Ignore null contacts
    await contacts.forEach((Contact contact) {
      if (contact != null) {
        tempContactsAsList.add(contact);
      }
    });

    // Convert Iterable to List
    List<Contact> contactsAsList = tempContactsAsList.toList();
    // Sort list alphabetically
    contactsAsList.sort((a, b) => a.displayName.compareTo(b.displayName));

    setState(() {
      _contacts = contactsAsList;
      _filteredContacts = List.from(_contacts);
    });
  }

  //Check contacts permission
  Future<PermissionStatus> _getPermission() async {
    final PermissionStatus permission = await Permission.contacts.status;

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

  void filterSearchResults(String query) {
    List<Contact> searchList = [];
    searchList.addAll(_contacts);
    final String queryLowercase = query.toLowerCase();

    if (queryLowercase.isNotEmpty) {
      final List<Contact> filteredSearchList = [];

      searchList.forEach((Contact contact) {
        if (contact.displayName != null &&
            contact.displayName.toLowerCase().contains(queryLowercase)) {
          filteredSearchList.add(contact);
        }
      });

      setState(() {
        _filteredContacts.clear();
        _filteredContacts.addAll(filteredSearchList);
      });
    } else {
      setState(() {
        _filteredContacts.clear();
        _filteredContacts.addAll(_contacts);
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
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
          JuntoContactsSearch(
            searchController: searchController,
            filterSearchResults: filterSearchResults,
          ),
          if (_filteredContacts.isNotEmpty || _filteredContacts != null)
            JuntoContactsList(
              filteredContacts: _filteredContacts,
              userProfile: _userProfile,
            ),
        ],
      ),
    );
  }
}

class JuntoContactsList extends StatelessWidget {
  const JuntoContactsList({
    this.filteredContacts,
    this.userProfile,
  });

  final List<Contact> filteredContacts;
  final UserData userProfile;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: filteredContacts.length,
        itemBuilder: (BuildContext context, int index) {
          final Contact contact = filteredContacts.elementAt(index);
          String number;

          if (contact.phones.isNotEmpty && contact.phones != null) {
            number = contact.phones.first.value;
          } else {
            number = '';
          }

          if (contact.displayName != null && number.isNotEmpty) {
            return Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Theme.of(context).dividerColor,
                    width: .5,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      MemberAvatarPlaceholder(
                        diameter: 45,
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            contact.displayName,
                            style: TextStyle(
                              fontSize: 15,
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            number,
                            style: TextStyle(
                              fontSize: 13,
                              color: Theme.of(context).primaryColorLight,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(25),
                    onTap: () async {
                      String uri;
                      if (Platform.isIOS) {
                        uri = Uri.encodeFull(
                            "sms:${number}&body=Hey! I started using this more authentic and nonprofit social media platform called Junto. Here's an invite to their closed alpha - you can connect with me @${userProfile.user.username}. https://junto.typeform.com/to/k7BUVK8f");
                      } else if (Platform.isAndroid) {
                        uri = Uri.encodeFull(
                            "sms:${number}?body=Hey! I started using this more authentic and nonprofit social media platform called Junto. Here's an invite to their closed alpha - you can connect with me @${userProfile.user.username}. https://junto.typeform.com/to/k7BUVK8f");
                      }

                      if (await canLaunch(uri)) {
                        await launch(uri);
                      } else {
                        await SingleActionDialog(
                          context: context,
                          dialogText: 'Sorry, something is up. Try again.',
                        );
                      }
                      ;
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).dividerColor,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 5),
                      child: Text(
                        'Invite',
                        style: TextStyle(
                          fontSize: 13,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return SizedBox(height: 1);
          }
        },
      ),
    );
  }
}

class JuntoContactsSearch extends StatelessWidget {
  const JuntoContactsSearch({this.searchController, this.filterSearchResults});

  final TextEditingController searchController;
  final Function filterSearchResults;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      margin: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSurface,
        borderRadius: BorderRadius.circular(25),
      ),
      child: TextField(
        scrollPadding: const EdgeInsets.all(0),
        controller: searchController,
        onChanged: (String value) {
          filterSearchResults(value);
        },
        buildCounter: (
          BuildContext context, {
          int currentLength,
          int maxLength,
          bool isFocused,
        }) =>
            null,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(0.0),
          hintText: 'Search contacts',
          border: InputBorder.none,
          hintStyle: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Theme.of(context).primaryColorLight,
          ),
        ),
        cursorColor: Theme.of(context).primaryColor,
        cursorWidth: 1,
        maxLines: 1,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: Theme.of(context).primaryColor,
        ),
        maxLength: 80,
        textInputAction: TextInputAction.search,
      ),
    );
  }
}
