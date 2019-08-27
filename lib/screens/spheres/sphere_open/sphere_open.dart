import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/components/create_fab/create_fab.dart';
import 'package:junto_beta_mobile/screens/spheres/sphere_open/sphere_open_appbar/sphere_open_appbar.dart';

class SphereOpen extends StatefulWidget {
  const SphereOpen(
    this.sphereTitle,
    this.sphereMembers,
    this.sphereImage,
    this.sphereHandle,
    this.sphereDescription,
  );

  final String sphereTitle;
  final String sphereImage;
  final String sphereMembers;
  final String sphereHandle;
  final String sphereDescription;

  @override
  State<StatefulWidget> createState() {
    return SphereOpenState();
  }
}

class SphereOpenState extends State<SphereOpen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(45),
        child: SphereOpenAppbar(
          widget.sphereHandle,
        ),
      ),
      floatingActionButton: CreateFAB(widget.sphereHandle),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: ListView(
        children: <Widget>[
          Container(
            constraints: const BoxConstraints.expand(height: 200),
            child: Image.asset(
              widget.sphereImage,
              fit: BoxFit.cover,
            ),
          ),
          Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 15,
              ),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Color(0xffeeeeee),
                    width: 1,
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
                              widget.sphereTitle,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Container(
                            child: Text(
                              widget.sphereMembers + ' members',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700

                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    child: Text(
                      widget.sphereDescription,
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ))
        ],
      ),
    );
  }
}
