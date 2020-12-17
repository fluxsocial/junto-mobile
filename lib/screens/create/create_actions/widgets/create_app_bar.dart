import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';

class CreateAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CreateAppBar({
    Key key,
    @required this.closeCreate,
    @required this.togglePageView,
    @required this.currentIndex,
  }) : super(key: key);

  final Function closeCreate;
  final Function togglePageView;
  final int currentIndex;

  Map<String, Widget> _buildAppBarWidgets(BuildContext context) {
    Widget backWidget;
    Widget ctaWidget;
    switch (currentIndex) {
      case 0:
        backWidget = GestureDetector(
          onTap: () {
            closeCreate();
            // if (expressionHasData()) {
            //   showDialog(
            //     context: context,
            //     builder: (BuildContext context) => ConfirmDialog(
            //       confirmationText:
            //           'Are you sure you want to leave this screen? Your expression will not be saved.',
            //       confirm: () {
            //         Navigator.pop(context);
            //       },
            //     ),
            //   );
            // } else {
            //   Navigator.pop(context);
            // }
          },
          child: Container(
            color: Colors.transparent,
            width: 28,
            child: Image.asset(
              'assets/images/junto-mobile__cancel.png',
              height: 15,
              color: Theme.of(context).primaryColor,
            ),
          ),
        );
        ctaWidget = CreateCTAButton(
          cta: () {
            togglePageView(1);
          },
          title: 'Next',
        );

        break;
      case 1:
        backWidget = GestureDetector(
          onTap: () {
            togglePageView(0);
          },
          child: Container(
              color: Colors.transparent,
              width: 28,
              child: Icon(
                CustomIcons.back,
                size: 20,
                color: Theme.of(context).primaryColor,
              )),
        );
        ctaWidget = CreateCTAButton(
          cta: () {
            // Create Expression
          },
          title: 'Create',
        );
        break;
      default:
        backWidget = GestureDetector(
          onTap: () {
            togglePageView(0);
          },
          child: Container(
              color: Colors.transparent,
              width: 28,
              child: Icon(
                CustomIcons.back,
                size: 20,
                color: Theme.of(context).primaryColor,
              )),
        );
        ctaWidget = CreateCTAButton(
          cta: () {
            togglePageView(1);
          },
          title: 'Next',
        );
        break;
    }
    return {
      'back_widget': backWidget,
      'cta_widget': ctaWidget,
    };
  }

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(45),
      child: AppBar(
        brightness: Theme.of(context).brightness,
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(
          color: Theme.of(context).primaryColor,
        ),
        elevation: 0,
        titleSpacing: 0,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(.75),
          child: Container(
            height: .75,
            color: Theme.of(context).dividerColor,
            width: MediaQuery.of(context).size.width,
          ),
        ),
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _buildAppBarWidgets(context)['back_widget'],
              _buildAppBarWidgets(context)['cta_widget'],
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(45);
}

class CreateCTAButton extends StatelessWidget {
  const CreateCTAButton({
    this.cta,
    this.title,
  });

  final Function cta;
  final String title;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: cta,
      child: Container(
        padding: const EdgeInsets.only(
          left: 10,
          right: 10,
          top: 5,
          bottom: 5,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
