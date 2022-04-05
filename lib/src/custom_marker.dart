import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:collection/collection.dart';
import 'dart:ui' as ui;
import 'package:synchronized/synchronized.dart';

/// a widgets that capture a png screenshot of its content and pass it through
/// [onImageCaptured].
class CustomMarker extends StatefulWidget {
  final Widget child;
  final Function(Uint8List?)? onImageCaptured;
  final Duration? screenshotDelay;

  const CustomMarker(
      {Key? key,
      required this.child,
      this.onImageCaptured,
      this.screenshotDelay})
      : super(key: key);

  @override
  _CustomMarkerState createState() => _CustomMarkerState();
}

class _CustomMarkerState extends State<CustomMarker> {
  final GlobalKey key = GlobalKey();
  final Function eq = const ListEquality().equals;
  Uint8List? _lastImage;
  final lock = Lock();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      lock.synchronized(() async {
        await Future.delayed(
            widget.screenshotDelay ?? const Duration(milliseconds: 500));
        final _image = await _capturePng(key);
        if (_lastImage == null || !eq(_lastImage!, _image)) {
          _lastImage = _image;
          widget.onImageCaptured?.call(_image);
        } else {
          widget.onImageCaptured?.call(_lastImage);
        }
      });
    });
    return RepaintBoundary(
      key: key,
      child: widget.child,
    );
  }

  Future<Uint8List?> _capturePng(GlobalKey iconKey) async {
    try {
      final RenderRepaintBoundary? boundary =
          iconKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (kDebugMode && (boundary?.debugNeedsPaint ?? false)) {
        await Future.delayed(const Duration(milliseconds: 200));
        return _capturePng(iconKey);
      }
      ui.Image? image = await boundary?.toImage(pixelRatio: 3.0);
      ByteData? byteData =
          await image?.toByteData(format: ui.ImageByteFormat.png);
      var pngBytes = byteData?.buffer.asUint8List();
      return pngBytes;
    } catch (e) {
      return null;
    }
  }
}
