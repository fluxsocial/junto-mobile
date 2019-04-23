
class Sphere {
  final String sphereTitle;
  final String sphereMembers;

  Sphere(this.sphereTitle, this.sphereMembers);

    static fetchAll() {
      return [
        Sphere('Ecstatic Dance', '12000'),
        Sphere('Flutter NYC', '690'),
        Sphere('Still Mind Zendo', '77'),
      ];
  }  
}