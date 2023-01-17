import 'dart:collection';
import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'exceptions/no_providers_found_failure.dart';
import 'types/precache_image_handler.dart';
import 'types/precache_svg_handler.dart';

export 'exceptions/no_providers_found_failure.dart';

/// Desc: Builder class for precaching images and SVGs
class PrecacheImageBuilder {
  final PrecacheImageHandler _precacheImageHandler;
  final PrecacheSvgHandler _precacheSvgHandler;

  /// Desc: Builder class for precaching images and SVGs
  PrecacheImageBuilder()
      : _precacheImageHandler = precacheImage,
        _precacheSvgHandler = precachePicture;

  ///
  PrecacheImageBuilder.test(
    this._precacheImageHandler,
    this._precacheSvgHandler,
  );

  final _imageProviders = <ImageProvider<Object>>[];
  final _svgProviders = <PictureProvider>[];

  /// Desc: Add an image asset to the list of providers
  UnmodifiableListView<ImageProvider<Object>> get imageProviders {
    return UnmodifiableListView(_imageProviders);
  }

  /// Desc: Add an SVG asset to the list of providers
  UnmodifiableListView<PictureProvider> get svgProviders {
    return UnmodifiableListView(_svgProviders);
  }

  /// Desc: Add an image asset to the list of providers
  PrecacheImageBuilder addImageAsset(
    String assetName, {
    AssetBundle? bundle,
    String? package,
  }) {
    _imageProviders
        .add(AssetImage(assetName, bundle: bundle, package: package));
    return this;
  }

  /// Desc: Add an image network to the list of providers
  PrecacheImageBuilder addImageNetwork(
    String url, {
    double scale = 1.0,
    Map<String, String>? headers,
  }) {
    _imageProviders.add(NetworkImage(url, scale: scale, headers: headers));
    return this;
  }

  /// Desc: Add an SVG asset to the list of providers
  PrecacheImageBuilder addSvgAsset(
    String assetName, {
    PictureInfoDecoderBuilder<String>? decoderBuilder,
    AssetBundle? bundle,
    String? package,
    ColorFilter? colorFilter,
  }) {
    _svgProviders.add(
      ExactAssetPicture(
        decoderBuilder ?? SvgPicture.svgStringDecoderBuilder,
        assetName,
        bundle: bundle,
        package: package,
        colorFilter: colorFilter,
      ),
    );
    return this;
  }

  /// Desc: Add an SVG network to the list of providers
  PrecacheImageBuilder addSvgNetwork(
    String url, {
    PictureInfoDecoderBuilder<Uint8List>? decoderBuilder,
    Map<String, String>? headers,
    ColorFilter? colorFilter,
  }) {
    _svgProviders.add(
      NetworkPicture(
        decoderBuilder ?? SvgPicture.svgByteDecoderBuilder,
        url,
        headers: headers,
        colorFilter: colorFilter,
      ),
    );
    return this;
  }

  /// Desc: Add an SVG bytes to the list of providers
  Future<void> precache(BuildContext context) async {
    if (!canPrecache()) throw const NoProvidersFoundException();

    await Future.wait([
      ..._imageProviders
          .map((provider) => _precacheImageHandler(provider, context)),
      ..._svgProviders
          .map((provider) => _precacheSvgHandler(provider, context)),
    ]);
  }

  /// Desc: Check if there are any providers to precache
  bool canPrecache() {
    return _imageProviders.isNotEmpty || _svgProviders.isNotEmpty;
  }
}
