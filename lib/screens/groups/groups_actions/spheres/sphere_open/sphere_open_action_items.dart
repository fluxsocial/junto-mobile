import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/backend/repositories.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/widgets/dialogs/single_action_dialog.dart';
import 'package:junto_beta_mobile/utils/junto_exception.dart';
import 'package:junto_beta_mobile/utils/junto_overlay.dart';
import 'package:provider/provider.dart';

// This component is used in ExpressionPreview and ExpressionOpen
// as the 'more' icon is pressed to view the action items
// available for each expression
class SphereOpenActionItems extends StatelessWidget {
  const SphereOpenActionItems({
    Key key,
    @required this.sphere,
  }) : super(key: key);

  final Group sphere;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Container(
        height: MediaQuery.of(context).size.height * .4,
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: 5,
                      width: MediaQuery.of(context).size.width * .1,
                      decoration: BoxDecoration(
                        color: Theme.of(context).dividerColor,
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ListTile(
                  contentPadding: const EdgeInsets.all(0),
                  title: Row(
                    children: <Widget>[
                      Icon(
                        Icons.block,
                        size: 17,
                        color: Theme.of(context).primaryColor,
                      ),
                      const SizedBox(width: 15),
                      Text('Leave Sphere',
                          style: Theme.of(context).textTheme.headline5),
                    ],
                  ),
                ),
                ListTile(
                  contentPadding: const EdgeInsets.all(0),
                  onTap: () {},
                  title: Row(
                    children: <Widget>[
                      Icon(
                        Icons.block,
                        size: 17,
                        color: Theme.of(context).primaryColor,
                      ),
                      const SizedBox(width: 15),
                      Text('Report Sphere',
                          style: Theme.of(context).textTheme.headline5),
                    ],
                  ),
                ),
                ListTile(
                  contentPadding: const EdgeInsets.all(0),
                  onTap: () {
                    Navigator.push(context, EditGroupInfo.route(sphere));
                  },
                  title: Row(
                    children: <Widget>[
                      Icon(
                        Icons.edit,
                        size: 17,
                        color: Theme.of(context).primaryColor,
                      ),
                      const SizedBox(width: 15),
                      Text(
                        'Edit Sphere',
                        style: Theme.of(context).textTheme.headline5,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class EditGroupInfo extends StatefulWidget {
  const EditGroupInfo({
    Key key,
    @required this.sphere,
  }) : super(key: key);
  final Group sphere;

  static Route<dynamic> route(Group sphere) {
    return MaterialPageRoute<dynamic>(builder: (
      BuildContext context,
    ) {
      return EditGroupInfo(
        sphere: sphere,
      );
    });
  }

  @override
  _EditGroupInfoState createState() => _EditGroupInfoState();
}

class _EditGroupInfoState extends State<EditGroupInfo> {
  TextEditingController _nameController;
  TextEditingController _descriptionController;
  TextEditingController _principlesController;

  GroupDataSphere get _groupData => widget.sphere.groupData;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: _groupData.name,
    );
    _descriptionController = TextEditingController(
      text: _groupData.description,
    );
    _principlesController = TextEditingController(
      text: _groupData.principles,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _principlesController.dispose();
    super.dispose();
  }

  Future<void> _updateGroup() async {
    final GroupRepo _repo = Provider.of<GroupRepo>(context, listen: false);
    final String name = _nameController.text;
    final String desc = _descriptionController.text;
    final String principles = _principlesController.text;
    final Group updatedGroup = widget.sphere.copyWith(
      groupData: GroupDataSphere(
          name: name,
          description: desc,
          principles: principles,
          photo: _groupData.photo,
          sphereHandle: _groupData.sphereHandle),
    );
    try {
      JuntoLoader.showLoader(context);
      _repo.updateGroup(updatedGroup);
      JuntoLoader.hide();
      Navigator.pop(context);
    } on JuntoException catch (error) {
      JuntoLoader.hide();
      showDialog(
        context: context,
        builder: (BuildContext context) => const SingleActionDialog(
          dialogText: 'Hmm, something went wrong.',
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const Widget kVerticalSpace = SizedBox(height: 24);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12.0,
            vertical: 8.0,
          ),
          child: Column(
            children: <Widget>[
              Expanded(
                child: ListView(
                  children: <Widget>[
                    kVerticalSpace,
                    ConstrainedBox(
                      constraints: const BoxConstraints(
                        minHeight: 150.0,
                        maxHeight: 150.0,
                        minWidth: 150.0,
                        maxWidth: 150.0,
                      ),
                      child: CircleAvatar(
                        child: Image.asset(
                          'assets/images/junto-mobile__logo--spheres.png',
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    kVerticalSpace,
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                      ),
                    ),
                    kVerticalSpace,
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                      ),
                    ),
                    kVerticalSpace,
                    TextFormField(
                      controller: _principlesController,
                      decoration: const InputDecoration(
                        labelText: 'Principles',
                      ),
                    ),
                    kVerticalSpace,
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: RaisedButton(
                    onPressed: _updateGroup,
                    color: const Color(0xFF635FAA),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: const Text(
                      'Save',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
