import 'dart:io';

import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';

///Simple UI for displaying a placeholder image.
class EmptyImageWidget extends StatelessWidget {
  const EmptyImageWidget(
      {Key key, @required this.imageFile, @required this.pickImage})
      : super(key: key);
  final ValueNotifier<File> imageFile;
  final VoidCallback pickImage;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: pickImage,
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width,
        height: (MediaQuery.of(context).size.width / 3) * 2,
        color: Theme.of(context).dividerColor,
        child: Icon(
          CustomIcons.camera,
          size: 38,
          color: Theme.of(context).primaryColorLight,
        ),
      ),
    );
  }
}

///Simple UI for changing the selected [imageFile]
class ChangeImage extends StatelessWidget {
  const ChangeImage({
    Key key,
    @required this.pickImage,
    @required this.imageFile,
  }) : super(key: key);
  final VoidCallback pickImage;
  final ValueNotifier<File> imageFile;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .4,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: 5,
                    width: MediaQuery.of(context).size.width * .1,
                    decoration: BoxDecoration(
                      color: const Color(0xffeeeeee),
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  pickImage();
                },
                contentPadding: const EdgeInsets.all(0),
                title: Row(
                  children: <Widget>[
                    Text(
                      'Upload new photo',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ],
                ),
              ),
              ListTile(
                contentPadding: const EdgeInsets.all(0),
                onTap: () {
                  imageFile.value = null;

                  Navigator.pop(context);
                },
                title: Row(
                  children: <Widget>[
                    Text(
                      'Remove photo',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
