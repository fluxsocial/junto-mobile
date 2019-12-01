import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/app/palette.dart';
import 'package:junto_beta_mobile/screens/collective/perspectives/edit_perspective/edit_perspective_members.dart';

class EditPerspective extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(45),
        child: AppBar(
          automaticallyImplyLeading: false,
          brightness: Brightness.light,
          iconTheme: const IconThemeData(color: JuntoPalette.juntoSleek),
          elevation: 0,
          titleSpacing: 0,
          title: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.only(left: 10),
                    width: 42,
                    height: 42,
                    alignment: Alignment.centerLeft,
                    color: Colors.transparent,
                    child: Icon(
                      CustomIcons.back,
                      color: Theme.of(context).primaryColorDark,
                      size: 17,
                    ),
                  ),
                ),
                Text('Edit Perspective',
                    style: Theme.of(context).textTheme.subhead),
                Container(
                  padding: const EdgeInsets.only(right: 10),
                  alignment: Alignment.centerRight,
                  color: Colors.transparent,
                  width: 42,
                  height: 42,
                  child: Text('Save', style: Theme.of(context).textTheme.body2),
                )
              ],
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(.75),
            child: Container(
              height: .75,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                      color: Theme.of(context).dividerColor, width: .75),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              children: <Widget>[
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                          color: Theme.of(context).dividerColor, width: .75),
                    ),
                  ),
                  child: TextFormField(
                    initialValue: 'name',
                    decoration: const InputDecoration(
                        border: InputBorder.none, hintText: 'name'),
                    maxLines: null,
                    style: Theme.of(context).textTheme.body2,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (BuildContext context) =>
                              EditPerspectiveMembers()),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border(
                        bottom: BorderSide(
                            color: Theme.of(context).dividerColor, width: .75),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('Manage members',
                            style: Theme.of(context).textTheme.body2),
                        Icon(Icons.keyboard_arrow_right,
                            size: 17,
                            color: Theme.of(context).primaryColorLight)
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // delete perspective
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border(
                        bottom: BorderSide(
                            color: Theme.of(context).dividerColor, width: .75),
                      ),
                    ),
                    child: Text('Delete perspective',
                        style: Theme.of(context).textTheme.body2),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
