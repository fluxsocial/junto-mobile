import 'dart:async';

import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/app/expressions.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/backend/repositories.dart';
import 'package:junto_beta_mobile/models/expression.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/create/create_actions/create_actions_appbar.dart';
import 'package:junto_beta_mobile/utils/junto_overlay.dart';
import 'package:junto_beta_mobile/utils/utils.dart';
import 'package:junto_beta_mobile/widgets/dialogs/single_action_dialog.dart';
import 'package:junto_beta_mobile/widgets/dialogs/user_feedback.dart';
import 'package:provider/provider.dart';

class CreateCommentActions extends StatefulWidget {
  const CreateCommentActions({
    Key key,
    @required this.expressionType,
    @required this.expression,
    @required this.address,
  }) : super(key: key);

  /// Represents the type of expression being created. Possible values include
  /// "LongForm", "ShortForm", "EventForm", etc
  final ExpressionType expressionType;

  /// Represents the expression data. Value depends on the type of expression
  /// being created.
  final dynamic expression;

  /// Address of the [Group] or collection to which the expression is being posted.
  /// Can also be null if the [expressionContext] == [ExpressionContext.Collective]
  final String address;

  @override
  State<StatefulWidget> createState() => CreateCommentActionsState();
}

class CreateCommentActionsState extends State<CreateCommentActions>
    with ListDistinct {
  ExpressionContext _expressionContext;
  ExpressionModel _expression;

  void _postCreateAction() {
    // navigate to expression open
    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.pop(context);
  }

  Future<ExpressionModel> getPhotoExpression(ExpressionRepo repository) async {
    final image = widget.expression['image'];

    final photoKeys = await repository.createPhotoThumbnails(image);
    return ExpressionModel(
      type: widget.expressionType.modelName(),
      expressionData: PhotoFormExpression(
        image: photoKeys.keyPhoto,
        caption: widget.expression['caption'],
        thumbnail300: photoKeys.key300,
        thumbnail600: photoKeys.key600,
      ).toJson(),
      context: _expressionContext,
    );
  }

  Future<ExpressionModel> getAudioExpression(ExpressionRepo repository) async {
    final audio = widget.expression as AudioFormExpression;
    final AudioFormExpression expression = await repository.createAudio(audio);

    return ExpressionModel(
      type: widget.expressionType.modelName(),
      expressionData: expression.toJson(),
      context: _expressionContext,
    );
  }

  Future<void> _createExpression() async {
    try {
      final repository = Provider.of<ExpressionRepo>(context, listen: false);
      if (widget.expressionType == ExpressionType.photo) {
        JuntoLoader.showLoader(context, color: Colors.white54);
        _expression = await getPhotoExpression(repository);
        JuntoLoader.hide();
      } else if (widget.expressionType == ExpressionType.event) {
        String eventPhoto = '';
        if (widget.expression['photo'] != null) {
          JuntoLoader.showLoader(context);
          final String _eventPhotoKey = await repository.createPhoto(
            true,
            '.png',
            widget.expression['photo'],
          );
          JuntoLoader.hide();
          eventPhoto = _eventPhotoKey;
        }
        _expression = ExpressionModel(
          type: widget.expressionType.modelName(),
          expressionData: EventFormExpression(
              photo: eventPhoto,
              description: widget.expression['description'],
              title: widget.expression['title'],
              location: widget.expression['location'],
              startTime: widget.expression['start_time'],
              endTime: widget.expression['end_time'],
              facilitators: <String>[],
              members: <String>[]).toJson(),
          context: _expressionContext,
        );
      } else if (widget.expressionType == ExpressionType.audio) {
        JuntoLoader.showLoader(context);
        _expression = await getAudioExpression(repository);
        JuntoLoader.hide();
      } else {
        _expression = ExpressionModel(
          type: widget.expressionType.modelName(),
          expressionData: widget.expression.toJson(),
          context: _expressionContext,
        );
      }
      JuntoLoader.showLoader(context);

      await Provider.of<ExpressionRepo>(context, listen: false)
          .postCommentExpression(
        widget.address,
        _expression.type,
        _expression.expressionData,
      );
      JuntoLoader.hide();

      await showFeedback(
        context,
        icon: Icon(
          CustomIcons.newcreate,
          size: 24,
          color: Theme.of(context).primaryColor,
        ),
        message: 'Comment Created!',
      );
      _postCreateAction();
    } catch (error) {
      JuntoLoader.hide();
      showDialog(
        context: context,
        builder: (BuildContext context) => const SingleActionDialog(
          dialogText: 'Something went wrong',
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(45),
        child: CreateActionsAppbar(
          onCreateTap: _createExpression,
        ),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 15),
                Text(
                  'Comment',
                  style: Theme.of(context).textTheme.headline6,
                ),
                Text(
                  'Create a reply to an expression or comment',
                  style: Theme.of(context).textTheme.caption,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 15),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).dividerColor,
                  width: .75,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Row(children: <Widget>[
                    const SizedBox(width: 15),
                    _commentContextSelector(),
                  ]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _commentContextSelector() {
    return Container(
      height: 50,
      width: 50,
      margin: const EdgeInsets.only(right: 15),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          stops: const <double>[0.2, 0.9],
          colors: <Color>[
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.secondary,
          ],
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(1000),
        ),
      ),
      alignment: Alignment.center,
      child: Icon(
        Icons.comment,
        size: 17,
        color: Colors.white,
      ),
    );
  }
}
