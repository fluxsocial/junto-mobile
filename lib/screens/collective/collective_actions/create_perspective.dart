import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/collective/collective_actions/perspective_body.dart';
import 'package:junto_beta_mobile/screens/collective/perspectives/bloc/perspectives_bloc.dart';
import 'package:junto_beta_mobile/widgets/dialogs/confirm_dialog.dart';
import 'package:junto_beta_mobile/widgets/dialogs/single_action_dialog.dart';
import 'package:junto_beta_mobile/widgets/perspective_textfield.dart';
import 'package:junto_beta_mobile/widgets/progress_indicator.dart';
import 'package:junto_beta_mobile/widgets/tab_bar.dart';
import 'package:provider/provider.dart';

class CreatePerspectivePage extends StatefulWidget {
  const CreatePerspectivePage();

  @override
  State<StatefulWidget> createState() => CreatePerspectivePageState();
}

class CreatePerspectivePageState extends State<CreatePerspectivePage> {
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
    _nameController.dispose();
    _aboutController.dispose();
    _pageController.dispose();
    super.dispose();
  }

// Checks the name and about fields before moving on to the next page.
  void _canCreatePerspective() {
    FocusScope.of(context).unfocus();
    if (_aboutController.value.text.isNotEmpty ||
        _nameController.value.text.isNotEmpty) {
      _pageController.nextPage(
        curve: Curves.easeIn,
        duration: const Duration(milliseconds: 300),
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) => const SingleActionDialog(
          dialogText: 'Please fill in all the fields.',
        ),
      );
    }
  }

  void _onBackTap() {
    if (_currentIndex == 0) {
      Navigator.pop(context);
    } else {
      _pageController.previousPage(
        curve: Curves.easeIn,
        duration: const Duration(milliseconds: 300),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PerspectivesBloc, PerspectivesState>(
      listener: (context, state) {
        if (state is PerspectivesError) {
          showDialog(
            context: context,
            builder: (BuildContext context) => ConfirmDialog(
              buildContext: context,
              confirmationText: 'Could not create perspective',
              confirm: () => Navigator.pop(context),
            ),
          );
        }
        if (state is PerspectivesFetched) {
          Navigator.of(context).pop();
        }
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(45),
            child: PerspectivesAppBar(
              onBackTap: _onBackTap,
              currentIndex: _currentIndex,
              onNextTap: _canCreatePerspective,
              onCreateTap: () {
                context.bloc<PerspectivesBloc>().add(
                      CreatePerspective(
                        _nameController.text,
                        _aboutController.text,
                        _perspectiveMembers,
                      ),
                    );
              },
            ),
          ),
          body: BlocBuilder<PerspectivesBloc, PerspectivesState>(
            builder: (context, state) {
              if (state is PerspectivesFetched) {
                return PerspectivesPageView(
                  pageController: _pageController,
                  formKey: _formKey,
                  nameController: _nameController,
                  aboutController: _aboutController,
                  tabs: _tabs,
                  perspectiveMembers: _perspectiveMembers,
                  onPageChanged: (int index) => setState(
                    () => _currentIndex = index,
                  ),
                );
              }
              if (state is PerspectivesLoading) {
                return Center(child: JuntoProgressIndicator());
              }
              if (state is PerspectivesError) {}
              return Container();
            },
          ),
        ),
      ),
    );
  }
}

class PerspectivesPageView extends StatefulWidget {
  const PerspectivesPageView({
    Key key,
    @required this.pageController,
    @required this.formKey,
    @required this.nameController,
    @required this.aboutController,
    @required this.tabs,
    @required this.perspectiveMembers,
    @required this.onPageChanged,
  }) : super(key: key);

  final PageController pageController;
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController aboutController;
  final List<String> tabs;
  final List<String> perspectiveMembers;
  final Function(int) onPageChanged;

  @override
  _PerspectivesPageViewState createState() => _PerspectivesPageViewState();
}

class _PerspectivesPageViewState extends State<PerspectivesPageView> {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserRepo>(
      builder: (context, data, child) {
        return PageView(
          onPageChanged: widget.onPageChanged,
          physics: const NeverScrollableScrollPhysics(),
          controller: widget.pageController,
          children: <Widget>[
            Column(
              children: <Widget>[
                Expanded(
                  child: Form(
                    key: widget.formKey,
                    child: ListView(
                      children: <Widget>[
                        PerspectiveTextField(
                          name: 'Perspective Name',
                          controller: widget.nameController,
                          textInputActionType: TextInputAction.next,
                        ),
                        PerspectiveTextField(
                          name: 'About',
                          controller: widget.aboutController,
                          textInputActionType: TextInputAction.done,
                        ),
                      ],
                    ),
                    autovalidate: false,
                  ),
                ),
              ],
            ),
            DefaultTabController(
              length: widget.tabs.length,
              child: NestedScrollView(
                physics: const ClampingScrollPhysics(),
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[_Header(tabs: widget.tabs)];
                },
                body: Provider.value(
                  value: widget.perspectiveMembers,
                  child: CreatePerspectiveBody(
                    future: data.userRelations(),
                    removeUser: (UserProfile user) {
                      setState(() {
                        widget.perspectiveMembers.remove(user.address);
                      });
                    },
                    addUser: (UserProfile user) {
                      setState(() {
                        widget.perspectiveMembers.add(user.address);
                      });
                    },
                  ),
                ),
              ),
            )
          ],
        );
      },
    );
  }
}

class PerspectivesAppBar extends StatelessWidget {
  const PerspectivesAppBar({
    Key key,
    @required this.currentIndex,
    @required this.onBackTap,
    @required this.onNextTap,
    @required this.onCreateTap,
  }) : super(key: key);

  final int currentIndex;
  final VoidCallback onBackTap;
  final VoidCallback onNextTap;
  final VoidCallback onCreateTap;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      iconTheme: IconThemeData(
        color: Theme.of(context).primaryColor,
      ),
      brightness: Theme.of(context).brightness,
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
              onTap: onBackTap,
              child: Container(
                height: 45,
                width: 45,
                color: Colors.transparent,
                alignment: Alignment.centerLeft,
                child: Icon(CustomIcons.back, size: 20),
              ),
            ),
            if (currentIndex == 0)
              Text('New Perspective',
                  style: Theme.of(context).textTheme.subtitle1),
            if (currentIndex == 1)
              GestureDetector(
                onTap: onCreateTap,
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
            if (currentIndex != 1)
              GestureDetector(
                onTap: onNextTap,
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
