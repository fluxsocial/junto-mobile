import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/custom_icons.dart';
import 'package:junto_beta_mobile/palette.dart';

class DenEditProfile extends StatelessWidget {
  String name = 'Eric Yang';
  String bio = '"To a mind that is still, the whole universe surrenders"';
  String location = 'Spirit';
  String website = 'junto.foundation';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(45),
        child: AppBar(
          automaticallyImplyLeading: false,
          brightness: Brightness.light,
          iconTheme: const IconThemeData(color: JuntoPalette.juntoSleek),
          backgroundColor: Colors.white,
          elevation: 0,
          titleSpacing: 0,
          title: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                    CustomIcons.back_arrow_left,
                    color: JuntoPalette.juntoSleek,
                    size: 24,
                  ),
                ),
                const Text(
                  'Edit Profile',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff333333),
                  ),
                ),
                const Text(
                  'Save',
                  style: TextStyle(
                    color: Color(0xff333333),
                    fontSize: 14,
                  ),
                )
              ],
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(
              height: 1,
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Color(0xffeeeeee), width: 1),
                ),
              ),
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              children: <Widget>[
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Color(0xffeeeeee), width: .75),
                    ),
                  ),
                  child: Row(
                    children: <Widget>[
                      ClipOval(
                        child: Image.asset(
                          'assets/images/junto-mobile__eric.png',
                          height: 45.0,
                          width: 45.0,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Edit profile picture',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Color(0xffeeeeee), width: .75),
                    ),
                  ),
                  child: TextFormField(
                      initialValue: name,
                      decoration: InputDecoration(
                          border: InputBorder.none, hintText: 'name'),
                      maxLines: null,
                      style: const TextStyle(
                        fontSize: 14,
                      )),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Color(0xffeeeeee), width: .75),
                    ),
                  ),
                  child: TextFormField(
                      initialValue: bio,
                      decoration: InputDecoration(
                          border: InputBorder.none, hintText: 'bio'),
                      maxLines: null,
                      style: const TextStyle(
                        fontSize: 14,
                      )),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Color(0xffeeeeee), width: .75),
                    ),
                  ),
                  child: TextFormField(
                      initialValue: location,
                      decoration: InputDecoration(
                          border: InputBorder.none, hintText: 'location'),
                      maxLines: null,
                      style: const TextStyle(
                        fontSize: 14,
                      )),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Color(0xffeeeeee), width: .75),
                    ),
                  ),
                  child: TextFormField(
                    initialValue: website,
                    decoration: InputDecoration(
                        border: InputBorder.none, hintText: 'website'),
                    maxLines: null,
                    style: const TextStyle(fontSize: 14),
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
