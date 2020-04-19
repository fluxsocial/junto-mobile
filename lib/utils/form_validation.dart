class Validator {
  static String validateNonEmpty(String value) {
    if (value == null || value.isEmpty) {
      return 'Please fill this in';
    } else {
      return null;
    }
  }

  static String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern);
    return (!regex.hasMatch(value)) ? 'Please enter a valid email' : null;
  }
}
