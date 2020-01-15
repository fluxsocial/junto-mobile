import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/app/palette.dart';
import 'package:junto_beta_mobile/backend/repositories.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/models/user_model.dart';
import 'package:provider/provider.dart';

class JuntoEditDen extends StatefulWidget {
  const JuntoEditDen({
    Key key,
    @required this.userProfile,
  }) : super(key: key);

  final UserData userProfile;

  @override
  _JuntoEditDenState createState() => _JuntoEditDenState();
}

class _JuntoEditDenState extends State<JuntoEditDen> {
  final GlobalKey<FormFieldState<dynamic>> _formKey =
      GlobalKey<FormFieldState<dynamic>>();

  String name;

  String bio;

  String location;

  String website;

  @override
  void initState() {
    super.initState();
    name = widget.userProfile.user.name;
    bio = widget.userProfile.user.bio;
    location = widget.userProfile.user.location.first;
    website = widget.userProfile.user.website.first;
  }

  Future<void> _updateUserProfile() async {
    final UserProfile newProfile = UserProfile(
      address: widget.userProfile.user.address,
      name: name,
      gender: widget.userProfile.user.gender,
      location: <String>[location],
      username: widget.userProfile.user.username,
      verified: widget.userProfile.user.verified,
      bio: bio,
      profilePicture: widget.userProfile.user.profilePicture,
      website: <String>[website],
    );
    try {
      Provider.of<UserRepo>(context).updateUser(newProfile);
    } catch (error) {
      print(error);
    }
  }

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
                Container(
                  child: Text('Edit Profile',
                      style: Theme.of(context).textTheme.subhead),
                ),
                GestureDetector(
                  onTap: _updateUserProfile,
                  child: Container(
                    padding: const EdgeInsets.only(right: 10),
                    alignment: Alignment.centerRight,
                    color: Colors.transparent,
                    width: 42,
                    height: 42,
                    child:
                        Text('Save', style: Theme.of(context).textTheme.body2),
                  ),
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
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 10),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                            color: Theme.of(context).dividerColor, width: .75),
                      ),
                    ),
                    child: Row(
                      children: <Widget>[
                        ClipOval(
                          child: Image.asset(
                            'assets/images/junto-mobile__mockprofpic--one.png',
                            height: 45.0,
                            width: 45.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text('Edit profile picture',
                            style: Theme.of(context).textTheme.body2)
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                            color: Theme.of(context).dividerColor, width: .75),
                      ),
                    ),
                    child: TextFormField(
                      initialValue: name,
                      decoration: const InputDecoration(
                          border: InputBorder.none, hintText: 'name'),
                      maxLines: null,
                      style: Theme.of(context).textTheme.body2,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                            color: Theme.of(context).dividerColor, width: .75),
                      ),
                    ),
                    child: TextFormField(
                        initialValue: bio,
                        decoration: const InputDecoration(
                            border: InputBorder.none, hintText: 'bio'),
                        maxLines: null,
                        style: Theme.of(context).textTheme.body2),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                            color: Theme.of(context).dividerColor, width: .75),
                      ),
                    ),
                    child: TextFormField(
                        initialValue: location,
                        decoration: const InputDecoration(
                            border: InputBorder.none, hintText: 'location'),
                        maxLines: null,
                        style: Theme.of(context).textTheme.body2),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                            color: Theme.of(context).dividerColor, width: .75),
                      ),
                    ),
                    child: TextFormField(
                      initialValue: website,
                      decoration: const InputDecoration(
                          border: InputBorder.none, hintText: 'website'),
                      maxLines: null,
                      style: Theme.of(context).textTheme.body2,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
