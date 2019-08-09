
import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';
import '../../../scoped_models/scoped_user.dart';

import './perspective_preview.dart';

class Perspectives extends StatelessWidget {
  Function _changePerspective;
  Perspectives(this._changePerspective);

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return 
        SizedBox(
          width: MediaQuery.of(context).size.width * .9,
          child: Drawer(
            elevation: 0,
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: <Widget>[
                    Container(
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: Color(0xffeeeeee), width: 1))),
                        alignment: Alignment.centerLeft,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('PERSPECTIVES',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xff333333))),
                              Icon(Icons.add_circle_outline, size: 14)
                            ]),
                        height: 45,
                        margin: EdgeInsets.only(top: statusBarHeight)),
                    Expanded(
                        child: ListView(padding: EdgeInsets.all(0), children: [
                    Container(
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 0),
                        onTap: () {
                          _changePerspective('JUNTO');

                          Navigator.pop(context);
                        },
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [Text('JUNTO')]),
                      ),
                    ),

                    Container(
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 0),
                        onTap: () {
                          _changePerspective('Degrees of Separation');

                          Navigator.pop(context);
                        },
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [Text('Degrees of Separation')]),
                      ),
                    ),                             
 
                    Container(
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 0),
                        onTap: () {
                          _changePerspective('Following');

                          Navigator.pop(context);
                        },
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [Text('Following')]),
                      ),
                    ),
           

                      ScopedModelDescendant<ScopedUser>(
                        builder: (context, child, model) => ListView(
                              padding: EdgeInsets.all(0),
                              shrinkWrap: true,
                              physics: ClampingScrollPhysics(),
                              children: model.perspectives
                                  .map((perspective) => PerspectivePreview(
                                      perspective.perspectiveTitle, _changePerspective))
                                  .toList(),
                            ),
                      ),
                    ]))
                  ],
                )),
          ),
        );    
  }
}