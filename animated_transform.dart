import 'package:flutter/material.dart';

class AnimatedTransform extends ImplicitlyAnimatedWidget {
  final Widget child;
  final Matrix4 transform;
  final Curve curve;
  final Duration duration;
  final AlignmentGeometry alignment;

  const AnimatedTransform({
    Key key,
    @required this.duration,
    @required this.transform,
    this.curve = Curves.linear,
    this.child,
    this.alignment,
  }) : super(key: key, curve: curve, duration: duration);

  @override
  _AnimatedTransformState createState() => _AnimatedTransformState();
}

class _AnimatedTransformState
    extends AnimatedWidgetBaseState<AnimatedTransform> {
  Matrix4Tween _transform;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _transform = visitor(_transform, widget.transform,
            (dynamic value) => Matrix4Tween(begin: value as Matrix4))
        as Matrix4Tween;
  }

  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: _transform?.evaluate(animation),
      alignment: widget.alignment,
      child: widget.child,
    );
  }
}
