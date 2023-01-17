import 'package:precache_image_builder/precache_image_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class BuildContextMock extends Mock implements BuildContext {}

class PrecacheImageHandlerMock {
  bool called = false;
  Future<void> call(
    ImageProvider<Object> provider,
    BuildContext context, {
    Size? size,
    void Function(Object, StackTrace?)? onError,
  }) async {
    called = true;
  }
}

class PrecacheSvgHandlerMock {
  bool called = false;

  Future<void> call(
    PictureProvider<dynamic, dynamic> provider,
    BuildContext? context, {
    Rect? viewBox,
    ColorFilter? colorFilterOverride,
    Color? color,
    BlendMode? colorBlendMode,
    void Function(Object, StackTrace)? onError,
  }) async {
    called = true;
  }
}

void main() {
  late PrecacheImageBuilder precacheBuilder;
  late PrecacheImageHandlerMock imageHandler;
  late PrecacheSvgHandlerMock svgHandler;

  setUp(() {
    imageHandler = PrecacheImageHandlerMock();
    svgHandler = PrecacheSvgHandlerMock();
    precacheBuilder = PrecacheImageBuilder.test(imageHandler, svgHandler);
  });

  test('addImageAsset: should add as a new item on imageProviders', () {
    const assetName = 'mock-asset-name';
    precacheBuilder.addImageAsset(assetName);
    expect(
      precacheBuilder.imageProviders.first,
      (AssetImage img) => img.assetName == assetName,
    );
  });

  test('addImageNetwork: should add new item on imageProviders', () {
    const mockUrl = 'mock-image-url';
    precacheBuilder.addImageNetwork(mockUrl);
    expect(
      precacheBuilder.imageProviders.first,
      (NetworkImage img) => img.url == mockUrl,
    );
  });

  test('addSvgAsset: should add new item on svgProviders', () {
    const assetName = 'mock-svg-asset-name';
    precacheBuilder.addSvgAsset(assetName);
    expect(
      precacheBuilder.svgProviders.first,
      (ExactAssetPicture img) => img.assetName == assetName,
    );
  });

  test('addSvgNetwork: should add new item on svgProviders', () {
    const mockUrl = 'mock-svg-url';
    precacheBuilder.addSvgNetwork('mock-svg-url');
    expect(
      precacheBuilder.svgProviders.first,
      (NetworkPicture img) => img.url == mockUrl,
    );
  });

  test('precache: should precache SVG', () async {
    await precacheBuilder
        .addSvgNetwork('mock-svg-url')
        .precache(BuildContextMock());
    expect(svgHandler.called, true);
  });

  test('precache: should precache IMAGE', () async {
    await precacheBuilder
        .addImageNetwork('mock-image-url')
        .precache(BuildContextMock());
    expect(imageHandler.called, true);
  });

  test(
    'precache: should throw an exception when there are NO images added',
    () async {
      final future = precacheBuilder.precache(BuildContextMock());
      expect(future, throwsA(const NoProvidersFoundException()));
    },
  );
}
