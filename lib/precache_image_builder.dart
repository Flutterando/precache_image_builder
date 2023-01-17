import 'dart:collection';
import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'exceptions/no_providers_found_failure.dart';
import 'types/precache_image_handler.dart';
import 'types/precache_svg_handler.dart';

export 'exceptions/no_providers_found_failure.dart';

class PrecacheImageBuilder {
  final PrecacheImageHandler _precacheImageHandler;
  final PrecacheSvgHandler _precacheSvgHandler;

  PrecacheImageBuilder()
      : _precacheImageHandler = precacheImage,
        _precacheSvgHandler = precachePicture;

  PrecacheImageBuilder.test(
    this._precacheImageHandler,
    this._precacheSvgHandler,
  );

  final _imageProviders = <ImageProvider<Object>>[];
  final _svgProviders = <PictureProvider>[];

  UnmodifiableListView<ImageProvider<Object>> get imageProviders {
    return UnmodifiableListView(_imageProviders);
  }

  UnmodifiableListView<PictureProvider> get svgProviders {
    return UnmodifiableListView(_svgProviders);
  }

  PrecacheImageBuilder addImageAsset(
    String assetName, {
    AssetBundle? bundle,
    String? package,
  }) {
    _imageProviders
        .add(AssetImage(assetName, bundle: bundle, package: package));
    return this;
  }

  PrecacheImageBuilder addImageNetwork(
    String url, {
    double scale = 1.0,
    Map<String, String>? headers,
  }) {
    _imageProviders.add(NetworkImage(url, scale: scale, headers: headers));
    return this;
  }

  PrecacheImageBuilder addSvgAsset(
    String assetName, {
    PictureInfoDecoderBuilder<String>? decoderBuilder,
    AssetBundle? bundle,
    String? package,
    ColorFilter? colorFilter,
  }) {
    _svgProviders.add(ExactAssetPicture(
      decoderBuilder ?? SvgPicture.svgStringDecoderBuilder,
      assetName,
      bundle: bundle,
      package: package,
      colorFilter: colorFilter,
    ));
    return this;
  }

  PrecacheImageBuilder addSvgNetwork(
    String url, {
    PictureInfoDecoderBuilder<Uint8List>? decoderBuilder,
    Map<String, String>? headers,
    ColorFilter? colorFilter,
  }) {
    _svgProviders.add(NetworkPicture(
      decoderBuilder ?? SvgPicture.svgByteDecoderBuilder,
      url,
      headers: headers,
      colorFilter: colorFilter,
    ));
    return this;
  }

  Future<void> precache(BuildContext context) async {
    if (!canPrecache()) throw const NoProvidersFoundException();

    await Future.wait([
      ..._imageProviders
          .map((provider) => _precacheImageHandler(provider, context)),
      ..._svgProviders
          .map((provider) => _precacheSvgHandler(provider, context)),
    ]);
  }

  bool canPrecache() {
    return _imageProviders.isNotEmpty || _svgProviders.isNotEmpty;
  }
}
