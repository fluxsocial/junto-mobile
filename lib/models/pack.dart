
class Pack {
  String packTitle;
  String packUser;

  Pack(this.packTitle, this.packUser);

    static fetchPack() {
      return [
        Pack('Dancing Poets', 'Rye'),
        Pack('Cats', 'Yaz'),
        Pack('Ecstatic Dancers', 'Josh'),
        Pack('HeruPandie', 'Dora'),      

      ];
  }  
}