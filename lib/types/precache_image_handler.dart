import 'package:flutter/widgets.dart';

/// Desc: Handler for precaching images
typedef PrecacheImageHandler = Future<void> Function(
  ImageProvider<Object> provider,
  BuildContext context, {
  Size? size,
  void Function(Object, StackTrace?)? onError,
});
