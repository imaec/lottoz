import 'package:designsystem/theme/colors.dart';
import 'package:flutter/material.dart';

class HorizontalDivider extends StatelessWidget {
  final double height;
  final Color color;

  const HorizontalDivider({
    super.key,
    this.height = 1,
    this.color = gray100,
  });

  @override
  Widget build(BuildContext context) {
    return Container(height: height, color: color);
  }
}
