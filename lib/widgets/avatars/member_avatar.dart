import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MemberAvatar extends StatelessWidget {
  const MemberAvatar({this.profilePicture, this.diameter});

  final List<String> profilePicture;
  final double diameter;

  @override
  Widget build(BuildContext context) {
    return profilePicture.isNotEmpty
        ? Container(
            margin: const EdgeInsets.only(right: 5),
            child: ClipOval(
              child: CachedNetworkImage(
                imageUrl: profilePicture[0],
                height: diameter,
                width: diameter,
                fit: BoxFit.cover,
                placeholder: (BuildContext context, String _) {
                  return Container(
                    alignment: Alignment.center,
                    height: diameter,
                    width: diameter,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                        stops: const <double>[0.3, 0.9],
                        colors: <Color>[
                          Theme.of(context).colorScheme.primary,
                          Theme.of(context).colorScheme.secondary,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Image.asset(
                      'assets/images/junto-mobile__logo--white.png',
                      height: 17,
                    ),
                  );
                },
              ),
            ),
          )
        : Container(
            alignment: Alignment.center,
            height: diameter,
            width: diameter,
            margin: const EdgeInsets.only(right: 5),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                stops: const <double>[0.3, 0.9],
                colors: <Color>[
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.secondary,
                ],
              ),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Image.asset(
              'assets/images/junto-mobile__logo--white.png',
              height: 12,
            ),
          );
  }
}
