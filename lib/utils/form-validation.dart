class Validator {
  static String validateNonEmpty(String value) {
    if (value == null || value.isEmpty) {
      return 'This field cannot be left blank';
    } else {
      return null;
    }
  }
}
