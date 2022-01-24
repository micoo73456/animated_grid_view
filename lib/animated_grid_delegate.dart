import 'dart:math';

import 'package:flutter/rendering.dart';

class AnimatedGridLayout extends SliverGridRegularTileLayout {
  final double f;
  final List<int> previousIndices;

  const AnimatedGridLayout({
    required int crossAxisCount,
    required double mainAxisStride,
    required double crossAxisStride,
    required double childMainAxisExtent,
    required double childCrossAxisExtent,
    required bool reverseCrossAxis,
    required this.f,
    required this.previousIndices,
  }) : super(
          crossAxisCount: crossAxisCount,
          mainAxisStride: mainAxisStride,
          crossAxisStride: crossAxisStride,
          childMainAxisExtent: childMainAxisExtent,
          childCrossAxisExtent: childCrossAxisExtent,
          reverseCrossAxis: reverseCrossAxis,
        );

  SliverGridGeometry lerp(
      SliverGridGeometry a, SliverGridGeometry b, double f) {
    return SliverGridGeometry(
        scrollOffset: a.scrollOffset * (1.0 - f) + b.scrollOffset * f,
        crossAxisOffset: a.crossAxisOffset * (1.0 - f) + b.crossAxisOffset * f,
        mainAxisExtent: a.mainAxisExtent * (1.0 - f) + b.mainAxisExtent * f,
        crossAxisExtent: a.crossAxisExtent * (1.0 - f) + b.crossAxisExtent * f);
  }

  @override
  SliverGridGeometry getGeometryForChildIndex(int index) {
    var destination = super.getGeometryForChildIndex(index);

    final source = index >= previousIndices.length
        ? super.getGeometryForChildIndex(index)
        : super.getGeometryForChildIndex(previousIndices[index]);

    return lerp(source, destination, f);
  }
}

class AnimatedGridDelegate extends SliverGridDelegateWithFixedCrossAxisCount {
  double f;
  List<int> previousIndex;

  AnimatedGridDelegate({
    required int crossAxisCount,
    double mainAxisSpacing = 0.0,
    double crossAxisSpacing = 0.0,
    double childAspectRatio = 1.0,
    double? mainAxisExtent,
    required this.f,
    required this.previousIndex,
  }) : super(
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: mainAxisSpacing,
          crossAxisSpacing: crossAxisSpacing,
          childAspectRatio: childAspectRatio,
          mainAxisExtent: mainAxisExtent,
        );

  @override
  SliverGridLayout getLayout(SliverConstraints constraints) {
    final double usableCrossAxisExtent = max(
      0.0,
      constraints.crossAxisExtent - crossAxisSpacing * (crossAxisCount - 1),
    );
    final double childCrossAxisExtent = usableCrossAxisExtent / crossAxisCount;
    final double childMainAxisExtent =
        mainAxisExtent ?? childCrossAxisExtent / childAspectRatio;
    return AnimatedGridLayout(
      crossAxisCount: crossAxisCount,
      mainAxisStride: childMainAxisExtent + mainAxisSpacing,
      crossAxisStride: childCrossAxisExtent + crossAxisSpacing,
      childMainAxisExtent: childMainAxisExtent,
      childCrossAxisExtent: childCrossAxisExtent,
      reverseCrossAxis: axisDirectionIsReversed(constraints.crossAxisDirection),
      f: f,
      previousIndices: previousIndex,
    );
  }
}
