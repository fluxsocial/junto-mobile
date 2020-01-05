import 'package:meta/meta.dart';

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
