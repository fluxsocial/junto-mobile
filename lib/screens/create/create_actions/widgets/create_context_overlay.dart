import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/models/group_model.dart';
import 'package:junto_beta_mobile/screens/groups/circles/bloc/circle_bloc.dart';
import 'package:junto_beta_mobile/utils/junto_overlay.dart';
import 'package:junto_beta_mobile/widgets/previews/circle_preview/circle_preview.dart';
import 'package:junto_beta_mobile/widgets/previews/circle_preview/collective_preview.dart';

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
                    'Choose a Community',
                    style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                SizedBox(height: 12.5),
                Expanded(
                  child: BlocBuilder<CircleBloc, CircleState>(
                      builder: (context, state) {
                    if (state is CircleLoaded) {
                      return Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 15.0,
                        ),
                        child: ListView(
                          padding: EdgeInsets.all(0),
                          children: [
                            CollectivePreview(
                              callback: () {
                                // Select Collective Group
                              },
                            ),
                            ListView.builder(
                              padding: EdgeInsets.all(0),
                              shrinkWrap: true,
                              physics: ClampingScrollPhysics(),
                              itemCount: state.groups.length,
                              itemBuilder: (context, index) => GestureDetector(
                                onTap: () {
                                  widget.setSelectedGroup(state.groups[index]);
                                },
                                child: CirclePreview(
                                  group: state.groups[index],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return JuntoLoader();
                  }),
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
