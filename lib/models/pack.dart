class Pack {
  final String packTitle;
  final String packUser;

  Pack(this.packTitle, this.packUser);

  static fetchAll() {
    return [
      Pack('Dancing Poets', 'Rye'),
      Pack('Cats', 'Yaz'),
      Pack('Ecstatic Dancers', 'Josh'),
      Pack('HeruPandie', 'Dora'),
    ];
  }
}
