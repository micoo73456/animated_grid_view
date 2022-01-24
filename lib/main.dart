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

  void _handleTap(int tappedIndex) {
    setState(() {
      int tappedDestination = _childValues.indexOf(_emptyTileValue);
      int tappedSource = _childValues.indexOf(tappedIndex);
      _childValues[tappedDestination] = tappedIndex;
      _childValues[tappedSource] = _emptyTileValue;
      print(_childValues);
    });
  }

  List<Widget> _buildChildren() {
    return _childValues
        .map((e) => Tile(
              key: ValueKey(e),
              c: e == _emptyTileValue
                  ? Colors.black
                  : Color.lerp(Colors.red, Colors.blue,
                      (e as double) / (_childValues.length - 1))!,
              onTap: () => _handleTap(e),
            ))
        .toList();
  }

  void _initChildren() {
    _childValues.clear();
    for (int i = 0; i <= 8; i++) {
      _childValues.add(i);
    }
  }

  void _addChild() {
    _childValues.add(_childValues.length);
  }

  void _removeChild() {
    if (_childValues.length > 1) {
      _childValues
          .removeAt(_childValues.lastIndexWhere((e) => e != _emptyTileValue));
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
          crossAxisCount: 3,
          children: _buildChildren(),
        ),
        floatingActionButton: Row(
          children: [
            Spacer(),
            FloatingActionButton.small(
                child: const Icon(Icons.refresh),
                onPressed: () => setState(() => _initChildren())),
            Container(width: 16, height: 0),
            FloatingActionButton.small(
                child: const Icon(Icons.shuffle),
                onPressed: () => setState(() => _childValues.shuffle())),
            Container(width: 16, height: 0),
            FloatingActionButton.small(
                child: const Icon(Icons.add),
                onPressed: () => setState(() => _addChild())),
            Container(width: 16, height: 0),
            FloatingActionButton.small(
                child: const Icon(Icons.remove),
                onPressed: () => setState(() => _removeChild())),
          ],
        ),
      ),
    );
  }
}
