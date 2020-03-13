import 'package:async/async.dart' show AsyncMemoizer;
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/collective/collective_actions/perspective_body.dart';
import 'package:junto_beta_mobile/utils/junto_exception.dart'
    show JuntoException;
import 'package:junto_beta_mobile/utils/junto_overlay.dart';
import 'package:junto_beta_mobile/widgets/perspective_textfield.dart';
import 'package:junto_beta_mobile/widgets/tab_bar.dart';
import 'package:junto_beta_mobile/widgets/dialogs/single_action_dialog.dart';
import 'package:provider/provider.dart';

class CreatePerspective extends StatefulWidget {
  const CreatePerspective({this.refreshPerspectives});

  final VoidCallback refreshPerspectives;

  @override
  State<StatefulWidget> createState() => CreatePerspectiveState();
}

class CreatePerspectiveState extends State<CreatePerspective> {
  TextEditingController _nameController;
  TextEditingController _aboutController;
  PageController _pageController;
  GlobalKey<FormState> _formKey;
  int _currentIndex = 0;
  final List<String> _tabs = <String>['Subscriptions', 'Connections'];
  final List<String> _perspectiveMembers = <String>[];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _aboutController = TextEditingController();
    _pageController = PageController(initialPage: 0);
    _formKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    _formKey = null;
    super.dispose();
  }

  final AsyncMemoizer<Map<String, dynamic>> _memoizer =
      AsyncMemoizer<Map<String, dynamic>>();

  Future<Map<String, dynamic>> getUserRelationships() async {
    return _memoizer.runOnce(
      () => Provider.of<UserRepo>(context, listen: false).userRelations(),
    );
  }

// Checks the name and about fields before moving on to the next page.
  void _canCreatePerspective() {
    if (_formKey.currentState.validate()) {
      _pageController.nextPage(
        curve: Curves.easeIn,
        duration: const Duration(milliseconds: 300),
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) => const SingleActionDialog(
            dialogText: 'Please fill in all the fields.'),
      );
    }
  }

// Extracts the name and about text then tries creating a perspective while the
// Junto loader is shown.
  Future<void> _createPerspective() async {
    final String name = _nameController.value.text;
    final String about = _aboutController.value.text;
    JuntoLoader.showLoader(context);
    try {
      await Provider.of<UserRepo>(context, listen: false).createPerspective(
        Perspective(
          name: name,
          members: _perspectiveMembers,
          about: about,
        ),
      );
      JuntoLoader.hide();
      widget.refreshPerspectives();
      Navigator.pop(context);
    } on JuntoException catch (error, stacktrace) {
      print(error);
      print(stacktrace);
      JuntoLoader.hide();
      showDialog(
        context: context,
        builder: (BuildContext context) => SingleActionDialog(
          dialogText: error.message,
        ),
      );
    }
  }

  void _onTap() {
    if (_currentIndex == 0) {
      Navigator.pop(context);
      return;
    }
    if (_currentIndex != 0) {
      _pageController.previousPage(
        curve: Curves.easeIn,
        duration: const Duration(milliseconds: 300),
      );
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  onTap: _onTap,
                  child: Container(
                    height: 45,
                    width: 45,
                    color: Colors.transparent,
                    alignment: Alignment.centerLeft,
                    child: Icon(CustomIcons.back, size: 20),
                  ),
                ),
                if (_currentIndex == 0)
                  Text('New Perspective',
                      style: Theme.of(context).textTheme.subtitle1),
                if (_currentIndex == 1)
                  GestureDetector(
                    onTap: _createPerspective,
                    child: Container(
                      height: 45,
                      width: 45,
                      color: Colors.transparent,
                      alignment: Alignment.centerRight,
                      child: Text(
                        'create',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ),
                if (_currentIndex != 1)
                  GestureDetector(
                    onTap: _canCreatePerspective,
                    child: Container(
                      height: 45,
                      width: 45,
                      color: Colors.transparent,
                      alignment: Alignment.centerRight,
                      child: Text(
                        'next',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
      body: PageView(
        onPageChanged: (int index) => setState(() => _currentIndex = index),
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageController,
        children: <Widget>[
          Column(
            children: <Widget>[
              Expanded(
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: <Widget>[
                      const SizedBox(height: 10),
                      PerspectiveTextField(
                        name: 'Name Perspective',
                        controller: _nameController,
                      ),
                      const SizedBox(height: 10),
                      PerspectiveTextField(
                        name: 'About',
                        controller: _aboutController,
                      ),
                    ],
                  ),
                  autovalidate: false,
                ),
              ),
            ],
          ),
          DefaultTabController(
            length: _tabs.length,
            child: NestedScrollView(
              physics: const ClampingScrollPhysics(),
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[_Header(tabs: _tabs)];
              },
              body: CreatePerspectiveBody(
                future: getUserRelationships(),
                removeUser: (UserProfile user) {
                  _perspectiveMembers.remove(user.address);
                },
                addUser: (UserProfile user) {
                  _perspectiveMembers.add(user.address);
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}

/// Builder header section using [SliverPersistentHeader]
class _Header extends StatelessWidget {
  const _Header({
    Key key,
    @required this.tabs,
  }) : super(key: key);
  final List<String> tabs;

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      delegate: JuntoAppBarDelegate(
        TabBar(
          labelPadding: const EdgeInsets.all(0),
          isScrollable: true,
          labelColor: Theme.of(context).primaryColorDark,
          labelStyle: Theme.of(context).textTheme.subtitle1,
          indicatorWeight: 0.0001,
          tabs: <Widget>[
            for (String name in tabs)
              Container(
                margin: const EdgeInsets.only(right: 24),
                color: Theme.of(context).colorScheme.background,
                child: Tab(
                  text: name,
                ),
              ),
          ],
        ),
      ),
      pinned: true,
    );
  }
}
