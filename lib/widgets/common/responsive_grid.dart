import 'package:flutter/material.dart';

class ResponsiveGrid extends StatelessWidget {
  final int columns;
  final int rows;
  final double size;
  final Widget Function(int index) itemBuilder;

  const ResponsiveGrid({
    super.key,
    required this.columns,
    required this.rows,
    required this.size,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columns,
        ),
        itemCount: columns * rows,
        itemBuilder: (context, index) => itemBuilder(index),
      ),
    );
  }
}