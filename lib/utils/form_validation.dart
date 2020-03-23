class Validator {
  static String validateNonEmpty(String value) {
    if (value == null || value.isEmpty) {
      return 'Please fill this in';
    } else {
      return null;
    }
  }
}
