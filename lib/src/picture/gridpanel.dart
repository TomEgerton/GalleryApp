import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:galley_app_2/src/picture/panelbuttons.dart';
import 'package:galley_app_2/src/ui/imagepages/viewimage/viewimagepage.dart';
import 'package:galley_app_2/src/ui/imagepages/viewimage/selectimage.dart';


//Creates the grid view panel and populates it with the data pulled from firebase

class GridPanel extends StatefulWidget {
  final AsyncSnapshot<QuerySnapshot> snapshot;
  final int gridNum;
  final bool locked;
  final uid;

  GridPanel(this.snapshot, this.gridNum, this.locked, this.uid);

  @override
  _GridPanelState createState() => _GridPanelState();
}

class _GridPanelState extends State<GridPanel> {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: widget.gridNum,
      children: widget.snapshot.data!.docs.map((DocumentSnapshot document) {
        Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

        var selectedDoc = document.id;
        return Padding(
          padding: const EdgeInsets.all(5),
          child: Stack(
        children: <Widget>[
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ViewImage(data, widget.uid)),
            ),
            onLongPress: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        SelectImage(data['Download URL']))),
            child: Image.network(data['Download URL'] ??
                'https://thumbs.dreamstime.com/b/no-image-available-icon-flat-vector-no-image-available-icon-flat-vector-illustration-132482930.jpg'),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            if (data['userID'] != widget.uid || !widget.locked)
              const SizedBox(width: 20)
            else
              PanelButtons(data, selectedDoc),
          ]),
        ],
          ),
        );
      }).toList(),
    );
  }
}
