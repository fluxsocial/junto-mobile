import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/widgets/previews/circle_preview/circle_preview.dart';

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
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: Text(
                'MY CIRCLES',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
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
                        child: CirclePreview(group: sphere),
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
