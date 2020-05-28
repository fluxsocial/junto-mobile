import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AudioPhotoOptions extends StatelessWidget {
  const AudioPhotoOptions({this.updatePhoto, this.resetPhoto, this.source});

  final Function updatePhoto;
  final Function resetPhoto;
  final String source;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .36,
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: 5,
                      width: MediaQuery.of(context).size.width * .1,
                      decoration: BoxDecoration(
                        color: Theme.of(context).dividerColor,
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ListTile(
                  contentPadding: const EdgeInsets.all(0),
                  onTap: () async {
                    Navigator.pop(context);
                    updatePhoto(source: 'Gallery');
                  },
                  title: Row(
                    children: <Widget>[
                      Icon(
                        Icons.photo_library,
                        color: Theme.of(context).primaryColor,
                        size: 17,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Library',
                        style: Theme.of(context).textTheme.headline5.copyWith(
                              color: Theme.of(context).primaryColor,
                            ),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  contentPadding: const EdgeInsets.all(0),
                  onTap: () async {
                    Navigator.pop(context);
                    updatePhoto(source: 'Camera');
                  },
                  title: Row(
                    children: <Widget>[
                      Icon(
                        Icons.camera_alt,
                        color: Theme.of(context).primaryColor,
                        size: 17,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Camera',
                        style: Theme.of(context).textTheme.headline5.copyWith(
                              color: Theme.of(context).primaryColor,
                            ),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  contentPadding: const EdgeInsets.all(0),
                  onTap: () async {
                    Navigator.pop(context);
                    resetPhoto();
                  },
                  title: Row(
                    children: <Widget>[
                      Icon(
                        Icons.delete,
                        color: Theme.of(context).primaryColor,
                        size: 17,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Remove Photo',
                        style: Theme.of(context).textTheme.headline5.copyWith(
                              color: Theme.of(context).primaryColor,
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
    );
  }
}
