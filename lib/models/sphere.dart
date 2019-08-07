
class Sphere {
  final String sphereTitle;
  final String sphereMembers;
  final String sphereImage;
  final String sphereHandle; 

  Sphere(this.sphereTitle, this.sphereMembers, this.sphereImage, this.sphereHandle);

    static fetchAll() {
      return [
        Sphere('Ecstatic Dance', '12000', 'assets/images/junto-mobile__ecstatic.png', 'ecstaticdance'),
        Sphere('Flutter NYC', '690', 'assets/images/junto-mobile__flutter.png', 'flutternyc'),
        Sphere('Zen', '77', 'assets/images/junto-mobile__stillmind.png', 'zen'),
        Sphere('JUNTO Core', '5', 'assets/images/junto-mobile__junto.png', 'juntocore'),
        Sphere('Holochain', '22', 'assets/images/junto-mobile__expression--photo.png', 'holochain'),                
      ];
  }  
}