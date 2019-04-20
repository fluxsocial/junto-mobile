
class Sphere {
  String sphereTitle;
  String sphereMembers;

  Sphere(this.sphereTitle, this.sphereMembers);

    static fetchSphere() {
      return [
        Sphere('Ecstatic Dance', '12000'),
        Sphere('Flutter NYC', '690'),
        Sphere('Still Mind Zendo', '77'),
      ];
  }  
}