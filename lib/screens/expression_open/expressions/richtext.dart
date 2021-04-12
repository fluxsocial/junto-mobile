import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/html_parser.dart';
import 'package:flutter_html/style.dart';
import 'package:html/dom.dart' as dom;
import 'package:junto_beta_mobile/backend/repositories/app_repo.dart';
import 'package:junto_beta_mobile/backend/repositories/user_repo.dart';
import 'package:junto_beta_mobile/filters/bloc/channel_filtering_bloc.dart';
import 'package:junto_beta_mobile/models/expression.dart';
import 'package:junto_beta_mobile/models/expression_query_params.dart';
import 'package:junto_beta_mobile/utils/utils.dart';
import 'package:provider/provider.dart';

class Richtext extends StatefulWidget {
  final List<dynamic> data;
  final bool disableOnMentiontap;
  final bool open;

  const Richtext({
    Key key,
    this.data,
    this.disableOnMentiontap = false,
    this.open = true,
  }) : super(key: key);

  @override
  _RichtextState createState() => _RichtextState();
}

class _RichtextState extends State<Richtext> with MemberValidation {
  @override
  Widget build(BuildContext context) {
    final appRepo = Provider.of<AppRepo>(context);
    return Container(
      child: Column(
        children: [
          ...widget.data.asMap().entries.map((e) {
            final i = e.key;
            final val = e.value;

            if (val['type'] == 'header1') {
              return buildParagraph(
                val['text'],
                disableOnMentiontap: widget.disableOnMentiontap,
                defaultStyle: Style(
                    fontSize: FontSize(32.0),
                    fontWeight: FontWeight.bold,
                    height: 1.0,
                    color: Colors.black),
              );
            } else if (val['type'] == 'header2') {
              return buildParagraph(
                val['text'],
                disableOnMentiontap: widget.disableOnMentiontap,
                defaultStyle: Style(
                    fontSize: FontSize(24.0),
                    fontWeight: FontWeight.bold,
                    height: 1.0,
                    color: Colors.black),
              );
            } else if (val['type'] == 'header3') {
              return buildParagraph(
                val['text'],
                disableOnMentiontap: widget.disableOnMentiontap,
                defaultStyle: Style(
                    fontSize: FontSize(18.0),
                    fontWeight: FontWeight.bold,
                    height: 1.0,
                    color: Colors.black),
              );
            } else if (val['type'] == 'quote') {
              return IntrinsicHeight(
                child: Row(children: [
                  Container(
                    width: 4,
                    color: Colors.grey,
                    margin: EdgeInsets.only(right: 10.0),
                  ),
                  Container(
                    width: (MediaQuery.of(context).size.width /
                            (appRepo.twoColumnLayout && !widget.open
                                ? 2.5
                                : 1)) -
                        34,
                    child: buildParagraph(
                      val['text'],
                      disableOnMentiontap: widget.disableOnMentiontap,
                      defaultStyle: Style(fontSize: FontSize(20.0)),
                    ),
                  ),
                ]),
              );
            } else if (val['type'] == 'list-item') {
              return Container(
                margin: EdgeInsets.only(
                    left: val['indent'] == 1 ? 0.0 : val['indent'] * 8.0),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 4.0),
                      child: Row(
                        children: [
                          if (val['symbol'] == '*')
                            Container(
                              height: 8,
                              width: 8,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4.0),
                                  color: Colors.black),
                            )
                          else
                            Text('${getListCount(widget.data, i)}.')
                        ],
                      ),
                    ),
                    Container(
                      width: (MediaQuery.of(context).size.width /
                              (appRepo.twoColumnLayout && !widget.open
                                  ? 2.5
                                  : 1)) -
                          44,
                      child: buildParagraph(
                        val['text'],
                        disableOnMentiontap: widget.disableOnMentiontap,
                      ),
                    ),
                  ],
                ),
              );
            } else if (val['type'] == 'horizontal-rule') {
              return Container(
                margin: EdgeInsets.symmetric(vertical: 10.0),
                height: 2,
                width: MediaQuery.of(context).size.width,
                color: Colors.black87,
              );
            } else if (val['type'] == 'paragraph') {
              return buildParagraph(
                val['text'],
                disableOnMentiontap: widget.disableOnMentiontap,
              );
            }
            return Container();
          }).toList(),
        ],
      ),
    );
  }

  buildParagraph(
    String data, {
    Style defaultStyle,
    bool disableOnMentiontap = false,
  }) {
    final fontSize = defaultStyle != null ? defaultStyle.fontSize.size : 16.0;

    return BlocBuilder<ChannelFilteringBloc, ChannelFilteringState>(
      builder: (context, state) {
        return Html(
          data: data,
          shrinkWrap: true,
          customRender: {
            "mention": (RenderContext renderContext, Widget child,
                Map<String, String> attributes, dom.Element element) {
              RegExp mentionRegexp = RegExp(r"\[(@[^:]+):([^\]]+)\]");

              final match = mentionRegexp.firstMatch(element.text);

              return GestureDetector(
                onTap: () async {
                  if (!disableOnMentiontap) {
                    final userData =
                        await Provider.of<UserRepo>(context, listen: false)
                            .getUser(match.group(2));
                    await showUserDen(context, userData.user);
                  }
                },
                child: Text(
                  match.group(1),
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: fontSize),
                ),
              );
            },
            "channel": (RenderContext renderContext, Widget child,
                Map<String, String> attributes, dom.Element element) {
              return GestureDetector(
                onTap: () {
                  if (!disableOnMentiontap) {
                    Navigator.popUntil(context, (route) {
                      final name =
                          element.text.toString().replaceFirst('#', '');
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
                                    name: element.text
                                        .toString()
                                        .replaceFirst('#', ''),
                                  ),
                              ],
                              ExpressionContextType.Collective,
                            ),
                          );

                      return route.isFirst;
                    });
                  }
                },
                child: Text(
                  element.text,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: fontSize),
                ),
              );
            },
          },
          style: {
            '*': defaultStyle != null ? defaultStyle : Style(),
          },
        );
      },
    );
  }
}

int getListCount(List<dynamic> data, int currentIndex) {
  if ((data[currentIndex]['type'] == 'list-item' &&
          data[currentIndex]['symbol'] == '*') ||
      currentIndex == 0) {
    return 0;
  }
  return 1 + getListCount(data, currentIndex - 1);
}
