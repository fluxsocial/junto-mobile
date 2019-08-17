class Pack {
  final String packTitle;
  final String packUser;
  final String packImage;

  Pack(
    this.packTitle,
    this.packUser,
    this.packImage,
  );

  static List<Pack> fetchAll() {
    return [
      Pack(
        'Wags',
        'Riley Wagner',
        'assets/images/junto-mobile__riley.png',
      ),
      Pack(
        'Kevin-san',
        'Kevin Yang',
        'assets/images/junto-mobile__kevin.png',
      ),
      Pack(
        'HeruPandie',
        'Dora Czovek',
        'assets/images/junto-mobile__dora.png',
      ),
      Pack(
        'ByDrea',
        'Drea Bennett',
        'assets/images/junto-mobile__drea.png',
      ),
      Pack(
        'Cats',
        'Yaz Owainati',
        'assets/images/junto-mobile__yaz.png',
      ),
      Pack(
        'Ecstatic Dancers',
        'Josh Parkin',
        'assets/images/junto-mobile__josh.png',
      ),
      Pack(
        'FlatToppers',
        'Ekene Nkem-Mmekam',
        'assets/images/junto-mobile__ekene.png',
      ),
      Pack(
        'Levels',
        'David Wu',
        'assets/images/junto-mobile__david.png',
      ),
    ];
  }
}
