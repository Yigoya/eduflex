import 'package:flutter/material.dart';
import 'package:path/path.dart';

class ImagePage extends StatefulWidget {
  final String path;
  final bool isLocal;
  const ImagePage({super.key, required this.path, this.isLocal = false});

  @override
  State<ImagePage> createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage> {
  @override
  Widget build(BuildContext context) {
    String name = basename(widget.path);
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: Center(
        child: Container(
          child: widget.isLocal
              ? Image.asset(widget.path)
              : Image.network(widget.path),
        ),
      ),
    );
  }
}
