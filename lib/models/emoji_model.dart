class Emoji {
  const Emoji(this.name, this.code);

  final String name;
  final String code;

  @override
  String toString() {
    return 'Emoji{name="$name",  code="$code"}';
  }
}
