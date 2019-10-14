import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/group_model.dart';
import 'package:junto_beta_mobile/models/sphere.dart';
import 'package:junto_beta_mobile/providers/provider.dart';
import 'package:junto_beta_mobile/screens/spheres/sphere_members.dart';
import 'package:provider/provider.dart';

class PackDrawer extends StatefulWidget {
  const PackDrawer({
    Key key,
    @required this.pack,
  }) : super(key: key);

  final Group pack;

  @override
  _PackDrawerState createState() => _PackDrawerState();
}

class _PackDrawerState extends State<PackDrawer> {
  List<Users> users = <Users>[];
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getPackUsers();
  }

  Future<void> getPackUsers() async {
    final List<Users> _members =
        await Provider.of<SpheresProvider>(context).getGroupMembers(
      widget.pack.address,
    );
    if (_members != null && _members.isNotEmpty) {
      users = _members;
    }
  }

  void _viewPackMembers() {
    Navigator.of(context).push(
      MaterialPageRoute<dynamic>(
        builder: (BuildContext context) => GroupMembers(
              users: users,
              groupName: 'Pack Members',
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return SizedBox(
      width: MediaQuery.of(context).size.width * .9,
      child: Drawer(
        elevation: 0,
        child: Container(
          color: Colors.white,
          margin: EdgeInsets.only(top: statusBarHeight),
          child: Column(
            children: <Widget>[
              Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Color(0xffeeeeee), width: 1),
                  ),
                ),
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      widget.pack.groupData.name,
                      style: const TextStyle(
                          fontSize: 17,
                          color: Color(0xff333333),
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(
                    0,
                  ),
                  children: <Widget>[
                    InkWell(
                      onTap: _viewPackMembers,
                      child: Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Color(0xffeeeeee),
                              width: .75,
                            ),
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        child: Column(
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
                                    'assets/images/junto-mobile__josh.png',
                                    height: 28.0,
                                    width: 28.0,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            const Text(
                              '50 pack members',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ),
                    PackDrawerItem(
                      itemName: 'Add Member',
                      onTap: () {},
                    ),
                    PackDrawerItem(
                      itemName: 'Edit Pack',
                      onTap: () {},
                    ),
                    PackDrawerItem(
                      itemName: 'Leave Pack',
                      onTap: () {},
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class PackDrawerItem extends StatelessWidget {
  const PackDrawerItem({
    Key key,
    @required this.itemName,
    @required this.onTap,
  }) : super(key: key);

  final String itemName;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Color(0xffeeeeee),
                width: .75,
              ),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Text(
            itemName,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}
