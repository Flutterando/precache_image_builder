import 'package:flutter/widgets.dart';

typedef PrecacheImageHandler = Future<void> Function(
  ImageProvider<Object> provider,
  BuildContext context, {
  Size? size,
  void Function(Object, StackTrace?)? onError,
});
