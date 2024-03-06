import 'package:bsoc_book/resource/values/app_colors.dart';
import 'package:flutter/material.dart';

const double _kMinIndicatorSize = 36.0;

/// Basic shape.
enum Shape {
  circle,
}

/// Wrapper class for basic shape.
class IndicatorShapeWidget extends StatelessWidget {
  final double? data;

  /// The index of shape in the widget.
  final int index;

  const IndicatorShapeWidget({
    Key? key,
    this.data,
    this.index = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //final DecorateData decorateData = DecorateContext.of(context)!.decorateData;
    //final color = decorateData.colors[index % decorateData.colors.length];

    return Container(
      constraints: const BoxConstraints(
        minWidth: _kMinIndicatorSize,
        minHeight: _kMinIndicatorSize,
      ),
      child: CustomPaint(
        painter: _ShapePainter(
          AppColors.PRIMARY_COLOR,
          data,
          36,
          pathColor: AppColors.PRIMARY_COLOR,
        ),
      ),
    );
  }
}

class _ShapePainter extends CustomPainter {
  final Color color;
  final Paint _paint;
  final double? data;
  final double strokeWidth;
  final Color? pathColor;

  _ShapePainter(
    this.color,
    this.data,
    this.strokeWidth, {
    this.pathColor,
  })  : _paint = Paint()..isAntiAlias = true,
        super();

  @override
  void paint(Canvas canvas, Size size) {
    _paint
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.shortestSide / 2,
      _paint,
    );
  }

  @override
  bool shouldRepaint(_ShapePainter oldDelegate) =>
      color != oldDelegate.color ||
      data != oldDelegate.data ||
      strokeWidth != oldDelegate.strokeWidth ||
      pathColor != oldDelegate.pathColor;
}
