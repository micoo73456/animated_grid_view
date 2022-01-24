// AnimatedGridView is a GridView which implicitly animates the repositioning of children elements when the list of children changes.
//
// The current implementation is only intended to support child reordering, not the addition or removal of children.

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'animated_grid_delegate.dart';

SliverGridGeometry lerp(SliverGridGeometry a, SliverGridGeometry b, double f) {
  return SliverGridGeometry(
      scrollOffset: a.scrollOffset * (1.0 - f) + b.scrollOffset * f,
      crossAxisOffset: a.crossAxisOffset * (1.0 - f) + b.crossAxisOffset * f,
      mainAxisExtent: a.mainAxisExtent * (1.0 - f) + b.mainAxisExtent * f,
      crossAxisExtent: a.crossAxisExtent * (1.0 - f) + b.crossAxisExtent * f);
}

class AnimatedGridView extends StatefulWidget {
  final List<Widget> children;
  final int crossAxisCount;
  final Duration duration;

  const AnimatedGridView.count({
    Key? key,
    Axis scrollDirection = Axis.vertical,
    bool reverse = false,
    ScrollController? controller,
    bool? primary,
    ScrollPhysics? physics,
    bool shrinkWrap = false,
    EdgeInsetsGeometry? padding,
    required this.crossAxisCount,
    double mainAxisSpacing = 0.0,
    double crossAxisSpacing = 0.0,
    double childAspectRatio = 1.0,
    bool addAutomaticKeepAlives = true,
    bool addRepaintBoundaries = true,
    bool addSemanticIndexes = true,
    double? cacheExtent,
    this.children = const <Widget>[],
    int? semanticChildCount,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
    ScrollViewKeyboardDismissBehavior keyboardDismissBehavior =
        ScrollViewKeyboardDismissBehavior.manual,
    String? restorationId,
    Clip clipBehavior = Clip.hardEdge,
    this.duration = const Duration(milliseconds: 500),
  }) : super(key: key);

  @override
  _AnimatedGridViewState createState() => _AnimatedGridViewState();
}

class _AnimatedGridViewState extends State<AnimatedGridView>
    with SingleTickerProviderStateMixin {
  final List<Widget> _previousChildren = [];
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _previousChildren.addAll(widget.children);

    _controller = AnimationController(
      vsync: this, // the SingleTickerProviderStateMixin
      duration: widget.duration,
    );
    // ..addListener(() => setState(() {}))
    // ..addStatusListener(_finalizeAnimation);
  }

  List<int> _previousIndices() => [];

  @override
  Widget build(BuildContext context) {
    return GridView(
      // TODO: Why is this key necessary?
      key: UniqueKey(),
      children: widget.children,
      gridDelegate: AnimatedGridDelegate(
        crossAxisCount: 3,
        f: _controller.value,
        previousIndex: _previousIndices(),
      ),
    );
  }
}
