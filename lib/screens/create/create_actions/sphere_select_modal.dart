import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/widgets/previews/sphere_preview/sphere_preview.dart';

class SphereSelectModal extends StatelessWidget {
  const SphereSelectModal({this.spheres, this.onSelect});

  final List<Group> spheres;
  final Function onSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Container(
        height: MediaQuery.of(context).size.height * .6,
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 15,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
        ),
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                children: spheres
                    .map(
                      (Group sphere) => GestureDetector(
                        onTap: () {
                          onSelect(
                            sphere.address,
                            sphere.groupData.sphereHandle,
                          );
                        },
                        child: SpherePreview(group: sphere),
                      ),
                    )
                    .toList(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
