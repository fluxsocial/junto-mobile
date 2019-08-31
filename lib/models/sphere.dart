import 'package:meta/meta.dart';

class Sphere {
  const Sphere({
    @required this.sphereTitle,
    @required this.sphereMembers,
    @required this.sphereImage,
    @required this.sphereHandle,
    @required this.sphereDescription,
  });

  final String sphereTitle;
  final String sphereMembers;
  final String sphereImage;
  final String sphereHandle;
  final String sphereDescription;

  static List<Sphere> fetchAll() {
    return <Sphere>[
      const Sphere(
        sphereTitle: 'Ecstatic Dance',
        sphereMembers: '12000',
        sphereImage: 'assets/images/junto-mobile__ecstatic.png',
        sphereHandle: 'ecstaticdance',
        sphereDescription:
            'Ecstatic dance is a space for movement, rhythm, non-judgment, and '
            'expression in its purest form. Come groove out with us!',
      ),
      const Sphere(
        sphereTitle: 'Flutter NYC',
        sphereMembers: '690',
        sphereImage: 'assets/images/junto-mobile__flutter.png',
        sphereHandle: 'flutternyc',
        sphereDescription:
            'Connect with other members in the Flutter NYC community and learn'
            ' about this amazing technology!',
      ),
      const Sphere(
        sphereTitle: 'Zen',
        sphereMembers: '77',
        sphereImage: 'assets/images/junto-mobile__stillmind.png',
        sphereHandle: 'zen',
        sphereDescription:
            '"To a mind that is still, the whole universe surrenders"',
      ),
      const Sphere(
        sphereTitle: 'JUNTO Core',
        sphereMembers: '5',
        sphereImage: 'assets/images/junto-mobile__junto.png',
        sphereHandle: 'juntocore',
        sphereDescription: 'Junto Core team happenings',
      ),
      const Sphere(
        sphereTitle: 'Holochain',
        sphereMembers: '22',
        sphereImage: 'assets/images/junto-mobile__expression--photo.png',
        sphereHandle: 'holochain',
        sphereDescription:
        'Holochain is a framework to build scalable, distributed applications.',
      ),
    ];
  }
}
