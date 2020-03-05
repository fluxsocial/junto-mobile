import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/user_model.dart';

class MemberPreviewSelect extends StatefulWidget {
  const MemberPreviewSelect(
      {Key key, this.profile, this.onSelect, this.onDeselect})
      : super(key: key);

  final UserProfile profile;
  final ValueChanged<UserProfile> onSelect;
  final ValueChanged<UserProfile> onDeselect;
  @override
  State<StatefulWidget> createState() {
    return MemberPreviewSelectState();
  }
}

class MemberPreviewSelectState extends State<MemberPreviewSelect> {
  bool _isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.background,
      child: Row(
        children: <Widget>[
          widget.profile.profilePicture.isNotEmpty
              ? ClipOval(
                  child: CachedNetworkImage(
                      imageUrl: widget.profile.profilePicture[0],
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
                                Theme.of(context).colorScheme.primary,
                                Theme.of(context).colorScheme.secondary,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Image.asset(
                              'assets/images/junto-mobile__logo--white.png',
                              height: 15),
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
                        Theme.of(context).colorScheme.primary,
                        Theme.of(context).colorScheme.secondary,
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
                      Text(widget.profile.username,
                          textAlign: TextAlign.start,
                          style: Theme.of(context).textTheme.subtitle1),
                      Text(widget.profile.name,
                          textAlign: TextAlign.start,
                          style: Theme.of(context).textTheme.bodyText1)
                    ],
                  ),
                  _isSelected
                      ? GestureDetector(
                          onTap: () {
                            setState(() {
                              _isSelected = false;
                            });
                            widget.onDeselect(widget.profile);
                          },
                          child: Container(
                            height: 28,
                            width: 28,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                stops: const <double>[0.1, 0.9],
                                colors: <Color>[
                                  Theme.of(context)
                                      .colorScheme
                                      .secondaryVariant,
                                  Theme.of(context).colorScheme.primaryVariant,
                                ],
                              ),
                              border: Border.all(
                                  color: Theme.of(context).backgroundColor,
                                  width: 1),
                            ),
                            alignment: Alignment.center,
                            child: Icon(Icons.check,
                                color: Colors.white, size: 17),
                          ),
                        )
                      : GestureDetector(
                          onTap: () {
                            setState(() {
                              _isSelected = true;
                            });

                            widget.onSelect(widget.profile);
                          },
                          child: Container(
                            height: 28,
                            width: 28,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(
                                  color: Theme.of(context).primaryColor,
                                  width: 1),
                            ),
                            alignment: Alignment.center,
                            child: Icon(Icons.add,
                                color: Theme.of(context).primaryColor,
                                size: 17),
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
