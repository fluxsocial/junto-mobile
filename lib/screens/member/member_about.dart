import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';

class JuntoMemberAbout extends StatelessWidget {
  const JuntoMemberAbout(
      {@required this.gender,
      @required this.location,
      @required this.website,
      @required this.bio});

  final List<String> gender;
  final List<String> location;
  final List<String> website;
  final String bio;

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const ClampingScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.only(left: 10),
      children: <Widget>[
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.only(top: 5, bottom: 5),
          child: Column(
            children: <Widget>[
              if (gender.isNotEmpty && gender[0].isNotEmpty)
                _ProfileDetails(
                  iconData: CustomIcons.gender,
                  item: gender,
                ),
              if (location.isNotEmpty && location[0].isNotEmpty)
                _ProfileDetails(
                  imageUri: 'assets/images/junto-mobile__location.png',
                  item: location,
                ),
              if (website.isNotEmpty && website[0].isNotEmpty)
                _ProfileDetails(
                  imageUri: 'assets/images/junto-mobile__link.png',
                  item: website,
                )
            ],
          ),
        ),
        Container(
          child: Text(bio, style: Theme.of(context).textTheme.caption),
        ),
      ],
    );
  }
}

// Used to display the user's location, gender and website. Image and Icon data
/// cannot be supplied at the same time.
class _ProfileDetails extends StatelessWidget {
  const _ProfileDetails({
    Key key,
    @required this.item,
    this.iconData,
    this.imageUri,
  }) : super(key: key);

  final List<String> item;
  final IconData iconData;
  final String imageUri;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: <Widget>[
          if (imageUri != null)
            Image.asset(
              imageUri,
              height: 15,
              color: Theme.of(context).primaryColor,
            ),
          if (iconData != null)
            Icon(CustomIcons.gender,
                size: 17, color: Theme.of(context).primaryColor),
          const SizedBox(width: 5),
          Text(
            item[0],
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 15,
                fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
