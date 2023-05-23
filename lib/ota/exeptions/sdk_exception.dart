class SdkException implements Exception {
  final String message;

  SdkException(this.message);

  @override

  /// String message
  String toString() {
    return 'SdkException: $message';
  }
}
