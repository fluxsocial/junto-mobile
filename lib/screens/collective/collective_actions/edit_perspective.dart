import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/app/logger/logger.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/collective/collective_actions/edit_perspective_add_members.dart';
import 'package:junto_beta_mobile/screens/collective/perspectives/bloc/perspectives_bloc.dart';
import 'package:junto_beta_mobile/widgets/perspective_textfield.dart';
import 'package:junto_beta_mobile/utils/junto_exception.dart'
    show JuntoException;
import 'package:junto_beta_mobile/utils/junto_overlay.dart';
import 'package:junto_beta_mobile/widgets/previews/member_preview/member_preview_deselect.dart';
import 'package:provider/provider.dart';

class EditPerspective extends StatefulWidget {
  const EditPerspective({this.perspective});

  final PerspectiveModel perspective;

  @override
  State<StatefulWidget> createState() {
    return EditPerspectiveState();
  }
}

class EditPerspectiveState extends State<EditPerspective> {
  TextEditingController _nameController;
  TextEditingController _aboutController;
  PageController _pageController;
  int _currentIndex = 0;

  // ignore: unused_field
  List<UserProfile> _perspectiveMembers = <UserProfile>[];

  Future<List<UserProfile>> getPerspectiveMembers;

  void _refreshPerspectiveMembers() {
    setState(() {
      getPerspectiveMembers =
          _fetchPerspectiveMembers(widget.perspective.address);
    });
  }

  Future<List<UserProfile>> _fetchPerspectiveMembers(String address) async {
    try {
      logger.logDebug('getting users');
      final List<UserProfile> _members =
          await Provider.of<UserRepo>(context, listen: false)
              .getPerspectiveUsers(address);
      setState(() {
        _perspectiveMembers = _members;
      });

      return _members;
    } on JuntoException catch (e, s) {
      logger.logException(e, s, 'error fethcing perspectives ${e.errorCode}');
      return null;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _refreshPerspectiveMembers();
  }

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.perspective.name);
    _aboutController = TextEditingController(text: widget.perspective.about);
    _pageController = PageController(initialPage: 0);
  }

  Future<void> _removeMemberFromPerspective(
      List<Map<String, String>> userAddresses,
      String perspectiveAddress) async {
    JuntoLoader.showLoader(context);
    try {
      await Provider.of<UserRepo>(context, listen: false)
          .deleteUsersFromPerspective(userAddresses, perspectiveAddress);
      _refreshPerspectiveMembers();
      JuntoLoader.hide();
    } catch (e, s) {
      logger.logException(e, s);
      JuntoLoader.hide();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(45),
            child: AppBar(
              automaticallyImplyLeading: false,
              iconTheme: IconThemeData(
                color: Theme.of(context).primaryColor,
              ),
              backgroundColor: Theme.of(context).backgroundColor,
              elevation: 0,
              titleSpacing: 0,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(1),
                child: Container(
                  height: .75,
                  width: MediaQuery.of(context).size.width,
                  color: Theme.of(context).dividerColor,
                ),
              ),
              title: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        if (_currentIndex == 0) {
                          Navigator.pop(context);
                        } else if (_currentIndex == 1) {
                          _pageController.previousPage(
                            curve: Curves.easeIn,
                            duration: const Duration(milliseconds: 300),
                          );
                        }
                      },
                      child: Container(
                        height: 45,
                        width: 45,
                        color: Colors.transparent,
                        alignment: Alignment.centerLeft,
                        child: Icon(CustomIcons.back, size: 20),
                      ),
                    ),
                    Text(_currentIndex == 0 ? 'Edit Perspective' : 'Members',
                        style: Theme.of(context).textTheme.subtitle1),
                    _currentIndex == 0
                        ? GestureDetector(
                            onTap: () async {
                              final Map<String, String> updatedPerspective =
                                  <String, String>{
                                if (_nameController.value.text !=
                                        widget.perspective.name &&
                                    _nameController.value.text != '')
                                  'name': _nameController.value.text,
                                if (_aboutController.value.text !=
                                        widget.perspective.about &&
                                    _nameController.value.text != '')
                                  'about': _aboutController.value.text
                              };

                              if (_nameController.value.text ==
                                      widget.perspective.name &&
                                  _aboutController.value.text ==
                                      widget.perspective.about &&
                                  _nameController.value.text != '' &&
                                  _aboutController.value.text != '') {
                                return;
                              } else {
                                JuntoLoader.showLoader(context);

                                await Provider.of<UserRepo>(context,
                                        listen: false)
                                    .updatePerspective(
                                        widget.perspective.address,
                                        updatedPerspective);
                                JuntoLoader.hide();
                                //TODO: edit in bloc
                                context
                                    .bloc<PerspectivesBloc>()
                                    .add(FetchPerspectives());
                                Navigator.pop(context);
                              }
                            },
                            child: Container(
                              height: 45,
                              width: 45,
                              color: Colors.transparent,
                              alignment: Alignment.centerRight,
                              child: Text(
                                'Save',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                          )
                        : GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                CupertinoPageRoute<dynamic>(
                                  builder: (BuildContext context) =>
                                      EditPerspectiveAddMembers(
                                    perspective: widget.perspective,
                                    refreshPerspectiveMembers:
                                        _refreshPerspectiveMembers,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              height: 45,
                              width: 45,
                              color: Colors.transparent,
                              alignment: Alignment.centerRight,
                              child: Icon(
                                Icons.add,
                                size: 24,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ),
          body: PageView(
            controller: _pageController,
            onPageChanged: (int index) {
              setState(() {
                _currentIndex = index;
              });
            },
            children: <Widget>[
              Container(
                child: ListView(
                  children: <Widget>[
                    PerspectiveTextField(
                      name: 'Name',
                      controller: _nameController,
                      textInputActionType: TextInputAction.next,
                    ),
                    PerspectiveTextField(
                      name: 'About',
                      controller: _aboutController,
                      textInputActionType: TextInputAction.done,
                    ),
                    GestureDetector(
                      onTap: () {
                        _pageController.nextPage(
                          curve: Curves.easeIn,
                          duration: const Duration(milliseconds: 300),
                        );
                      },
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 15,
                          ),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Theme.of(context).dividerColor,
                                width: .5,
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Manage Members',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Icon(
                                Icons.keyboard_arrow_right,
                                size: 17,
                                color: Theme.of(context).primaryColor,
                              )
                            ],
                          )),
                    )
                  ],
                ),
              ),
              FutureBuilder<List<UserProfile>>(
                future: getPerspectiveMembers,
                builder: (
                  BuildContext context,
                  AsyncSnapshot<List<UserProfile>> snapshot,
                ) {
                  if (snapshot.hasError) {
                    logger.logError(snapshot.error);
                    return Container(
                      child: const Text(
                        'hmm, something is up...',
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                    );
                  }
                  if (snapshot.hasData) {
                    return ListView(
                      children: snapshot.data
                          .map(
                            (UserProfile user) => MemberPreviewDeselect(
                                profile: user,
                                onDeselect: () {
                                  _removeMemberFromPerspective(
                                      <Map<String, String>>[
                                        <String, String>{
                                          'user_address': user.address
                                        }
                                      ],
                                      widget.perspective.address);
                                }),
                          )
                          .toList(),
                    );
                  }
                  return const Center(
                    child: Text('pending'),
                  );
                },
              )
            ],
          )),
    );
  }
}
