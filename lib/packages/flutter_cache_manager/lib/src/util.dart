class Utils {
  static String absolutePath(String url) {
    return '${Uri.parse(url).origin}${Uri.parse(url).path}';
  }
}
