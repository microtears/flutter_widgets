import 'package:flutter/material.dart';
import 'package:lite/widgets/animated_transform.dart';

class AnimatedZoom extends StatefulWidget {
  final Widget child;
  final double scale;

  const AnimatedZoom({Key key, this.scale = 0.95, this.child})
      : assert(scale <= 1.0 && scale >= 0.0),
        super(key: key);

  @override
  _AnimatedZoomState createState() => _AnimatedZoomState();
}

class _AnimatedZoomState extends State<AnimatedZoom> {
  bool _isTapDown = false;

  @override
  Widget build(BuildContext context) {
    var scale = _isTapDown ? widget.scale : 1.0;
    var handlePointer = Listener(
      onPointerDown: _handlePointerDown,
      onPointerCancel: _handlePointerCancel,
      onPointerUp: _handlePointerUp,
      child: widget.child,
    );
    return AnimatedTransform(
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 240),
      alignment: Alignment.center,
      transform: Matrix4.identity()..scale(scale, scale),
      child: handlePointer,
    );
  }

  void _reset() {
    setState(() {
      _isTapDown = false;
    });
  }

  void _handlePointerDown(PointerDownEvent event) {
    setState(() {
      _isTapDown = true;
    });
  }

  void _handlePointerCancel(PointerCancelEvent event) {
    _reset();
  }

  void _handlePointerUp(PointerUpEvent event) {
    _reset();
  }
}
