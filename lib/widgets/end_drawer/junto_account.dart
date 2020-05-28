import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/widgets/dialogs/delete_account_dialog.dart';

import 'junto_account_appbar.dart';

class JuntoAccount extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(45),
        child: JuntoAccountAppBar(),
      ),
      body: Consumer<UserDataProvider>(
          builder: (BuildContext context, UserDataProvider user, Widget child) {
        return SafeArea(
          child: Column(
            children: <Widget>[
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(0),
                  children: <Widget>[
                    JuntoAccountDetail(
                      title: 'Name',
                      user: user,
                    ),
                    JuntoAccountDetail(
                      title: 'Username',
                      user: user,
                    ),
                    JuntoAccountDetail(
                      title: 'Email',
                      user: user,
                    ),
                  ],
                ),
              ),
              JuntoDeleteAccount(user: user),
            ],
          ),
        );
      }),
    );
  }
}

class JuntoAccountDetail extends StatelessWidget {
  const JuntoAccountDetail({this.title, this.user});

  final String title;
  final UserDataProvider user;

  String _buildItem() {
    switch (title) {
      case 'Email':
        return user.userProfile.user.email;
        break;
      case 'Name':
        return user.userProfile.user.name;
        break;
      case 'Username':
        return user.userProfile.user.username;
        break;
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
            width: .75,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            child: Text(
              title,
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          if (user.userProfile.user.email != null)
            Flexible(
              child: Text(
                _buildItem(),
                style: Theme.of(context).textTheme.subtitle1.copyWith(
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).primaryColor,
                    ),
              ),
            ),
        ],
      ),
    );
  }
}

class JuntoDeleteAccount extends StatelessWidget {
  const JuntoDeleteAccount({this.user});

  final UserDataProvider user;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await showDialog(
          context: context,
          builder: (BuildContext context) => DeleteAccountDialog(
            buildContext: context,
            user: user,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        margin: const EdgeInsets.only(bottom: 25),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border(
            bottom: BorderSide(
              color: Theme.of(context).dividerColor,
              width: .75,
            ),
            top: BorderSide(
              color: Theme.of(context).dividerColor,
              width: .75,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Flexible(
              child: Text(
                'Delete Account',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.red,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
