class Perspective {
  const Perspective(this.name);

  factory Perspective.fromMap(Map<String, dynamic> map) {
    return Perspective(
      map['name'],
    );
  }

  final String name;

  static List<Perspective> fetchAll() {
    return <Perspective>[
      const Perspective('NYC 🗽🏙️  '),
      const Perspective('Design'),
      const Perspective('Meditation'),
      const Perspective('Hoops 🏀'),
      const Perspective('Austrian Economics📈'),
      const Perspective('Holochain ♓'),
    ];
  }

  Map<String, dynamic> toMap() {
    return <String, String>{
      'name': name,
    };
  }
}
