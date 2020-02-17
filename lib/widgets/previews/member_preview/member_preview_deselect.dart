import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/user_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';

class MemberPreviewDeselect extends StatelessWidget {
  const MemberPreviewDeselect({Key key, this.profile, this.onDeselect})
      : super(key: key);

  final UserProfile profile;
  final dynamic onDeselect;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.background,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: <Widget>[
          profile.profilePicture.isNotEmpty
              ? ClipOval(
                  child: CachedNetworkImage(
                      imageUrl: profile.profilePicture[0],
                      height: 45,
                      width: 45,
                      fit: BoxFit.cover,
                      placeholder: (BuildContext context, String _) {
                        return Container(
                          alignment: Alignment.center,
                          height: 45.0,
                          width: 45.0,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomLeft,
                              end: Alignment.topRight,
                              stops: const <double>[0.3, 0.9],
                              colors: <Color>[
                                Theme.of(context).colorScheme.secondary,
                                Theme.of(context).colorScheme.primary,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Icon(
                            CustomIcons.spheres,
                            color: Theme.of(context).colorScheme.onPrimary,
                            size: 17,
                          ),
                        );
                      }),
                )
              : Container(
                  alignment: Alignment.center,
                  height: 45.0,
                  width: 45.0,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      stops: const <double>[0.3, 0.9],
                      colors: <Color>[
                        Theme.of(context).colorScheme.secondary,
                        Theme.of(context).colorScheme.primary
                      ],
                    ),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Image.asset(
                      'assets/images/junto-mobile__logo--white.png',
                      height: 15),
                ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 15,
              ),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    width: .5,
                    color: Theme.of(context).dividerColor,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(profile.username,
                          textAlign: TextAlign.start,
                          style: Theme.of(context).textTheme.subtitle1),
                      Text(profile.name,
                          textAlign: TextAlign.start,
                          style: Theme.of(context).textTheme.bodyText1)
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      onDeselect();
                    },
                    child: Container(
                      height: 28,
                      width: 28,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(
                            color: Theme.of(context).primaryColor, width: 1),
                      ),
                      alignment: Alignment.center,
                      child: Icon(CustomIcons.cancel,
                          color: Theme.of(context).primaryColor, size: 17),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
