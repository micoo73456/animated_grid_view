import 'package:flutter/material.dart';

import 'animated_grid_view.dart';

void main() {
  runApp(const AnimatedGridViewDemo());
}

class Tile extends StatelessWidget {
  final Color c;
  final void Function(Tile) onTap;

  const Tile({Key? key, required this.c, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: c,
      child: GestureDetector(
        onTap: () => onTap(this),
      ),
    );
  }
}

class AnimatedGridViewDemo extends StatefulWidget {
  const AnimatedGridViewDemo({Key? key}) : super(key: key);

  @override
  _AnimatedGridViewDemoState createState() => _AnimatedGridViewDemoState();
}

class _AnimatedGridViewDemoState extends State<AnimatedGridViewDemo> {
  final List<Tile> _children = [];
  late Tile _emptyTile;

  void _handleTap(Tile t) {
    setState(() {
      int destination = _children.indexOf(_emptyTile);
      int source = _children.indexOf(t);
      _children[destination] = t;
      _children[source] = _emptyTile;
    });
  }

  void _initChildren() {
    for (int i = 0; i < 8; i++) {
      _children.add(
        Tile(
          // TODO: Try to remove this key.
          key: ValueKey(i),
          c: Color.lerp(Colors.red, Colors.blue, i / 8.0)!,
          onTap: _handleTap,
        ),
      );
    }
    _children.add(Tile(
      // TODO: Try to remove this key.
      key: const ValueKey(-1),
      c: Colors.transparent,
      onTap: _handleTap,
    ));

    _emptyTile = _children.last;
  }

  @override
  void initState() {
    super.initState();

    _initChildren();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text("AnimatedGridViewDemo"),
        ),
        body: AnimatedGridView.count(
          crossAxisCount: 3,
          children: _children,
        ),
      ),
    );
  }
}