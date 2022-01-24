import 'package:flutter/material.dart';

import 'animated_grid_view.dart';

void main() {
  runApp(const AnimatedGridViewDemo());
}

class Tile extends StatelessWidget {
  final Color c;
  final VoidCallback onTap;

  const Tile({Key? key, required this.c, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: c,
      child: GestureDetector(
        onTap: onTap,
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
  final List<int> _childValues = [];
  final int _emptyTileValue = 0;

  void _handleTap(int index) {
    setState(() {
      int destination = _childValues.indexOf(_emptyTileValue);
      int source = _childValues.indexOf(index);
      _childValues[destination] = source;
      _childValues[source] = _emptyTileValue;
    });
  }

  List<Widget> _buildChildren() {
    return _childValues
        .map((e) => Tile(
              key: ValueKey(e),
              c: e == _emptyTileValue
                  ? Colors.transparent
                  : Color.lerp(Colors.red, Colors.blue,
                      (e as double) / (_childValues.length - 1))!,
              onTap: () => _handleTap(e),
            ))
        .toList();
  }

  void _initChildren() {
    for (int i = 0; i <= 15; i++) {
      _childValues.add(i);
    }
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
          crossAxisCount: 4,
          children: _buildChildren(),
        ),
        floatingActionButton: FloatingActionButton.small(
            onPressed: () => setState(() => _childValues.shuffle())),
      ),
    );
  }
}
