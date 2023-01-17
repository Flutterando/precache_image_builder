/// Desc: Exception thrown when no providers are found
class NoProvidersFoundException implements Exception {
  /// Constructor
  const NoProvidersFoundException();

  @override
  String toString() {
    return '''
No providers found. Try using "assetImage()", "networkImage()", 
    "assetSvg()", "networkSvg()" before calling "precache()"
    ''';
  }
}
