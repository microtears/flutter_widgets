import 'package:flutter/material.dart';
import 'dart:math' as math;

class CircleProgressIndicator extends StatefulWidget {
  final Widget child;
  final double strokeWidth;
  final Color color;
  final double padding;
  final double value;
  final double arcLength;
  final double radius;

  const CircleProgressIndicator({
    Key key,
    this.child,
    this.strokeWidth = 2.0,
    this.color,
    this.padding = 2.0,
    this.value,
    this.arcLength = 10,
    this.radius = 35,
  })  : assert(value == null || (value >= 0.0 && value <= 1.0)),
        assert(arcLength != null),
        assert(strokeWidth != null),
        assert(padding != null),
        assert(radius != null),
        super(key: key);

  @override
  _CircleProgressIndicatorState createState() =>
      _CircleProgressIndicatorState();
}

class _CircleProgressIndicatorState extends State<CircleProgressIndicator>
    with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;
  int count;

  void _updateController(int oldCount) {
    if (oldCount != count) {
      _controller?.dispose();
      var duration = widget.radius * math.pi * 2 / widget.arcLength;
      _controller = AnimationController(
        duration: Duration(seconds: duration.floor()),
        vsync: this,
      );
      _animation = Tween(begin: 0.0, end: math.pi * 2).animate(_controller);
    }
  }

  void _updateCount() {
    var oldCount = count;
    var circleLength = widget.radius * math.pi * 2;
    count = circleLength ~/ widget.arcLength;
    _updateController(oldCount);
  }

  @override
  void initState() {
    _updateCount();
    if (widget.value == null) _controller.repeat();
    super.initState();
  }

  @override
  void didUpdateWidget(CircleProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.arcLength != oldWidget.arcLength ||
        widget.radius != oldWidget.radius) {
      _updateCount();
    }

    if (widget.value == null && !_controller.isAnimating)
      _controller.repeat();
    else if (widget.value != null && _controller.isAnimating) {
      if (widget.value == 1.0) {
        _controller.stop();
      } else {
        _controller.repeat();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (_, child) => Transform.rotate(
        angle: _animation.value,
        child: CustomPaint(
          painter: _CircleProgressBarPainter(
            widget.strokeWidth,
            widget.color ?? Theme.of(context).accentColor,
            count,
          ),
          child: Transform.rotate(
            angle: -_animation.value,
            child: child,
          ),
        ),
      ),
      child: Container(
        constraints: BoxConstraints.tight(Size.fromRadius(widget.radius)),
        child: Padding(
          padding: EdgeInsets.all(widget.strokeWidth * 2 + widget.padding),
          child: ClipOval(
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

class _CircleProgressBarPainter extends CustomPainter {
  final double strokeWidth;
  final Color color;
  final int count;

  _CircleProgressBarPainter(this.strokeWidth, this.color, this.count);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.translate(size.width / 2, size.height / 2);
    var paint = Paint()..color = color;
    var radians = math.pi * 2 / count;
    for (int i = 0; i <= count; ++i) {
      canvas
        ..drawCircle(size.topCenter(Offset.zero).translate(-strokeWidth, 0),
            strokeWidth, paint)
        ..rotate(radians);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
