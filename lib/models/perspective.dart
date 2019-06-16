class Perspective {
  final String perspectiveTitle;

  Perspective(this.perspectiveTitle);

  static List<Perspective> fetchAll() {
    return [
      Perspective('NYC 🗽🏙️  '),
      Perspective('Design'),
      Perspective('Meditation'),
      Perspective('Hoops 🏀'),
      Perspective('Austrian Economics📈'),      
      Perspective('Holochain ♓'),
    ];
  }
}
