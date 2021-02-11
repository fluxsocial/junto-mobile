import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/models/group_model.dart';
import 'package:junto_beta_mobile/screens/create/create_actions/widgets/create_choose_context.dart';
import 'package:junto_beta_mobile/screens/groups/circles/bloc/circle_bloc.dart';
import 'package:junto_beta_mobile/utils/junto_overlay.dart';
import 'package:junto_beta_mobile/widgets/previews/circle_preview/circle_preview.dart';

class CreateContextOverlay extends StatefulWidget {
  CreateContextOverlay({
    this.currentExpressionContext = ExpressionContext.Collective,
    this.selectExpressionContext,
    this.toggleSocialContextVisibility,
    this.selectedGroup,
    this.setSelectedGroup,
  });

  final ExpressionContext currentExpressionContext;
  final Function selectExpressionContext;
  final Function toggleSocialContextVisibility;
  final Group selectedGroup;
  final Function(Group) setSelectedGroup;

  @override
  _CreateContextOverlayState createState() => _CreateContextOverlayState();
}

class _CreateContextOverlayState extends State<CreateContextOverlay> {
  PageController _controller;
  int _currentIndex = 0;

  @override
  initState() {
    super.initState();
    _controller = PageController(
      initialPage: 0,
    );
  }

  @override
  dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.black.withOpacity(.7),
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).backgroundColor,
              borderRadius: BorderRadius.circular(15),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 25),
            height: MediaQuery.of(context).size.height * .5,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(
                    top: 25,
                    left: 10,
                    right: 10,
                  ),
                  child: Text(
                    _currentIndex == 0
                        ? 'Where would you like to share?'
                        : 'Select a Group',
                    style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Expanded(
                  child: PageView(
                    controller: _controller,
                    onPageChanged: (int index) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                    children: [
                      ListView(
                        padding: const EdgeInsets.only(
                          top: 25,
                        ),
                        children: [
                          ChooseExpressionContext(
                            expressionContext: ExpressionContext.Collective,
                            currentExpressionContext:
                                widget.currentExpressionContext,
                            selectExpressionContext:
                                widget.selectExpressionContext,
                          ),
                          ChooseExpressionContext(
                            expressionContext: ExpressionContext.MyPack,
                            currentExpressionContext:
                                widget.currentExpressionContext,
                            selectExpressionContext:
                                widget.selectExpressionContext,
                          ),
                          ChooseExpressionContext(
                            expressionContext:
                                ExpressionContext.CommunityCenter,
                            currentExpressionContext:
                                widget.currentExpressionContext,
                            selectExpressionContext:
                                widget.selectExpressionContext,
                          ),
                          ChooseExpressionContext(
                            expressionContext: ExpressionContext.Group,
                            currentExpressionContext:
                                widget.currentExpressionContext,
                            selectExpressionContext:
                                widget.selectExpressionContext,
                            group: widget.selectedGroup,
                            gotoGroupSelection: () {
                              _controller.jumpToPage(1);
                            },
                          ),
                        ],
                      ),
                      BlocBuilder<CircleBloc, CircleState>(
                        builder: (context, state) {
                          if (state is CircleLoaded) {
                            return Container(
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              child: ListView.builder(
                                itemCount: state.groups.length,
                                itemBuilder: (context, index) =>
                                    GestureDetector(
                                  onTap: () {
                                    _controller.jumpToPage(0);
                                    widget
                                        .setSelectedGroup(state.groups[index]);
                                    // Navigator.pop(context);
                                    // widget.toggleSocialContextVisibility(false);
                                  },
                                  child: CirclePreview(
                                    group: state.groups[index],
                                  ),
                                ),
                              ),
                            );
                          }

                          return JuntoLoader();
                        },
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    widget.toggleSocialContextVisibility(false);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(25),
                    color: Colors.transparent,
                    alignment: Alignment.center,
                    child: Text(
                      'CLOSE',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
