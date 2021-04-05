import 'package:flutter/material.dart';
import 'package:flutter_mentions/flutter_mentions.dart';
import 'package:flutter_richtext/flutter_richtext.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/create/create_templates/widgets/custom_text.dart';
import 'package:junto_beta_mobile/utils/utils.dart';
import 'package:junto_beta_mobile/widgets/mentions/channel_search_list.dart';
import 'package:junto_beta_mobile/widgets/mentions/mentions_search_list.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:provider/provider.dart';

class CreateLongform extends StatefulWidget {
  const CreateLongform({
    Key key,
    this.captionFocus,
    this.titleFocus,
  }) : super(key: key);

  final FocusNode captionFocus;
  final FocusNode titleFocus;

  @override
  State<StatefulWidget> createState() {
    return CreateLongformState();
  }
}

class CreateLongformState extends State<CreateLongform>
    with CreateExpressionHelpers, AutomaticKeepAliveClientMixin {
  TextEditingController _titleController;
  GlobalKey<FlutterMentionsState> mentionKey =
      GlobalKey<FlutterMentionsState>();
  bool _showList = false;
  List<Map<String, dynamic>> addedmentions = [];
  List<Map<String, dynamic>> users = [];
  List<Map<String, dynamic>> completeUserList = [];
  List<Map<String, dynamic>> addedChannels = [];
  List<Map<String, dynamic>> channels = [];
  List<Map<String, dynamic>> completeChannelsList = [];
  ListType listType = ListType.empty;

  // richtext editor
  MutableDocument _doc;
  DocumentEditor _docEditor;
  DocumentComposer _composer;
  String _pattern = '';
  bool showSuggestions = false;
  String searchValue = '';
  int searchPos = -1;
  List<LengthMap> _lengthMap = <LengthMap>[];
  Map<String, Annotation> data;

  @override
  void initState() {
    super.initState();
    data = mapToAnotation();
    _pattern = "(${data.keys.map((key) => RegExp.escape(key)).join('|')})";
    _titleController = TextEditingController();
    _doc = MutableDocument(nodes: [
      ParagraphNode(
        id: DocumentEditor.createNodeId(),
        text: AttributedText(
          text: 'Example Document',
        ),
      ),
    ]);
    _docEditor = DocumentEditor(document: _doc);
    _composer = DocumentComposer();
    _docEditor.document.addListener(suggestionListerner);
  }

  void toggleAttributions(String attributions) {
    final selection = _composer.selection;

    _docEditor.executeCommand(ToggleTextAttributionsCommand(
      documentSelection: selection,
      attributions: {attributions},
    ));

    _composer.notifyListeners();
  }

  Future<QueryResults<UserProfile>> _getUsers(
    String query, [
    int pos,
    String time,
    QueryUserBy username = QueryUserBy.USERNAME,
  ]) async {
    final result = await Provider.of<SearchRepo>(context, listen: false)
        .searchMembers(query,
            paginationPosition: pos, lastTimeStamp: time, username: username);
    return result;
  }

  Future<QueryResults<Channel>> _getChannels(String query,
      [int paginationPosition = 0, DateTime time]) async {
    final result = await Provider.of<SearchRepo>(context, listen: false)
        .searchChannel(query,
            paginationPosition: paginationPosition, lastTimeStamp: time);
    return result;
  }

  Map<String, Annotation> mapToAnotation() {
    final data = <String, Annotation>{};

    List<Mention> mentions = [
      Mention(trigger: '@', data: [...completeUserList, ...addedmentions]),
      Mention(
          trigger: '#',
          data: [...completeChannelsList, ...addedChannels],
          matchAll: true)
    ];

    // Loop over all the mention items and generate a suggestions matching list
    mentions.forEach((element) {
      // if matchAll is set to true add a general regex patteren to match with
      if (element.matchAll) {
        data['${element.trigger}([A-Za-z0-9])*'] = Annotation(
          style: element.style,
          id: null,
          display: null,
          trigger: element.trigger,
          disableMarkup: element.disableMarkup,
          markupBuilder: element.markupBuilder,
        );
      }

      element.data.forEach(
        (e) => data["${element.trigger}${e['display']}"] = e['style'] != null
            ? Annotation(
                style: e['style'],
                id: e['id'],
                display: e['display'],
                trigger: element.trigger,
                disableMarkup: element.disableMarkup,
                markupBuilder: element.markupBuilder,
              )
            : Annotation(
                style: element.style,
                id: e['id'],
                display: e['display'],
                trigger: element.trigger,
                disableMarkup: element.disableMarkup,
                markupBuilder: element.markupBuilder,
              ),
      );
    });

    return data;
  }

  void suggestionListerner() async {
    final node = _doc.getNode(_composer.selection.base);

    if (node.runtimeType == ParagraphNode) {
      final _node = node as ParagraphNode;

      final _textPosition =
          _composer.selection.base.nodePosition as TextPosition;

      final cursorPos = _textPosition.offset + 1;

      if (cursorPos >= 0) {
        var _pos = 0;

        _lengthMap = <LengthMap>[];

        // split on each word and generate a list with start & end position of each word.
        _node.text.text.split(RegExp(r'(\s)')).forEach((element) {
          _lengthMap.add(
              LengthMap(str: element, start: _pos, end: _pos + element.length));

          _pos = _pos + element.length + 1;
        });

        final val = _lengthMap.indexWhere((element) {
          final _pattern = '@|#';

          return element.end == cursorPos &&
              element.str.toLowerCase().contains(RegExp(_pattern));
        });

        showSuggestions = val != -1;

        if (val != -1) {
          searchValue = _lengthMap[val].str;
          searchPos = _node.text.text.indexOf(_pattern);

          final channel = searchValue[0] == '#';
          final value = searchValue.replaceAll(RegExp(r'@|#'), '');
          if (value.isNotEmpty && showSuggestions) {
            if (!channel) {
              final result =
                  await _getUsers(value, null, null, QueryUserBy.BOTH);

              final eq = DeepCollectionEquality.unordered().equals;

              final _users = result.results.where((element) {
                return addedmentions
                        .indexWhere((e) => element.address == e['id']) ==
                    -1;
              }).map((e) {
                return ({
                  'id': e.address,
                  'display': e.username,
                  'full_name': e.name,
                  'photo':
                      e.profilePicture.isNotEmpty ? e.profilePicture[0] : '',
                  'bio': e.bio,
                  'backgroundPhoto': e.backgroundPhoto,
                });
              }).toList();

              final isEqual = eq(users, _users);

              if (!isEqual) {
                setState(() {
                  users = _users;

                  listType = ListType.mention;

                  completeUserList =
                      generateFinalList(completeUserList, _users);
                });
              }
            } else {
              final result = await _getChannels(value);

              final eq = DeepCollectionEquality.unordered().equals;

              final _channels = result.results.where((element) {
                return addedChannels
                        .indexWhere((e) => element.name == e['id']) ==
                    -1;
              }).map((e) {
                return ({
                  'id': e.name,
                  'display': e.name,
                });
              }).toList();

              final isEqual = eq(channels, _channels);

              if (!isEqual) {
                setState(() {
                  channels = _channels;

                  listType = ListType.channels;

                  completeChannelsList =
                      generateFinalList(completeChannelsList, _channels);
                });
              }
            }

            data = mapToAnotation();
            _pattern = "(${data.keys.map(RegExp.escape).join('|')})";

            setState(() {
              showSuggestions = val != -1;
              searchValue = _lengthMap[val].str;
              searchPos = _node.text.text.indexOf(_pattern);
            });
          } else {
            setState(() {
              users = [];
              channels = [];
              listType = ListType.empty;
              _showList = false;
            });
          }
        } else {
          searchValue = '';
        }
      }
    }
  }

  Widget firstParagraphHintComponentBuilder(ComponentContext componentContext) {
    if (componentContext.documentNode is! ParagraphNode) {
      return null;
    }

    final textSelection = componentContext.nodeSelection == null ||
            componentContext.nodeSelection.nodeSelection is! TextSelection
        ? null
        : componentContext.nodeSelection.nodeSelection as TextSelection;
    if (componentContext.nodeSelection != null &&
        componentContext.nodeSelection.nodeSelection is! TextSelection) {}
    final showCaret = componentContext.nodeSelection != null
        ? componentContext.nodeSelection.isExtent
        : false;
    final highlightWhenEmpty = componentContext.nodeSelection == null
        ? false
        : componentContext.nodeSelection.highlightWhenEmpty;

    TextAlign textAlign = TextAlign.left;
    final textAlignName =
        (componentContext.documentNode as TextNode).metadata['textAlign'];
    switch (textAlignName) {
      case 'left':
        textAlign = TextAlign.left;
        break;
      case 'center':
        textAlign = TextAlign.center;
        break;
      case 'right':
        textAlign = TextAlign.right;
        break;
      case 'justify':
        textAlign = TextAlign.justify;
        break;
    }

    var children = <InlineSpan>[];

    final paragraphNode = componentContext.documentNode;
    if (paragraphNode is! ParagraphNode) {
      return null;
    }

    final node = paragraphNode as ParagraphNode;

    final text = node.text.text;

    if (_pattern == null || _pattern == '()') {
      children.add(TextSpan(text: text));
    } else {
      text.splitMapJoin(
        RegExp('$_pattern'),
        onMatch: (Match match) {
          children.add(
            TextSpan(
              text: match[0],
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          );
        },
        onNonMatch: (String text) {
          children.add(TextSpan(text: text));
          return '';
        },
      );
    }

    return CustomTextComponent(
      key: componentContext.componentKey,
      pattern: _pattern,
      text: node.text,
      textStyleBuilder: defaultRichtextStyleBuilder,
      metadata: (componentContext.documentNode as TextNode).metadata,
      textAlign: textAlign,
      textSelection: textSelection,
      selectionColor: (componentContext.extensions[selectionStylesExtensionKey]
              as SelectionStyle)
          .selectionColor,
      showCaret: showCaret,
      caretColor: (componentContext.extensions[selectionStylesExtensionKey]
              as SelectionStyle)
          .textCaretColor,
      highlightWhenEmpty: highlightWhenEmpty,
    );
  }

  /// Creates a [LongFormExpression] from the given data entered
  /// by the user.
  LongFormExpression createExpression() {
    final markupText = mentionKey.currentState.controller.markupText;

    return LongFormExpression(
      title: _titleController.value.text.trim(),
      body: markupText.trim(),
    );
  }

  Map<String, List<String>> getMentionsAndChannels() {
    final LongFormExpression expression = createExpression();
    final mentions = getMentionUserId(expression.body);
    final channels = getChannelsId(expression.body);

    return {'mentions': mentions, 'channels': channels};
  }

  bool expressionHasData() {
    final body = mentionKey.currentState.controller.text.trim();
    final title = _titleController.value.text.trim();
    // Body cannot be empty if the title is also empty
    if (title.isEmpty) {
      return body.isNotEmpty;
    }
    // Body can be empty if the title is not empty
    if (title.isNotEmpty) {
      return true;
    }
    // Title can be empty if the title is not empty
    if (body.isNotEmpty) {
      return true;
    }
    return false;
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _docEditor.document.removeListener(suggestionListerner);
  }

  void toggleSearch(bool value) {
    if (value != _showList) {
      setState(() {
        _showList = value;
      });
    }
  }

  void addList({bool ordered = true}) {
    final nodeId = _composer.selection.base.nodeId;
    final index = _doc.nodes.indexWhere((element) => element.id == nodeId);

    final list = ordered
        ? ListItemNode.ordered(
            id: DocumentEditor.createNodeId(), text: AttributedText(text: ''))
        : ListItemNode.unordered(
            id: DocumentEditor.createNodeId(), text: AttributedText(text: ''));

    _doc.nodes.insert(index + 1, list);

    _doc.notifyListeners();
  }

  void addHorizontalRule() {
    final nodeId = _composer.selection.base.nodeId;
    // _docEditor.executeCommand(SplitListItemCommand(nodeId: nodeId));
    final index = _doc.nodes.indexWhere((element) => element.id == nodeId);

    _doc.nodes.insert(
        index + 1, HorizontalRuleNode(id: DocumentEditor.createNodeId()));

    _doc.notifyListeners();
  }

  void addImage() {
    final nodeId = _composer.selection.base.nodeId;
    // _docEditor.executeCommand(SplitListItemCommand(nodeId: nodeId));
    final index = _doc.nodes.indexWhere((element) => element.id == nodeId);

    _doc.nodes.insert(
        index + 1, ImageNode(id: DocumentEditor.createNodeId(), imageUrl: ''));

    _doc.notifyListeners();
  }

  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
        keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
        keyboardBarColor: Colors.grey[200],
        actions: [
          KeyboardActionsItem(
            focusNode: widget.captionFocus,
            displayArrows: false,
            displayDoneButton: false,
            displayActionBar: false,
            footerBuilder: (context) {
              return MyCustomBarWidget(
                toggleAttributions: toggleAttributions,
                addList: addList,
                addHorizontalRule: addHorizontalRule,
                addImage: addImage,
              );
            },
          ),
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Expanded(
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextField(
                focusNode: widget.titleFocus,
                buildCounter: (
                  BuildContext context, {
                  int currentLength,
                  int maxLength,
                  bool isFocused,
                }) =>
                    null,
                controller: _titleController,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Title',
                  hintStyle: Theme.of(context).textTheme.headline6.copyWith(
                        color: Theme.of(context).primaryColorLight,
                      ),
                ),
                cursorColor: Theme.of(context).primaryColor,
                cursorWidth: 2,
                maxLines: null,
                maxLength: 140,
                style: Theme.of(context).textTheme.headline6,
                keyboardAppearance: Theme.of(context).brightness,
                textCapitalization: TextCapitalization.sentences,
                keyboardType: TextInputType.text,
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  KeyboardActions(
                    config: _buildConfig(context),
                    child: Container(
                      height: 400,
                      width: 500,
                      child: Editor.custom(
                        editor: _docEditor,
                        composer: _composer,
                        focusNode: widget.captionFocus,
                        maxWidth: 600,
                        padding: const EdgeInsets.symmetric(
                          vertical: 56,
                          horizontal: 24,
                        ),
                        componentBuilders: [
                          firstParagraphHintComponentBuilder,
                          unorderedListItemBuilder,
                          orderedListItemBuilder,
                          horizontalRuleBuilder,
                          imageBuilder,
                          unknownComponentBuilder,
                        ],
                      ),
                    ),
                  ),
                  if (showSuggestions &&
                      widget.captionFocus.hasFocus &&
                      listType == ListType.mention)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      left: 0,
                      child: MentionsSearchList(
                        userList: users,
                        onMentionAdd: (index) {
                          if (addedmentions.indexWhere((element) =>
                                  element['id'] == users[index]['id']) ==
                              -1) {
                            addedmentions = [...addedmentions, users[index]];
                          }

                          final strToadd = users[index]['display']
                              .toString()
                              .replaceFirst(
                                  searchValue.replaceFirst('@', ''), '');
                          final position =
                              _composer.selection.extent.nodePosition.offset +
                                  strToadd.length;
                          var pos = TextPosition(
                              offset: _composer
                                  .selection.extent.nodePosition.offset);
                          _docEditor.executeCommand(InsertTextCommand(
                            documentPosition: DocumentPosition(
                              nodeId: _composer.selection.base.nodeId,
                              nodePosition: pos,
                            ),
                            textToInsert: strToadd,
                            attributions: {},
                          ));

                          _composer.selection = _composer.selection.copyWith(
                            base: DocumentPosition(
                              nodeId: _composer.selection.base.nodeId,
                              nodePosition: TextPosition(offset: position),
                            ),
                            extent: DocumentPosition(
                              nodeId: _composer.selection.base.nodeId,
                              nodePosition: TextPosition(offset: position),
                            ),
                          );

                          _composer.notifyListeners();

                          setState(() {
                            _showList = false;
                            users = [];
                          });
                        },
                      ),
                    ),
                  if (showSuggestions &&
                      widget.captionFocus.hasFocus &&
                      listType == ListType.channels)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      left: 0,
                      child: ChannelsSearchList(
                        channels: channels,
                        onChannelAdd: (index) {
                          if (addedChannels.indexWhere((element) =>
                                  element['id'] == channels[index]['id']) ==
                              -1) {
                            addedChannels = [...addedChannels, channels[index]];
                          }

                          final strToadd = channels[index]['display']
                              .toString()
                              .replaceFirst(
                                  searchValue.replaceFirst('@', ''), '');
                          final position =
                              _composer.selection.extent.nodePosition.offset +
                                  strToadd.length;
                          var pos = TextPosition(
                              offset: _composer
                                  .selection.extent.nodePosition.offset);
                          _docEditor.executeCommand(InsertTextCommand(
                            documentPosition: DocumentPosition(
                              nodeId: _composer.selection.base.nodeId,
                              nodePosition: pos,
                            ),
                            textToInsert: strToadd,
                            attributions: {},
                          ));

                          _composer.selection = _composer.selection.copyWith(
                            base: DocumentPosition(
                              nodeId: _composer.selection.base.nodeId,
                              nodePosition: TextPosition(offset: position),
                            ),
                            extent: DocumentPosition(
                              nodeId: _composer.selection.base.nodeId,
                              nodePosition: TextPosition(offset: position),
                            ),
                          );

                          _composer.notifyListeners();

                          setState(() {
                            _showList = false;
                            channels = [];
                          });
                        },
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class MyCustomBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const MyCustomBarWidget({
    Key key,
    this.toggleAttributions,
    this.addList,
    this.addHorizontalRule,
    this.addImage,
  }) : super(key: key);

  final Function(String) toggleAttributions;
  final Function({bool ordered}) addList;
  final Function addHorizontalRule;
  final Function addImage;

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: [
        Transform.scale(
          scale: 0.8,
          child: IconButton(
            padding: EdgeInsets.all(2.0),
            icon: Icon(Icons.format_bold),
            onPressed: () => toggleAttributions('bold'),
          ),
        ),
        Transform.scale(
          scale: 0.8,
          child: IconButton(
            padding: EdgeInsets.all(2.0),
            icon: Icon(Icons.format_italic),
            onPressed: () => toggleAttributions('italics'),
          ),
        ),
        Transform.scale(
          scale: 0.8,
          child: IconButton(
            padding: EdgeInsets.all(2.0),
            icon: Icon(Icons.format_strikethrough),
            onPressed: () => toggleAttributions('strikethrough'),
          ),
        ),
        Transform.scale(
          scale: 0.8,
          child: IconButton(
            padding: EdgeInsets.all(2.0),
            icon: Icon(Icons.format_quote),
            onPressed: () => toggleAttributions('blockquote'),
          ),
        ),
        Transform.scale(
          scale: 0.8,
          child: IconButton(
            padding: EdgeInsets.all(2.0),
            icon: Icon(Icons.format_underline),
            onPressed: () => toggleAttributions('underline'),
          ),
        ),
        Transform.scale(
          scale: 0.8,
          child: IconButton(
            padding: EdgeInsets.all(2.0),
            icon: Icon(Icons.format_list_bulleted),
            onPressed: () => addList(ordered: false),
          ),
        ),
        Transform.scale(
          scale: 0.8,
          child: IconButton(
            padding: EdgeInsets.all(2.0),
            icon: Icon(Icons.format_list_numbered),
            onPressed: () => addList(ordered: true),
          ),
        ),
        Transform.scale(
          scale: 0.8,
          child: IconButton(
            padding: EdgeInsets.all(2.0),
            icon: Icon(Icons.horizontal_rule),
            onPressed: addHorizontalRule,
          ),
        ),
        Transform.scale(
          scale: 0.8,
          child: IconButton(
            padding: EdgeInsets.all(2.0),
            icon: Icon(Icons.image),
            onPressed: addHorizontalRule,
          ),
        ),
        TextButton(
          onPressed: () => toggleAttributions('header1'),
          child: Text(
            'H1',
            style: TextStyle(color: Colors.black),
          ),
        ),
        TextButton(
          onPressed: () => toggleAttributions('header2'),
          child: Text(
            'H2',
            style: TextStyle(color: Colors.black),
          ),
        ),
        TextButton(
          onPressed: () => toggleAttributions('header3'),
          child: Text(
            'H3',
            style: TextStyle(color: Colors.black),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(60);
}
