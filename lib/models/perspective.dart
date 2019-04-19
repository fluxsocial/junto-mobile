
class Perspective {
  String perspectiveTitle;

  Perspective(this.perspectiveTitle);

    static fetchPerspective() {
      return [
        Perspective('NYC'),
        Perspective('MEDITATION'),
        Perspective('DESIGN'),
        Perspective('CRYPTO'),      

      ];
  }  
}