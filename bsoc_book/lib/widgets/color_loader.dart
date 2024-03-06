import 'dart:math';

import 'package:bsoc_book/widgets/loader/indicator_painter.dart';
import 'package:flutter/material.dart';

/// BallSpinFadeLoader.
class ColorLoader extends StatefulWidget {
  const ColorLoader({Key? key, this.circleSize = 30}) : super(key: key);

  final double circleSize;

  @override
  State<ColorLoader> createState() => _ColorLoaderState();
}

const int _kBallSize = 8;

class _ColorLoaderState extends State<ColorLoader>
    with TickerProviderStateMixin {
  static const _durationInMills = 1000;
  static const _delayInMills = [0, 120, 240, 360, 480, 600, 720, 840];

  final List<AnimationController> _animationControllers = [];
  final List<Animation<double>> _scaleAnimations = [];
  final List<Animation<double>> _opacityAnimations = [];

  List<AnimationController> get animationControllers => _animationControllers;

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < _kBallSize; i++) {
      _animationControllers.add(AnimationController(
        value: _delayInMills[i] / _durationInMills,
        vsync: this,
        duration: const Duration(milliseconds: _durationInMills),
      ));
      _opacityAnimations.add(TweenSequence([
        TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.3), weight: 1),
        TweenSequenceItem(tween: Tween(begin: 0.3, end: 1.0), weight: 1),
      ]).animate(CurvedAnimation(
          parent: _animationControllers[i], curve: Curves.linear)));
      _scaleAnimations.add(TweenSequence([
        TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.4), weight: 1),
        TweenSequenceItem(tween: Tween(begin: 0.4, end: 1.0), weight: 1),
      ]).animate(CurvedAnimation(
          parent: _animationControllers[i], curve: Curves.linear)));

      _animationControllers[i].repeat();
    }
  }

  @override
  void dispose() {
    for (int i = 0; i < _kBallSize; i++) {
      _animationControllers[i].dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (ctx, constraint) {
      // final circleSize = constraint.maxWidth / 3;
      double circleSize = widget.circleSize;

      final widgets = List<Widget>.filled(8, Container());
      final center = Offset(constraint.maxWidth / 2, constraint.maxHeight / 2);
      for (int i = 0; i < widgets.length; i++) {
        final angle = pi * i / 4;
        widgets[i] = Positioned.fromRect(
          rect: Rect.fromLTWH(
            /// the radius is circleSize / 4, the startX and startY need to subtract that value.
            center.dx + circleSize * (sin(angle)) - circleSize / 4,
            center.dy + circleSize * (cos(angle)) - circleSize / 4,
            circleSize / 2,
            circleSize / 2,
          ),
          child: FadeTransition(
            opacity: _opacityAnimations[i],
            child: ScaleTransition(
              scale: _scaleAnimations[i],
              child: IndicatorShapeWidget(
                index: i,
              ),
            ),
          ),
        );
      }

      return Stack(
        alignment: Alignment.center,
        fit: StackFit.expand,
        children: widgets,
      );
    });
  }
}
