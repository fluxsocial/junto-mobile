class Pack {
  final String packTitle;
  final String packUser;
  final String packImage;

  Pack(this.packTitle, this.packUser, this.packImage);

  static fetchAll() {
    return [
      Pack('Cats', 'Yaz', 'assets/images/junto-mobile__yaz.png'),
      Pack('Ecstatic Dancers', 'Josh','assets/images/junto-mobile__josh.png'),
      Pack('HeruPandie', 'Dora','assets/images/junto-mobile__dora.png'),
      Pack('ByDrea', 'Drea', 'assets/images/junto-mobile__drea.png'),
    ];
  }
}
