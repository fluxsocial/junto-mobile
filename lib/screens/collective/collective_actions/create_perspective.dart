import 'package:flutter/material.dart';

import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/utils/junto_dialog.dart';
import 'package:junto_beta_mobile/utils/junto_exception.dart'
    show JuntoException;
import 'package:junto_beta_mobile/utils/junto_overlay.dart';
import 'package:provider/provider.dart';

class CreatePerspective extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CreatePerspectiveState();
  }
}

class CreatePerspectiveState extends State<CreatePerspective> {
  TextEditingController _nameController;
  TextEditingController _aboutController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _aboutController = TextEditingController();
  }

  Future<void> _createPerspective() async {
    final String name = _nameController.value.text;
    final String about = _aboutController.value.text;
    JuntoLoader.showLoader(context);
    try {
      await Provider.of<UserRepo>(context, listen: false).createPerspective(
        Perspective(
          name: name,
          members: <String>[],
          about: about,
        ),
      );
      JuntoLoader.hide();
      Navigator.pop(context);
    } on JuntoException catch (error, stacktrace) {
      print(error);
      print(stacktrace);
      JuntoLoader.hide();
      JuntoDialog.showJuntoDialog(
        context,
        error.message,
        <Widget>[
          FlatButton(
            onPressed: () {
              return Navigator.pop(context);
            },
            child: const Text('Ok'),
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(45),
        child: AppBar(
          automaticallyImplyLeading: false,
          iconTheme: IconThemeData(
            color: Theme.of(context).primaryColor,
          ),
          backgroundColor: Theme.of(context).backgroundColor,
          elevation: 0,
          titleSpacing: 0,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(
              height: .75,
              width: MediaQuery.of(context).size.width,
              color: Theme.of(context).dividerColor,
            ),
          ),
          title: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 45,
                    width: 45,
                    color: Colors.transparent,
                    alignment: Alignment.centerLeft,
                    child: Icon(CustomIcons.back, size: 20),
                  ),
                ),
                Text('New Perspective',
                    style: Theme.of(context).textTheme.title),
                GestureDetector(
                  onTap: () {
                    _createPerspective();
                  },
                  child: Container(
                    height: 45,
                    width: 45,
                    color: Colors.transparent,
                    alignment: Alignment.centerRight,
                    child: Text(
                      'create',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).primaryColor),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              children: <Widget>[
                const SizedBox(height: 10),
                _buildPerspectiveTextField(
                    name: 'Name Perspective', controller: _nameController),
                const SizedBox(height: 10),
                _buildPerspectiveTextField(
                    name: 'About', controller: _aboutController),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildPerspectiveTextField(
      {String name, TextEditingController controller}) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: TextField(
        controller: controller,
        buildCounter: (
          BuildContext context, {
          int currentLength,
          int maxLength,
          bool isFocused,
        }) =>
            null,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(0),
          border: InputBorder.none,
          hintText: name,
          hintStyle: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).primaryColorLight,
          ),
        ),
        cursorColor: Theme.of(context).primaryColorDark,
        cursorWidth: 2,
        maxLines: 1,
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).primaryColor,
        ),
        maxLength: 80,
        textInputAction: TextInputAction.done,
      ),
    );
  }
}
