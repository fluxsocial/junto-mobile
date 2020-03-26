import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
  File imageFile;
  TextEditingController _captionController;
  bool _showBottomNav = true;

  Future<void> _onPickPressed() async {
    try {
      final File image =
          await ImagePicker.pickImage(source: ImageSource.gallery);
      if (image == null) {
        setState(() => imageFile = null);
        return;
      }
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
        setState(() => imageFile = null);
        return;
      }
      setState(() => imageFile = cropped);
      _toggleBottomNav(false);
    } catch (e, s) {
      logger.logException(e, s);
    }
  }

  Future<void> _cropPhoto() async {
    final File image = imageFile;
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
      setState(() => imageFile = null);
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
      'caption': _captionController.value.text
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
        child: Center(
          child: imageFile == null
              ? Transform.translate(
                  offset: const Offset(0.0, -50.0),
                  child: GestureDetector(
                    onTap: _onPickPressed,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          height: 100,
                          width: 100,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(
                                color: Theme.of(context).primaryColor,
                                width: 1.5),
                            borderRadius: BorderRadius.circular(10000),
                          ),
                          child: Text(
                            '+',
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 28),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Press here to share a photo',
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 17),
                        )
                      ],
                    ),
                  ),
                )
              : Column(
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
                              textInputAction: TextInputAction.done,
                              decoration: const InputDecoration(
                                hintText: 'write a caption..',
                                border: InputBorder.none,
                              ),
                              cursorColor: Theme.of(context).primaryColor,
                              cursorWidth: 1,
                              maxLines: null,
                              style: Theme.of(context).textTheme.caption,
                              keyboardAppearance: Theme.of(context).brightness,
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 25),
                      child: Row(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                imageFile = null;
                              });
                              _toggleBottomNav(true);
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * .5,
                              color: Colors.transparent,
                              child: Icon(Icons.keyboard_arrow_left,
                                  color: Theme.of(context).primaryColor,
                                  size: 28),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              _cropPhoto();
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * .5,
                              color: Colors.transparent,
                              child: Icon(Icons.crop,
                                  color: Theme.of(context).primaryColor,
                                  size: 20),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
