class Perspective {
  const Perspective(this.perspectiveTitle);

  final String perspectiveTitle;

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
}
