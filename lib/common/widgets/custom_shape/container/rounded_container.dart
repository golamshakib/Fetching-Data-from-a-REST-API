import 'package:flutter/material.dart';

class YRoundedContainer extends StatelessWidget {
  const YRoundedContainer({
    super.key,
    this.child,
    this.width,
    this.height,
    this.margin,
    this.padding,
    this.showBorder = false,
    this.radius = 16.0,
    this.backgroundColor = const Color(0xFFFFFFFF),
    this.borderColor = const Color(0xFFD9D9D9),
  });

  final double? width;
  final double? height;
  final bool showBorder;
  final double radius;
  final Widget? child;
  final Color borderColor;
  final Color backgroundColor;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: showBorder ? Border.all(color: borderColor) : null,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: child,
    );
  }
}
