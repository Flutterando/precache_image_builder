import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

typedef PrecacheSvgHandler = Future<void> Function(
  PictureProvider<dynamic, dynamic> provider,
  BuildContext? context, {
  Rect? viewBox,
  ColorFilter? colorFilterOverride,
  Color? color,
  BlendMode? colorBlendMode,
  void Function(Object, StackTrace)? onError,
});