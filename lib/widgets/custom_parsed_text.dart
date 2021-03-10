import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_parsed_text/flutter_parsed_text.dart';
import 'package:junto_beta_mobile/backend/repositories/user_repo.dart';
import 'package:junto_beta_mobile/filters/bloc/channel_filtering_bloc.dart';
import 'package:junto_beta_mobile/models/expression.dart';
import 'package:junto_beta_mobile/models/expression_query_params.dart';
import 'package:junto_beta_mobile/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dialogs/single_action_dialog.dart';

class CustomParsedText extends StatelessWidget with MemberValidation {
  final TextStyle defaultTextStyle;
  final TextStyle mentionTextStyle;
  final String text;
  final int maxLines;
  final TextOverflow overflow;
  final TextAlign alignment;
  final bool disableOnMentiontap;

  const CustomParsedText(
    this.text, {
    Key key,
    this.defaultTextStyle,
    this.mentionTextStyle,
    this.maxLines,
    this.overflow = TextOverflow.visible,
    this.alignment = TextAlign.start,
    this.disableOnMentiontap = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChannelFilteringBloc, ChannelFilteringState>(
        builder: (BuildContext context, ChannelFilteringState state) {
      return ParsedText(
        text: text.trim(),
        maxLines: maxLines,
        overflow: overflow,
        alignment: alignment,
        style: defaultTextStyle,
        parse: [
          MatchText(
            pattern: r"\[(@[^:]+):([^\]]+)\]",
            style: mentionTextStyle,
            renderText: ({String str, String pattern}) {
              Map<String, String> map = <String, String>{};
              RegExp customRegExp = RegExp(pattern);
              Match match = customRegExp.firstMatch(str);
              map['display'] = match.group(1);
              map['value'] = match.group(2);
              return map;
            },
            onTap: !disableOnMentiontap
                ? (url) async {
                    final userData =
                        await Provider.of<UserRepo>(context, listen: false)
                            .getUser(url);
                    await showUserDen(context, userData.user);
                  }
                : null,
          ),
          MatchText(
            pattern: r"([#][^\s#\@]*)",
            style: mentionTextStyle,
            onTap: !disableOnMentiontap
                ? (url) {
                    Navigator.popUntil(context, (route) {
                      final name = url.toString().replaceFirst('#', '');
                      final foundChannel = state.selectedChannel != null
                          ? state.selectedChannel
                              .indexWhere((element) => element.name == name)
                          : -1;
                      context.read<ChannelFilteringBloc>().add(
                            FilterSelected(
                              [
                                if (state.selectedChannel != null)
                                  ...state.selectedChannel,
                                if (foundChannel == -1)
                                  Channel(
                                    name: url.toString().replaceFirst('#', ''),
                                  ),
                              ],
                              ExpressionContextType.Collective,
                            ),
                          );

                      return route.isFirst;
                    });
                  }
                : null,
          ),
          MatchText(
            pattern:
                r"[(http(s)?):\/\/(www\.)?a-zA-Z0-9@:._\+~#=]{2,256}\.[a-z]{2,18}\b([-a-zA-Z0-9@:_\+.~#?&//=]*)",
            style: mentionTextStyle,
            onTap: !disableOnMentiontap
                ? (url) async {
                    final String updatedUrl =
                        (!url.toString().contains(RegExp(r'((H|h)ttp(s)?):'))
                                ? 'https://$url'
                                : url)
                            .toLowerCase();

                    if (await canLaunch(updatedUrl)) {
                      await launch(updatedUrl);
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                            const SingleActionDialog(
                          dialogText: 'Hmm, It seems the URL is incorrect.',
                        ),
                      );
                    }
                  }
                : null,
          )
        ],
      );
    });
  }
}

// https://junto.foundation
// https://junto.foundation
