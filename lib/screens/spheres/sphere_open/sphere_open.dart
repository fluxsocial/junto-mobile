import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/expression.dart';
import 'package:junto_beta_mobile/models/group_model.dart';
import 'package:junto_beta_mobile/models/sphere.dart';
import 'package:junto_beta_mobile/models/user_model.dart';
import 'package:junto_beta_mobile/palette.dart';
import 'package:junto_beta_mobile/providers/provider.dart';
import 'package:junto_beta_mobile/screens/spheres/sphere_members.dart';
import 'package:junto_beta_mobile/screens/spheres/sphere_open/sphere_open_appbar.dart';
import 'package:junto_beta_mobile/styles.dart';
import 'package:junto_beta_mobile/utils/junto_dialog.dart';
import 'package:junto_beta_mobile/utils/junto_overlay.dart';
import 'package:junto_beta_mobile/widgets/create_fab/create_fab.dart';
import 'package:junto_beta_mobile/widgets/expression_preview/expression_preview.dart';
import 'package:junto_beta_mobile/widgets/utils/hide_fab.dart';
import 'package:provider/provider.dart';

class SphereOpen extends StatefulWidget {
  const SphereOpen({
    Key key,
    this.group,
  }) : super(key: key);

  final Group group;

  @override
  State<StatefulWidget> createState() {
    return SphereOpenState();
  }
}

class SphereOpenState extends State<SphereOpen> with HideFab {
  ScrollController _hideFABController;
  ValueNotifier<bool> _isVisible;

  List<CentralizedExpressionResponse> expressions =
      <CentralizedExpressionResponse>[
    CentralizedExpressionResponse(
      address: '0xfee32zokie8',
      type: 'LongForm',
      comments: <Comment>[],
      context: '',
      createdAt: DateTime.now(),
      creator: UserProfile(
        address: '0vefoiwiafjvkbr32r243r5',
        parent: 'parent-address',
        bio: 'hellooo',
        firstName: 'Eric',
        lastName: 'Yang',
        profilePicture: 'assets/images/junto-mobile__eric.png',
        verified: true,
        username: 'Eric',
      ),
      expressionData: CentralizedLongFormExpression(
        title: 'Dynamic form is in motion!',
        body: "Hey! Eric here. We're currently working with a London-based dev "
            "agency called DevAngels to build out our dynamic, rich text editor. Soon, you'll be able to create short or longform expressions that contain text, links, images complemented with features such as bullet points, horiozntal lines, bold and italic font, and much more. This should be done in the next 1 or 2 weeks so stay tuned!",
      ),
    ),
    CentralizedExpressionResponse(
      address: '0xfee32zokie8',
      type: 'ShortForm',
      comments: <Comment>[],
      context: '',
      createdAt: DateTime.now(),
      creator: UserProfile(
        address: '0vefoiwiafjvkbr32r243r5',
        firstName: 'Dora',
        lastName: 'Czovek',
        profilePicture: 'assets/images/junto-mobile__dora.png',
        bio: 'hellooo',
        parent: 'parent-address',
        verified: true,
        username: 'wingedmessenger',
      ),
      expressionData: CentralizedShortFormExpression(
          body:
              'Have you heard of Paradym sound healing meditation? Join us for a transformational session this Friday!',
          background: 'four'),
    ),
    CentralizedExpressionResponse(
      address: '0xfee32zokie8',
      type: 'LongForm',
      comments: <Comment>[],
      context: '',
      createdAt: DateTime.now(),
      creator: UserProfile(
        address: '0vefoiwiafjvkbr32r243r5',
        parent: 'parent-address',
        firstName: 'Tomis',
        lastName: 'Parker',
        profilePicture: 'assets/images/junto-mobile__tomis.png',
        verified: true,
        bio: 'hellooo',
        username: 'tomis',
      ),
      expressionData: CentralizedLongFormExpression(
        title: 'The funny story about my name...',
        body: "A question I get all the time is, 'Is that your real name?' "
            "Well, I'm glad you asked. You see, it was a hot afternoon in Lexington, Kentucky. Feeling hangry, I swung by the closest Subway shop and...",
      ),
    ),
    CentralizedExpressionResponse(
      address: '0xfee32zokie8',
      type: 'EventForm',
      comments: <Comment>[],
      context: '',
      createdAt: DateTime.now(),
      creator: UserProfile(
        address: '0vefoiwiafjvkbr32r243r5',
        parent: 'parent-address',
        bio: "I'm Leif.",
        firstName: 'Leif',
        lastName: 'Lioness',
        profilePicture: 'assets/images/junto-mobile__leif.png',
        verified: true,
        username: 'leifthelion',
      ),
      expressionData: CentralizedEventFormExpression(
          title: 'Happiness is Your True Nature',
          location: 'within',
          startTime: 'ANYTIME',
          photo: 'assets/images/junto-mobile__event--two.png',
          description:
              "Now, you may not be as muscular as this stud. But let me tell you - You. Are. Beautiful. Everything you need is within, so come book an appointmnet with Happy Leif and we're guarantee you some Happy Photos ;)"),
    ),
  ];

