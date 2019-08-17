class Sphere {
  const Sphere(
    this.sphereTitle,
    this.sphereMembers,
    this.sphereImage,
    this.sphereHandle,
    this.sphereDescription,
  );

  final String sphereTitle;
  final String sphereMembers;
  final String sphereImage;
  final String sphereHandle;
  final String sphereDescription;

  static List<Sphere> fetchAll() {
    return <Sphere>[
      const Sphere(
        'Ecstatic Dance',
        '12000',
        'assets/images/junto-mobile__ecstatic.png',
        'ecstaticdance',
        'Ecstatic dance is a space for movement, rhythm, non-judgment, and '
            'expression in its purest form. Come groove out with us!',
      ),
      const Sphere(
        'Flutter NYC',
        '690',
        'assets/images/junto-mobile__flutter.png',
        'flutternyc',
        'Connect with other members in the Flutter NYC community and learn'
            ' about this amazing technology!',
      ),
      const Sphere(
        'Zen',
        '77',
        'assets/images/junto-mobile__stillmind.png',
        'zen',
        '"To a mind that is still, the whole universe surrenders"',
      ),
      const Sphere(
        'JUNTO Core',
        '5',
        'assets/images/junto-mobile__junto.png',
        'juntocore',
        'Junto Core team happenings',
      ),
      const Sphere(
        'Holochain',
        '22',
        'assets/images/junto-mobile__expression--photo.png',
        'holochain',
        'Holochain is a framework to build scalable, distributed applications.',
      ),
    ];
  }
}
