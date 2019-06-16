
class Sphere {
  final String sphereTitle;
  final String sphereMembers;
  final String sphereImage;

  Sphere(this.sphereTitle, this.sphereMembers, this.sphereImage);

    static fetchAll() {
      return [
        Sphere('Ecstatic Dance', '12000', 'assets/images/junto-mobile__ecstatic.png'),
        Sphere('Flutter NYC', '690', 'assets/images/junto-mobile__flutter.png'),
        Sphere('Zen', '77', 'assets/images/junto-mobile__stillmind.png'),
        Sphere('JUNTO Core', '5', 'assets/images/junto-mobile__junto.png'),
        Sphere('Holochain', '22', 'assets/images/junto-mobile__expression--photo.png'),                
        Sphere('Salsa', '117', ''),                
      ];
  }  
}