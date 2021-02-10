import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_mentions/flutter_mentions.dart';
import 'package:image_picker/image_picker.dart';
import 'package:junto_beta_mobile/app/expressions.dart';
import 'package:junto_beta_mobile/backend/repositories/expression_repo.dart';
import 'package:junto_beta_mobile/models/expression.dart';
import 'package:junto_beta_mobile/screens/create/create_actions/create_actions.dart';
import 'package:junto_beta_mobile/screens/create/create_actions/create_comment_actions.dart';
import 'package:junto_beta_mobile/utils/utils.dart';
import 'package:junto_beta_mobile/widgets/dialogs/single_action_dialog.dart';
import 'package:junto_beta_mobile/widgets/image_cropper.dart';
import 'package:provider/provider.dart';
import 'audio_service.dart';
import 'widgets/audio_bottom_tools.dart';
import 'widgets/audio_photo_options.dart';
import 'widgets/audio_record.dart';
import 'widgets/audio_review.dart';

class CreateAudio extends StatefulWidget {
  const CreateAudio({
    Key key,
    this.expressionContext,
    this.address,
    @required this.titleFocus,
    @required this.captionFocus,
  }) : super(key: key);
  final ExpressionContext expressionContext;
  final String address;
  final FocusNode titleFocus;
  final FocusNode captionFocus;

  @override
  State<StatefulWidget> createState() {
    return CreateAudioState();
  }
}

class CreateAudioState extends State<CreateAudio>
    with CreateExpressionHelpers, AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  bool _showBottomTools = true;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController captionController = TextEditingController();
  File audioPhotoBackground;
  List<String> audioGradientValues = [];
  GlobalKey<FlutterMentionsState> mentionKey =
      GlobalKey<FlutterMentionsState>();
  FocusNode _captionFocus;

  Future<void> _onPickPressed({String source}) async {
    try {
      final imagePicker = ImagePicker();
      PickedFile file;
      if (source == 'Camera') {
        file = await imagePicker.getImage(source: ImageSource.camera);
      } else if (source == 'Gallery') {
        file = await imagePicker.getImage(source: ImageSource.gallery);
      } else {
        file = await imagePicker.getImage(source: ImageSource.camera);
      }
      final image = File(file.path);

      if (image == null && audioPhotoBackground == null) {
        setState(() => audioPhotoBackground = null);
        return;
      } else if (image == null && audioPhotoBackground != null) {
        return;
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
      Navigator.of(context).focusScopeNode.unfocus();
      if (cropped == null) {
        setState(() => audioPhotoBackground = null);

        return;
      }

      setState(() {
        audioPhotoBackground = cropped;
        audioGradientValues = [];
      });
    } catch (error) {
      print(error);
    }
  }

  void _resetAudioPhotoBackground() {
    setState(() {
      audioPhotoBackground = null;
    });
  }

  void _resetAudioGradientValues() {
    setState(() {
      audioGradientValues = [];
    });
  }

  void _setAudioGradientValues(String hexOne, String hexTwo) {
    _resetAudioPhotoBackground();
    setState(() {
      audioGradientValues = [hexOne, hexTwo];
    });
  }

  void _audioPhotoOptions() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      builder: (BuildContext context) => AudioPhotoOptions(
        updatePhoto: _onPickPressed,
        resetPhoto: _resetAudioPhotoBackground,
      ),
    );
  }

  void _toggleBottomTools() {
    setState(() {
      _showBottomTools = !_showBottomTools;
    });
  }

  AudioFormExpression createExpression(AudioService audio) {
    final markupText = mentionKey.currentState.controller.markupText;

    return AudioFormExpression(
      audio: audio.recordingPath,
      title: titleController.text.trim(),
      photo: audioPhotoBackground?.path,
      gradient: audioGradientValues,
      caption: markupText.trim(),
    );
  }

  Map<String, List<String>> getMentionsAndChannels() {
    final markupText = mentionKey.currentState.controller.markupText;
    final mentions = getMentionUserId(markupText);
    final channels = getChannelsId(markupText);
    return {'mentions': mentions, 'channels': channels};
  }

  @override
  void initState() {
    super.initState();
    _captionFocus = widget.captionFocus;
    _captionFocus.addListener(_toggleBottomTools);
  }

  @override
  void dispose() {
    super.dispose();
    widget.captionFocus.removeListener(_toggleBottomTools);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AudioService>(
      builder: (context, audio, child) {
        return Expanded(
          child: Stack(
            children: <Widget>[
              !audio.playBackAvailable
                  ? AudioRecord()
                  : AudioReview(
                      audioPhotoBackground: audioPhotoBackground,
                      audioGradientValues: audioGradientValues,
                      titleController: titleController,
                      captionController: captionController,
                      captionFocus: widget.captionFocus,
                      titleFocus: widget.titleFocus,
                      mentionKey: mentionKey,
                    ),
              if (audio.playBackAvailable && _showBottomTools)
                AudioBottomTools(
                  openPhotoOptions: _audioPhotoOptions,
                  resetAudioPhotoBackground: _resetAudioPhotoBackground,
                  resetAudioGradientValues: _resetAudioGradientValues,
                  setAudioGradientValues: _setAudioGradientValues,
                )
            ],
          ),
        );
      },
    );
  }

  bool expressionHasData(AudioService audio) {
    if (audio.playBackAvailable && audio.recordingPath != null) {
      return true;
    } else {
      return false;
    }
  }

  void _onNext(AudioService audio) {
    if (expressionHasData(audio)) {
      final markupText = mentionKey.currentState.controller.markupText;
      final mentions = getMentionUserId(markupText);
      final channels = getChannelsId(markupText);

      final audioExpression = AudioFormExpression(
        title: titleController.text.trim(),
        photo: audioPhotoBackground?.path,
        audio: audio.recordingPath,
        gradient: audioGradientValues,
        caption: markupText.trim(),
      );
      print(channels);
      if (channels.length > 5) {
        showDialog(
          context: context,
          builder: (BuildContext context) => SingleActionDialog(
            context: context,
            dialogText:
                'You can only add five channels. Please reduce the number of channels you have before continuing.',
          ),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute<dynamic>(
            builder: (BuildContext context) {
              if (widget.expressionContext == ExpressionContext.Comment) {
                return CreateCommentActions(
                  expression: audioExpression,
                  address: widget.address,
                  expressionType: ExpressionType.audio,
                );
              } else {
                return CreateActions(
                  expressionType: ExpressionType.audio,
                  address: widget.address,
                  expressionContext: widget.expressionContext,
                  expression: audioExpression,
                  mentions: mentions,
                  channels: channels,
                );
              }
            },
          ),
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) => const SingleActionDialog(
          dialogText: "Seems like you haven't recorded anything",
        ),
      );
      return;
    }
  }
}