  @override
  void initState() {
    _hideFABController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _hideFABController.addListener(_onScrollingHasChanged);
      _hideFABController.position.isScrollingNotifier.addListener(
        _onScrollingHasChanged,
      );
    });
    _isVisible = ValueNotifier<bool>(true);
    super.initState();
  }

  void _onScrollingHasChanged() {
    super.hideFabOnScroll(_hideFABController, _isVisible);
  }

  @override
  void dispose() {
    _hideFABController.removeListener(_onScrollingHasChanged);
    _hideFABController.dispose();
    super.dispose();
  }

  Future<void> _navigateToMembers() async {
    try {
      JuntoOverlay.showLoader(context);
      final List<Users> _members =
          await Provider.of<SpheresProvider>(context).getGroupMembers(
        widget.group.address,
      );
      JuntoOverlay.hide();
      Navigator.of(context).push(GroupMembers.route(_members));
    } catch (error) {
      JuntoOverlay.hide();
      JuntoDialog.showJuntoDialog(
        context,
        'Unable to get Sphere members. '
        'Error ${error.message}',
        <Widget>[
          FlatButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Ok'),
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(45),
        child: SphereOpenAppbar(
          widget.group.groupData.sphereHandle,
          widget.group.groupData.photo,
        ),
      ),
      floatingActionButton: ValueListenableBuilder<bool>(
        valueListenable: _isVisible,
        builder: (BuildContext context, bool visible, Widget child) {
          return AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: visible ? 1.0 : 0.0,
            child: child,
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CreateFAB(
            address: widget.group.address,
            sphereHandle: widget.group.groupData.sphereHandle,
            isVisible: _isVisible,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: ListView(
        controller: _hideFABController,
        children: <Widget>[
          Container(
            constraints: const BoxConstraints.expand(height: 200),
            child: Image.asset(
              'assets/images/junto-mobile__logo.png',
              fit: BoxFit.cover,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: JuntoStyles.horizontalPadding,
              vertical: 15,
            ),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: JuntoPalette.juntoFade,
                  width: .75,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          child: Text(
                            widget.group.groupData.name,
                            style: const TextStyle(
                              color: JuntoPalette.juntoGrey,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 15),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  margin: const EdgeInsets.only(bottom: 15),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: <Color>[
                          JuntoPalette.juntoSecondary,
                          JuntoPalette.juntoPrimary
                        ],
                      ),
                      borderRadius: BorderRadius.circular(10)),
                  child: const Text(
                    'Join Sphere',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w700),
                  ),
                ),
                InkWell(
                  onTap: _navigateToMembers,
                  child: MemberRow(
                    description: widget.group.groupData.description,
                  ),
                )
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: JuntoPalette.juntoFade,
                  width: .75,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Principles', style: JuntoStyles.header),
                const SizedBox(height: 10),
                Container(
                  width: MediaQuery.of(context).size.width * .88,
                  child: Text(widget.group.groupData.principles),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: JuntoPalette.juntoFade,
                  width: .75,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Facilitators', style: JuntoStyles.header),
                          const SizedBox(height: 10),
                          const Text('Eric Yang and 7 others'),
                        ]),
                    ClipOval(
                      child: Image.asset(
                        'assets/images/junto-mobile__eric.png',
                        height: 45.0,
                        width: 45.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          ListView(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            children: <Widget>[
              ExpressionPreview(expression: expressions[0]),
              ExpressionPreview(expression: expressions[1]),
              ExpressionPreview(expression: expressions[2]),
              ExpressionPreview(expression: expressions[3]),
            ],
          )
        ],
      ),
    );
  }
}

class MemberRow extends StatelessWidget {
  const MemberRow({
    Key key,
    @required this.description,
  }) : super(key: key);

  final String description;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            ClipOval(
              child: Image.asset(
                'assets/images/junto-mobile__eric.png',
                height: 28.0,
                width: 28.0,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 5),
            ClipOval(
              child: Image.asset(
                'assets/images/junto-mobile__riley.png',
                height: 28.0,
                width: 28.0,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 5),
            ClipOval(
              child: Image.asset(
                'assets/images/junto-mobile__yaz.png',
                height: 28.0,
                width: 28.0,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 5),
            ClipOval(
              child: Image.asset(
                'assets/images/junto-mobile__josh.png',
                height: 28.0,
                width: 28.0,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 5),
            ClipOval(
              child: Image.asset(
                'assets/images/junto-mobile__dora.png',
                height: 28.0,
                width: 28.0,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 5),
            ClipOval(
              child: Image.asset(
                'assets/images/junto-mobile__tomis.png',
                height: 28.0,
                width: 28.0,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 5),
            ClipOval(
              child: Image.asset(
                'assets/images/junto-mobile__drea.png',
                height: 28.0,
                width: 28.0,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 5),
            ClipOval(
              child: Image.asset(
                'assets/images/junto-mobile__leif.png',
                height: 28.0,
                width: 28.0,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        const Text('Nash members', style: JuntoStyles.title),
        const SizedBox(height: 10),
        Text(
          description,
          textAlign: TextAlign.start,
          style: const TextStyle(fontSize: 15, height: 1.4),
        ),
      ],
    );
  }
}
