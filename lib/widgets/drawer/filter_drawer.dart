import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FilterDrawer extends StatefulWidget {
  const FilterDrawer();

  @override
  _FilterDrawerState createState() => _FilterDrawerState();
}

class _FilterDrawerState extends State<FilterDrawer> {
  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top + 12.0;
    return SizedBox(
      width: MediaQuery.of(context).size.width * .93,
      child: Drawer(
        elevation: 0,
        child: Container(
            decoration: const BoxDecoration(
              color: Color(0xff333333),
            ),
            padding: EdgeInsets.only(top: statusBarHeight),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom:
                              BorderSide(color: Color(0xff555555), width: .75),
                        ),
                      ),
                      child: Text(
                        'FILTER',
                        style: TextStyle(
                            fontSize: 17,
                            color: Colors.white,
                            letterSpacing: 1.6),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: TextField(
                              buildCounter: (
                                BuildContext context, {
                                int currentLength,
                                int maxLength,
                                bool isFocused,
                              }) =>
                                  null,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(0.0),
                                hintText: 'search channels',
                                border: InputBorder.none,
                                hintStyle: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500,
                                    color: Theme.of(context).primaryColorLight),
                              ),
                              cursorColor: Theme.of(context).primaryColor,
                              cursorWidth: 1,
                              maxLines: 1,
                              style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                              maxLength: 80,
                              textInputAction: TextInputAction.done,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 25,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xff3F3F3F),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                            alignment: Alignment.center,
                            child: Text(
                              'RESET',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                  letterSpacing: 1.7),
                            )),
                      ],
                    ))
              ],
            )),
      ),
    );
  }
}
