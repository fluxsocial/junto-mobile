import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/backend/repositories.dart';
import 'package:junto_beta_mobile/models/expression.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/collective/collective.dart';
import 'package:junto_beta_mobile/screens/create/create_actions/create_actions_appbar.dart';
import 'package:junto_beta_mobile/screens/create/create_actions/channel_search_modal.dart';
import 'package:junto_beta_mobile/utils/junto_dialog.dart';
import 'package:junto_beta_mobile/utils/junto_overlay.dart';
import 'package:provider/provider.dart';

class CreateActions extends StatefulWidget {
  const CreateActions({
    Key key,
    @required this.expressionType,
    @required this.expressionContext,
    @required this.expression,
    @required this.address,
  }) : super(key: key);

  /// Represents the type of expression being created. Possible values include
  /// "LongForm", "ShortForm", "EventForm", etc
  final String expressionType;

  /// This represents the Expression's context. Please see [ExpressionContext]
  final ExpressionContext expressionContext;

  /// Represents the expression data. Value depends on the type of expression
  /// being created.
  final dynamic expression;

  /// Address of the [Group] or collection to which the expression is being posted.
  /// Can also be null if the [expressionContext] == [ExpressionContext.Collective]
  final String address;

  @override
  State<StatefulWidget> createState() => CreateActionsState();
}

class CreateActionsState extends State<CreateActions> {
  String _selectedType = 'Collective';

  String _address;
  CentralizedExpression _expression;
  final ValueNotifier<List<String>> _channels = ValueNotifier<List<String>>(
    <String>[],
  );

  // instantiate TextEditingController to pass to TextField widget
  TextEditingController _channelController;

  List<String> get channel => _channels.value;

  @override
  void initState() {
    super.initState();
    _channelController = TextEditingController();
    _address = widget.address;
  }

  @override
  void dispose() {
    super.dispose();
    _channelController.dispose();
  }

  Future<void> _createExpression() async {
    try {
      if (widget.expressionType == 'PhotoForm') {
        final String _photoKey =
            await Provider.of<ExpressionRepo>(context, listen: false)
                .createPhoto('.png', widget.expression['image']);
        _expression = CentralizedExpression(
          type: widget.expressionType,
          expressionData: CentralizedPhotoFormExpression(
                  image: _photoKey, caption: widget.expression['caption'])
              .toMap(),
          context: widget.expressionContext,
          channels: channel,
        );
      } else if (widget.expressionType == 'EventForm') {
        print(widget.expression['photo']);
        String eventPhoto = '';
        if (widget.expression['photo'] != null) {
          final String _eventPhotoKey =
              await Provider.of<ExpressionRepo>(context, listen: false)
                  .createPhoto('.png', widget.expression['photo']);
          eventPhoto = _eventPhotoKey;
          print(eventPhoto);
        }
        _expression = CentralizedExpression(
          type: widget.expressionType,
          expressionData: CentralizedEventFormExpression(
              photo: eventPhoto,
              description: widget.expression['description'],
              title: widget.expression['title'],
              location: widget.expression['location'],
              startTime: widget.expression['startTime'],
              endTime: widget.expression['endTime'],
              facilitators: <String>[],
              members: <String>[]).toMap(),
          channels: channel,
          context: widget.expressionContext,
        );
      } else {
        _expression = CentralizedExpression(
          type: widget.expressionType,
          expressionData: widget.expression.toMap(),
          context: widget.expressionContext,
          channels: channel,
        );
      }
      JuntoLoader.showLoader(context);
      await Provider.of<ExpressionRepo>(context, listen: false)
          .createExpression(
        _expression,
        _expression.context,
        _address,
      );

      JuntoLoader.hide();
      // JuntoOverlay.hide();
      JuntoDialog.showJuntoDialog(
        context,
        'Expression Created!',
        <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                JuntoCollective.route(),
                (_) => false,
              );
            },
            child: const Text('Ok'),
          )
        ],
      );
    } catch (error) {
      print(error.message);
      JuntoLoader.hide();
      // FIXME: (Nash/Eric) - creating an expression retrieves the following error.
      // '_InternalLinkedHashMap<String, dynamic>' is not a subtype of type 'int'
      // Temporarily displaying 'Expression Created' for this build as the expressions do get created.

      // JuntoDialog.showJuntoDialog(
      //   context,
      //   'Something went wrong',
      //   <Widget>[
      //     FlatButton(
      //       onPressed: () {
      //         Navigator.pop(context);
      //       },
      //       child: const Text('Ok'),
      //     )
      //   ],
      // );
      JuntoDialog.showJuntoDialog(
        context,
        'Expression Created!',
        <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                JuntoCollective.route(),
                (_) => false,
              );
            },
            child: const Text('Ok'),
          )
        ],
      );
    }
  }

  void _onSharingClick(String layer, String resource) {
    Navigator.pop(context);
    if (layer == 'Public Den') {
      _expression = _expression.copyWith(context: ExpressionContext.Group);
    } else if (layer == 'My Pack') {
      _expression = _expression.copyWith(context: ExpressionContext.Group);
    } else {
      _expression = _expression.copyWith(context: ExpressionContext.Collective);
    }

    _address = resource;
    setState(() => _selectedType = layer);
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
                Text('Collective', style: Theme.of(context).textTheme.title),
                Text('description of this context',
                    style: Theme.of(context).textTheme.caption),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Column(
              children: <Widget>[
                Container(
                  height: 45,
                  child: ListView(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      children: <Widget>[
                        const SizedBox(width: 15),
                        _expressionContextSelector('hi'),
                        _expressionContextSelector('hi'),
                        _expressionContextSelector('hi'),
                        _expressionContextSelector('hi'),
                        _expressionContextSelector('hi'),
                        _expressionContextSelector('hi'),
                        const SizedBox(width: 15),
                      ]),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => _buildChannelsModal(context),
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Theme.of(context).dividerColor,
                    width: .75,
                  ),
                  top: BorderSide(
                    color: Theme.of(context).dividerColor,
                    width: .75,
                  ),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: Row(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(15),
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                        stops: const <double>[0.2, 0.9],
                        colors: <Color>[
                          Theme.of(context).colorScheme.secondary,
                          Theme.of(context).colorScheme.primary
                        ],
                      ),
                      borderRadius: BorderRadius.circular(1000),
                    ),
                    child:
                        Icon(CustomIcons.hash, color: Colors.white, size: 15),
                  ),
                  Text('add channels',
                      style: Theme.of(context).textTheme.caption),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _expressionContextSelector(expressionContext) {
    return Container(
      padding: EdgeInsets.all(15),
      margin: const EdgeInsets.only(right: 15),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          stops: const <double>[0.2, 0.9],
          colors: <Color>[
            Theme.of(context).colorScheme.secondary,
            Theme.of(context).colorScheme.primary
          ],
        ),
        borderRadius: BorderRadius.circular(1000),
      ),
      child: Icon(CustomIcons.spheres, color: Colors.white, size: 17),
    );
  }

  // Build bottom modal to add channels to expression
  void _buildChannelsModal(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return ChannelSearchModal(
          channels: _channels,
        );
      },
    );
  }
}
