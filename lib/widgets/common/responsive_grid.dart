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
    return GridView.builder(
      padding: const EdgeInsets.all(0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: 0,
        mainAxisSpacing: 0,
        childAspectRatio: 1,
      ),
      itemCount: columns * rows,
      itemBuilder: (context, index) => itemBuilder(index),
    );
  }
}