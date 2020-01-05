import 'package:flutter/material.dart';

//TODO(Nash): Move to models folder.
class AboutPageModel {
  AboutPageModel({
    @required this.bio,
    @required this.location,
    @required this.gender,
    @required this.website,
  })  : assert(bio.isNotEmpty),
        assert(location.isNotEmpty),
        assert(gender.isNotEmpty),
        assert(website.isNotEmpty);

  final String bio;
  final String location;
  final String gender;
  final String website;
}

class SignUpAbout extends StatefulWidget {
  const SignUpAbout({Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return SignUpAboutState();
  }
}

class SignUpAboutState extends State<SignUpAbout> {
  TextEditingController bioController;
  TextEditingController locationController;
  TextEditingController genderController;
  TextEditingController websiteController;

  @override
  void initState() {
    super.initState();
    bioController = TextEditingController();
    locationController = TextEditingController();
    genderController = TextEditingController();
    websiteController = TextEditingController();
  }

  @override
  void dispose() {
    bioController.dispose();
    locationController.dispose();
    genderController.dispose();
    websiteController.dispose();
    super.dispose();
  }

  AboutPageModel returnDetails() {
    return AboutPageModel(
        bio: bioController.value.text,
        location: locationController.value.text,
        gender: genderController.value.text,
        website: websiteController.value.text);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      width: MediaQuery.of(context).size.width,
      child: Container(
        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * .16),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: const Text(
                'Feel free to share more about yourself! (optional)',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w700),
              ),
            ),
            Expanded(
              child: ListView(
                children: <Widget>[
                  Container(
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: TextField(
                            controller: bioController,
                            textInputAction: TextInputAction.newline,
                            maxLines: null,
                            cursorColor: Colors.white70,
                            decoration: const InputDecoration(
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              hintText: 'Short or long bio',
                              hintStyle: TextStyle(
                                color: Colors.white70,
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                              fillColor: Colors.white,
                            ),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            const Text(
                              'ABOUT',
                              style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w400),
                            ),
                            Text(
                              bioController.value.text.length.toString() +
                                  '/1000',
                              style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 50),
                  Container(
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: TextField(
                            controller: locationController,
                            cursorColor: Colors.white70,
                            decoration: const InputDecoration(
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              hintText: 'Location',
                              hintStyle: TextStyle(
                                color: Colors.white70,
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                              fillColor: Colors.white,
                            ),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 50),
                  Container(
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: TextField(
                            controller: genderController,
                            cursorColor: Colors.white70,
                            decoration: const InputDecoration(
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              hintText: 'Gender',
                              hintStyle: TextStyle(
                                color: Colors.white70,
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                              fillColor: Colors.white,
                            ),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 50),
                  Container(
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: TextField(
                            controller: websiteController,
                            cursorColor: Colors.white70,
                            decoration: const InputDecoration(
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              hintText: 'Website',
                              hintStyle: TextStyle(
                                color: Colors.white70,
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                              fillColor: Colors.white,
                            ),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
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
