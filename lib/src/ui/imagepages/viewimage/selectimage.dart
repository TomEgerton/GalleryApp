import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class SelectImage extends StatefulWidget {
  var data;

  SelectImage(this.data, {Key? key}) : super(key: key);

  @override
  State<SelectImage> createState() => _SelectImageState();
}

// Displays the image on an overlay allowing the user to zoom in etc
class _SelectImageState extends State<SelectImage> {
  @override
  Widget build(BuildContext context) {
    var image = widget.data;
    return PhotoView(
      imageProvider: NetworkImage(image),
    );
  }
}
