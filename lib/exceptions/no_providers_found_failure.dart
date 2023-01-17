class NoProvidersFoundException {
  const NoProvidersFoundException();
  @override
  String toString() {
    return 'No providers found. Try using "assetImage()", "networkImage()", "assetSvg()", "networkSvg()" before calling "precache()"';
  }
}
