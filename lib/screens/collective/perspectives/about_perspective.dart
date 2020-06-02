import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/collective/bloc/collective_bloc.dart';

// This component is used in CommentPreview
// as the 'more' icon is pressed to view the action items
class AboutPerspective extends StatelessWidget {
  const AboutPerspective();

  @override
  Widget build(BuildContext context) {
    final perspective = context.bloc<CollectiveBloc>().currentPerspective;

    return Container(
      color: Colors.transparent,
      child: Container(
        height: MediaQuery.of(context).size.height * .9,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            AboutPerspectiveAppBar(perspective: perspective),
            AboutPerspectiveDescription(
              perspective: perspective,
            ),
            AboutPerspectiveMembers(
              perspective: perspective,
            ),
            Expanded(
              child: Container(
                color: Colors.transparent,
              ),
            ),
            AboutPerspectiveEdit(
              perspective: perspective,
            ),
          ],
        ),
      ),
    );
  }
}

class AboutPerspectiveAppBar extends StatelessWidget {
  AboutPerspectiveAppBar({this.perspective});
  final PerspectiveModel perspective;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 15,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
            width: .75,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            height: 38,
            width: 38,
            child: Icon(
              Icons.keyboard_arrow_down,
              size: 24,
              color: Theme.of(context).primaryColor,
            ),
          ),
          Text(
            perspective.name,
            style: Theme.of(context).textTheme.subtitle1,
          ),
          SizedBox(width: 38),
        ],
      ),
    );
  }
}

class AboutPerspectiveName extends StatelessWidget {
  AboutPerspectiveName({this.perspective});
  final PerspectiveModel perspective;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 15,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
            width: .75,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            perspective.name,
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ],
      ),
    );
  }
}

class AboutPerspectiveDescription extends StatelessWidget {
  AboutPerspectiveDescription({this.perspective});
  final PerspectiveModel perspective;

  String _aboutText() {
    if (perspective.name == 'JUNTO') {
      return 'Expressions from everyone on Junto.';
    } else if (perspective.name == 'Connections') {
      return 'Expressions from people you are connected with.';
    } else if (perspective.name == 'Subscriptions') {
      'Expressions from specific people you are subscribed to.';
    } else if (perspective.about.isEmpty && !perspective.isDefault) {
      return 'Edit to add a description.';
    } else {
      return perspective.about;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 15,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
            width: .75,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'ABOUT',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).primaryColorLight,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            _aboutText(),
            style: TextStyle(
              fontSize: 15,
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class AboutPerspectiveMembers extends StatelessWidget {
  AboutPerspectiveMembers({this.perspective});
  final PerspectiveModel perspective;

  String _membersCountText() {
    if (perspective.name == 'JUNTO' && perspective.isDefault == true) {
      return 'All Members';
    } else if (perspective.userCount == 1) {
      return perspective.userCount.toString() + ' Member';
    } else {
      perspective.userCount.toString() + ' Members';
    }
    return 'All Members';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 15,
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Theme.of(context).dividerColor,
              width: .75,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              _membersCountText(),
              style: TextStyle(
                fontSize: 15,
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            Icon(
              Icons.keyboard_arrow_right,
              color: Theme.of(context).primaryColorLight,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class AboutPerspectiveEdit extends StatelessWidget {
  AboutPerspectiveEdit({this.perspective});
  final PerspectiveModel perspective;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 15,
          ),
          margin: const EdgeInsets.only(bottom: 15),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Theme.of(context).dividerColor,
                width: .75,
              ),
              bottom: BorderSide(
                color: Theme.of(context).dividerColor,
                width: .75,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'EDIT',
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).primaryColorLight,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
