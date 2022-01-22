import 'dart:typed_data';

import 'package:custom_map_markers/src/custom_marker.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// A widget that converts a list of widget into png images
/// returned as [Uint8List].

class CustomMapMarkerBuilder extends StatelessWidget {
  /// List of custom widgets that are going to be used as map markers.
  final List<Widget> markerWidgets;

  /// Each widget in [markerWidgets] will be converted into png image inorder
  /// be used as map marker.
  /// [screenshotDelay] will add an extra delay before taking screenshot
  /// of widgets.
  ///
  /// You can use this if you widget needs more time to build or render
  /// like [Image.network] for example.
  final Duration screenshotDelay;

  /// Widget builder that carries [imagesData] which is `null` when marker
  /// images are not ready yet or list of [Uint8List] when custom markers
  /// are ready.
  final Widget Function(BuildContext context, List<Uint8List>? imagesData)
      builder;

  /// [controller] controls the state of captured images from widgets.
  late final _MarkersController controller;

  CustomMapMarkerBuilder({
    Key? key,
    required this.markerWidgets,
    required this.builder,
    this.screenshotDelay = const Duration(milliseconds: 500),
  }) : super(key: key) {
    controller = _MarkersController(
        value: List<Uint8List?>.filled(markerWidgets.length, null),
        childCount: markerWidgets.length);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ...List.generate(
              markerWidgets.length,
              (index) => Positioned(
                    left: -MediaQuery.of(context).size.width,
                    child: CustomMarker(
                      child: markerWidgets[index],
                      screenshotDelay: screenshotDelay,
                      onImageCaptured: (data) {
                        controller.updateRenderedImage(index, data);
                      },
                    ),
                  )),
        ValueListenableBuilder(
            valueListenable: controller,
            builder:
                (BuildContext context, List<Uint8List?> value, Widget? child) {
              return builder(context, controller.images);
            })
      ],
    );
  }
}

/// A widget convert list of widgets into custom google maps marker icons.

class CustomGoogleMapMarkerBuilder extends StatelessWidget {
  /// List of custom [MarkerData] each item is a google maps [Marker] and
  /// custom widget thar are going to be used as an icon for this marker.
  final List<MarkerData> customMarkers;

  /// Each widget in [markerWidgets] will be converted into png image inorder
  /// be used as map marker.
  /// [screenshotDelay] will add an extra delay before taking screenshot
  /// of widgets.
  ///
  /// You can use this if you widget needs more time to build or render
  /// like [Image.network] for example.
  final Duration screenshotDelay;

  /// Widget builder that carries [imagesData] which is `null` when marker
  /// images are not ready yet or list of google maps [Marker] when custom
  /// markers are ready.
  final Widget Function(BuildContext, Set<Marker>? markers) builder;

  const CustomGoogleMapMarkerBuilder(
      {Key? key,
      required this.customMarkers,
      required this.builder,
      this.screenshotDelay = const Duration(milliseconds: 500)})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomMapMarkerBuilder(
      screenshotDelay: screenshotDelay,
      markerWidgets:
          customMarkers.map((customMarker) => customMarker.child).toList(),
      builder: (BuildContext context, List<Uint8List>? customMarkerImagesData) {
        return builder(
            context,
            customMarkerImagesData == null
                ? null
                : customMarkers
                    .map((e) => e.marker.copyWith(
                        iconParam: BitmapDescriptor.fromBytes(
                            customMarkerImagesData[customMarkers.indexOf(e)])))
                    .toSet());
      },
    );
  }
}

/// [MarkerData] carries google maps marker and its desired icon widget
class MarkerData {
  final Marker marker;
  final Widget child;

  MarkerData({required this.marker, required this.child});
}

/// [_MarkersController] handles the state of rendered markers and notify
/// listeners when all marker are rendered and captured.

class _MarkersController extends ValueNotifier<List<Uint8List?>> {
  final int childCount;

  late final List<Uint8List?> renderedWidgets;

  _MarkersController({required List<Uint8List?> value, required this.childCount})
      : super(value) {
    renderedWidgets = List<Uint8List?>.filled(childCount, null);
  }

  updateRenderedImage(int index, Uint8List? data) {
    renderedWidgets[index] = data;
    if (ready) {
      value = List.from(renderedWidgets);
    }
  }

  bool get ready => !renderedWidgets.any((image) => image == null);

  List<Uint8List>? get images => ready ? value.cast<Uint8List>() : null;
}
