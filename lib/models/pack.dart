class Pack {
  final String packTitle;
  final String packUser;
  final String packImage;

  Pack(this.packTitle, this.packUser, this.packImage);

  static fetchAll() {
    return [
      Pack('Wags', 'Riley', 'assets/images/junto-mobile__riley.png'),
      Pack('Kevin-san', 'Kevin', 'assets/images/junto-mobile__kevin.png'),
      Pack('HeruPandie', 'Dora','assets/images/junto-mobile__dora.png'),      
      Pack('ByDrea', 'Drea', 'assets/images/junto-mobile__drea.png'),
      Pack('Cats', 'Yaz', 'assets/images/junto-mobile__yaz.png'),
      Pack('Ecstatic Dancers', 'Josh','assets/images/junto-mobile__josh.png'),
      Pack('FlatToppers', 'Ekene', 'assets/images/junto-mobile__ekene.png'),    
      Pack('Levels', 'David', 'assets/images/junto-mobile__david.png'),      
    ];
  }
}
