import 'package:flutter/material.dart';

class SphereOpenDelegate extends SliverPersistentHeaderDelegate {
  SphereOpenDelegate(this._widget);

  final TabBar _widget;

  @override
  double get minExtent => _widget.preferredSize.height + .5;

  @override
  double get maxExtent => _widget.preferredSize.height + .5;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return _widget;
  }

  @override
  bool shouldRebuild(SphereOpenDelegate oldDelegate) {
    return true;
  }
}
