
import 'package:flutter/material.dart';

import './sphere_open_appbar/sphere_open_appbar.dart';

class SphereOpen extends StatefulWidget {
  final sphereTitle;
  final sphereImage;
  final sphereMembers;
  final sphereHandle;

  SphereOpen(this.sphereTitle, this.sphereMembers, this.sphereImage, this.sphereHandle);

  @override
  State<StatefulWidget> createState() {
    return SphereOpenState();
  }
}

class SphereOpenState extends State<SphereOpen> {
  @override
  Widget build(BuildContext context) {

    return 
          Scaffold(
            backgroundColor: Colors.white,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(45),
              child: SphereOpenAppbar(
                  widget.sphereHandle),
            ),
            body: Text(widget.sphereHandle));
  }
}