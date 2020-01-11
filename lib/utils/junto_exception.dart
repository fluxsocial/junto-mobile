class JuntoException implements Exception {
  const JuntoException(this.message, this.errorCode);

  final String message;
  final int errorCode;
}
