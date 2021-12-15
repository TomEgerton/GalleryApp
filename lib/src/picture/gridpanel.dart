import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'pictureobject.dart';


//Panel for the photo grid view

class GridPanel extends StatefulWidget {
  const GridPanel({Key? key}) : super(key: key);

  @override
  _GridPanelState createState() => _GridPanelState();
}

class _GridPanelState extends State<GridPanel> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          //Image(image: )
          Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.favorite),
                  onPressed: () {/* ... */},
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () {/* ... */},
                ),
                const SizedBox(width: 8),
              ],
          ),
        ],
      ),
    );
  }
}



