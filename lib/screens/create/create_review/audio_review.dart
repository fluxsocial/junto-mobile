import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:junto_beta_mobile/screens/create/create_templates/audio_service.dart';
import 'package:junto_beta_mobile/screens/global_search/search_bloc/search_bloc.dart';
import 'package:junto_beta_mobile/screens/global_search/search_bloc/search_state.dart';
import 'package:junto_beta_mobile/utils/utils.dart';
import 'package:junto_beta_mobile/widgets/audio/audio_preview.dart';
import 'package:junto_beta_mobile/widgets/utils/hex_color.dart';
import 'package:junto_beta_mobile/models/expression.dart';

class CreateAudioReview extends StatelessWidget {
  const CreateAudioReview({
    this.expression,
  });

  final AudioFormExpression expression;

  Widget _showCreateAudioReviewTemplate() {
    print('test: I waas called');
    if (expression.photo == null && expression.gradient.isEmpty) {
      print('returning default');
      return CreateAudioReviewDefault(expression: expression);
    } else if (expression.photo != null && expression.gradient.isEmpty) {
      print('returning audio with photo');
      return CreateAudioReviewWithPhoto(expression: expression);
    } else if (expression.photo == null && expression.gradient.isNotEmpty) {
      print('returning audio with gradient');
      return CreateAudioReviewWithGradient(expression: expression);
    } else {
      print('returning default');
      return CreateAudioReviewDefault(expression: expression);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _showCreateAudioReviewTemplate();
  }
}

class CreateAudioReviewDefault extends StatelessWidget {
  CreateAudioReviewDefault({this.expression});

  final AudioFormExpression expression;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        CreateAudioReviewBody(
          hasBackground: false,
          expression: expression,
        ),
        AudioCaption(caption: expression.caption),
      ],
    );
  }
}

class CreateAudioReviewWithGradient extends StatelessWidget {
  CreateAudioReviewWithGradient({
    this.expression,
  });

  final AudioFormExpression expression;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              stops: <double>[0.2, 0.9],
              colors: <Color>[
                HexColor.fromHex(expression.gradient[0]),
                HexColor.fromHex(expression.gradient[1]),
              ],
            ),
          ),
          child: CreateAudioReviewBody(
            expression: expression,
            hasBackground: true,
          ),
        ),
        AudioCaption(caption: expression.caption),
      ],
    );
  }
}

class CreateAudioReviewWithPhoto extends StatelessWidget {
  CreateAudioReviewWithPhoto({
    this.expression,
  });

  final AudioFormExpression expression;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Stack(children: [
          Container(
            foregroundDecoration: BoxDecoration(
              color: Colors.black45,
            ),
            child: Image.file(
              File(expression.photo),
            ),
          ),
          Positioned(
            top: 15,
            left: 0,
            right: 0,
            child: AudioTitle(
              title: expression.title,
              hasBackground: true,
            ),
          ),
          Positioned(
            bottom: 15,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
              ),
              child: AudioPlaybackRow(
                hasBackground: true,
              ),
            ),
          ),
        ]),
        AudioCaption(caption: expression.caption),
      ],
    );
  }
}

class CreateAudioReviewBody extends StatelessWidget {
  CreateAudioReviewBody({
    @required this.hasBackground,
    @required this.expression,
  });
  final AudioFormExpression expression;
  final bool hasBackground;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: hasBackground ? Colors.black45 : Colors.transparent,
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AudioTitle(
            hasBackground: hasBackground,
            title: expression.title,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: AudioPlaybackRow(
              hasBackground: hasBackground,
            ),
          ),
        ],
      ),
    );
  }
}

class AudioTitle extends StatelessWidget {
  const AudioTitle({
    Key key,
    @required this.title,
    @required this.hasBackground,
  }) : super(key: key);

  final String title;
  final bool hasBackground;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      margin: const EdgeInsets.only(bottom: 15),
      child: Text(
        title,
        style: TextStyle(
          color: hasBackground ? Colors.white : Theme.of(context).primaryColor,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class AudioCaption extends StatelessWidget with CreateExpressionHelpers {
  AudioCaption({
    Key key,
    @required this.caption,
  }) : super(key: key);

  final String caption;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Text(
            caption,
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 17,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      },
    );
  }
}
