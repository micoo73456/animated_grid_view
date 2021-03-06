// AnimatedGridView is a GridView which implicitly animates the repositioning of children elements when the list of children changes.
//
// AnimatedGridView uses the child Widgets' Key property to animate its position. The simplest way to make the children animate correctly is to provide them with a ValueKey. Having children without Keys or with duplicate Keys may lead to undesired results.
//
// The current implementation:
//  - Only exposes GridView.count and all parameters except children and crossAxisCount are ignored.
//  - Only intended to support child reordering.
//  - Adding/removing children is partially supported -- it will update without error but the behavior is likely not desirable.
//  - Is brittle (e.g. doesn't handle all Animation status updates)

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

  // TODO: Pass the remaining arguments to the GridView.
  AnimatedGridView.count({
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
    List<Widget> children = const <Widget>[],
    int? semanticChildCount,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
    ScrollViewKeyboardDismissBehavior keyboardDismissBehavior =
        ScrollViewKeyboardDismissBehavior.manual,
    String? restorationId,
    Clip clipBehavior = Clip.hardEdge,
    this.duration = const Duration(milliseconds: 500),
  })  : children = List.from(children),
        super(key: key);

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

    _updatePreviousChildren(widget.children);

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..addStatusListener(_finalizeAnimation);
  }

  void _finalizeAnimation(AnimationStatus status) {
    switch (status) {
      case AnimationStatus.dismissed:
        // TODO: Handle this case.
        break;
      case AnimationStatus.forward:
        // TODO: Handle this case.
        break;
      case AnimationStatus.reverse:
        // TODO: Handle this case.
        break;
      case AnimationStatus.completed:
        _updatePreviousChildren(widget.children);
        _controller.reset();
        break;
    }
  }

  void _updatePreviousChildren(List<Widget> oldChildren) {
    _previousChildren.clear();
    _previousChildren.addAll(oldChildren);
  }

  List<int> get _previousIndices {
    List<int> result = [];
    for (var e in widget.children) {
      result
          .add(_previousChildren.indexWhere((element) => e.key == element.key));
    }
    return result;
  }

  void _maybeAnimate() {
    for (int i = 0; i < _previousIndices.length; i++) {
      if (_previousIndices[i] != i) {
        _controller.animateTo(1.0);
        return;
      }
    }
  }

  @override
  void didUpdateWidget(covariant AnimatedGridView oldWidget) {
    super.didUpdateWidget(oldWidget);
    _maybeAnimate();
  }

  // Calculates the union of old and new children.
  List<Widget> _getChildren() {
    final List<Widget> result = List.from(widget.children);
    result.addAll(_previousChildren.where(
        (previous) => !widget.children.any((e) => e.key == previous.key)));
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return GridView(
          // TODO: Why is this key necessary?
          key: UniqueKey(),
          children: _getChildren(),
          gridDelegate: AnimatedGridDelegate(
            crossAxisCount: widget.crossAxisCount,
            f: _controller.value,
            previousIndex: _previousIndices,
          ),
        );
      },
    );
  }
}
