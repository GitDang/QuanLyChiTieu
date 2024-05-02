import 'package:flutter/material.dart';

class CategoryIcon extends StatelessWidget {
  final double width;
  final double imageWidth;
  final String imageName;
  final Color color;

  const CategoryIcon({
    super.key,
    required this.width,
    required this.imageWidth,
    required this.imageName,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: width,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(width / 2),
      ),
      child: Padding(
        padding: EdgeInsets.all((width - imageWidth) / 2),
        child: Image.asset(imageName, width: imageWidth, fit: BoxFit.fitWidth),
      ),
    );
  }
}
