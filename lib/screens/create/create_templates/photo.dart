import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/app/expressions.dart';
import 'package:junto_beta_mobile/app/logger/logger.dart';
import 'package:junto_beta_mobile/backend/repositories/expression_repo.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/create/create_actions/create_actions.dart';
import 'package:junto_beta_mobile/screens/create/create_actions/widgets/create_expression_scaffold.dart';
import 'package:junto_beta_mobile/widgets/dialogs/single_action_dialog.dart';
import 'package:junto_beta_mobile/widgets/image_cropper.dart';

/// Create using photo form
class CreatePhoto extends StatefulWidget {
  const CreatePhoto({Key key, this.address, this.expressionContext})
      : super(key: key);

  final ExpressionContext expressionContext;
  final String address;

  @override
  State<StatefulWidget> createState() {
    return CreatePhotoState();
  }
}

// State for CreatePhoto class
class CreatePhotoState extends State<CreatePhoto> {
  File preCroppedFile;
  File imageFile;
  ImageSource imageSource;
  TextEditingController _captionController;
  bool _showBottomNav = true;

  Future<void> _onPickPressed({@required ImageSource source}) async {
    try {
      final imagePicker = ImagePicker();
      File image;
      if (source == ImageSource.gallery) {
        final pickedImage = await imagePicker.getImage(
          source: ImageSource.gallery,
          imageQuality: 70,
        );
        image = File(pickedImage.path);

        setState(() {
          imageSource = ImageSource.gallery;
        });
      } else if (source == ImageSource.camera) {
        final pickedImage = await imagePicker.getImage(
          source: ImageSource.camera,
          imageQuality: 70,
        );
        image = File(pickedImage.path);

        setState(() {
          imageSource = ImageSource.camera;
        });
      }

      if (image == null) {
        setState(() {
          imageFile = null;
        });
        return;
      } else {
        setState(() {
          preCroppedFile = image;
        });
      }

      final File cropped = await ImageCroppingDialog.show(
        context,
        image,
        aspectRatios: <String>[
          '1:1',
          '2:3',
          '3:2',
          '3:4',
          '4:3',
          '4:5',
          '5:4',
          '9:16',
          '16:9'
        ],
      );
      if (cropped == null) {
        setState(() {
          imageFile = null;
        });
        _onPickPressed(source: imageSource);
        return;
      }
      setState(() {
        imageFile = cropped;
      });
      _toggleBottomNav(false);
    } catch (e, s) {
      logger.logException(e, s);
    }
  }

  Future<void> _cropPhoto() async {
    final File image = preCroppedFile;
    final File cropped = await ImageCroppingDialog.show(context, image,
        aspectRatios: <String>[
          '1:1',
          '2:3',
          '3:2',
          '3:4',
          '4:3',
          '4:5',
          '5:4',
          '9:16',
          '16:9'
        ]);
    if (cropped == null) {
      return;
    }
    setState(() => imageFile = cropped);
    _toggleBottomNav(false);
  }

  /// Creates a [PhotoFormExpression] from the given data entered
  /// by the user.
  Map<String, dynamic> createExpression() {
    return <String, dynamic>{
      'image': imageFile,
      'caption': _captionController.value.text.trim()
    };
  }

  bool _validate() {
    if (imageFile != null) {
      return true;
    } else {
      return false;
    }
  }

  void _onNext() {
    if (_validate() == true) {
      final Map<String, dynamic> expression = createExpression();
      Navigator.push(
        context,
        MaterialPageRoute<dynamic>(
          builder: (BuildContext context) {
            return CreateActions(
              expressionType: ExpressionType.photo,
              address: widget.address,
              expressionContext: widget.expressionContext,
              expression: expression,
            );
          },
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) => const SingleActionDialog(
          dialogText: 'Please add a photo.',
        ),
      );
      return;
    }
  }

  void _toggleBottomNav(bool value) {
    setState(() {
      _showBottomNav = value;
    });
  }

  @override
  void initState() {
    super.initState();

    _captionController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();

    _captionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CreateExpressionScaffold(
      expressionType: ExpressionType.photo,
      onNext: _onNext,
      showBottomNav: _showBottomNav,
      child: Expanded(
        child: Column(
          children: <Widget>[
            Expanded(
              child: imageFile == null
                  ? Container(
                      color: Colors.transparent,
                      width: MediaQuery.of(context).size.width,
                      child: GestureDetector(
                        onTap: () {
                          _onPickPressed(source: ImageSource.gallery);
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              CustomIcons.add,
                              size: 75,
                            ),
                          ],
                        ),
                      ),
                    )
                  : _captionPhoto(),
            ),
            if (imageFile == null) _uploadPhotoOptions()
          ],
        ),
      ),
    );
  }

  Widget _uploadPhotoOptions() {
    return Container(
      margin: const EdgeInsets.only(bottom: 75),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Theme.of(context).dividerColor,
            width: .75,
          ),
        ),
      ),
      child: Row(
        children: <Widget>[
          InkWell(
            onTap: () {
              _onPickPressed(source: ImageSource.gallery);
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 30),
              width: MediaQuery.of(context).size.width * .5,
              alignment: Alignment.center,
              child: Text(
                'LIBRARY',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).primaryColor,
                  letterSpacing: 1.7,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              _onPickPressed(source: ImageSource.camera);
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 30),
              width: MediaQuery.of(context).size.width * .5,
              alignment: Alignment.center,
              child: Text(
                'CAMERA',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).primaryColor,
                  letterSpacing: 1.7,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _captionPhoto() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          child: ListView(
            children: <Widget>[
              Image.file(imageFile),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                child: TextField(
                  controller: _captionController,
                  textInputAction: TextInputAction.newline,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    hintText: 'Write a caption...',
                    border: InputBorder.none,
                  ),
                  cursorColor: Theme.of(context).primaryColor,
                  cursorWidth: 1,
                  maxLines: null,
                  style: Theme.of(context).textTheme.caption.copyWith(
                        fontSize: 17,
                      ),
                  keyboardAppearance: Theme.of(context).brightness,
                ),
              )
            ],
          ),
        ),
        Container(
          child: Row(
            children: <Widget>[
              InkWell(
                onTap: () {
                  setState(() {
                    imageFile = null;
                  });
                  _onPickPressed(source: imageSource);
                  _toggleBottomNav(true);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * .5,
                  padding: const EdgeInsets.symmetric(vertical: 25),
                  color: Colors.transparent,
                  child: Icon(
                    Icons.keyboard_arrow_left,
                    color: Theme.of(context).primaryColor,
                    size: 28,
                  ),
                ),
              ),
              InkWell(
                onTap: () async => _cropPhoto(),
                child: Container(
                  width: MediaQuery.of(context).size.width * .5,
                  padding: const EdgeInsets.symmetric(vertical: 25),
                  color: Colors.transparent,
                  child: Icon(
                    Icons.crop,
                    color: Theme.of(context).primaryColor,
                    size: 20,
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
