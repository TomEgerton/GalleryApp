import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:galley_app_2/src/picture/panel_buttons.dart';
import 'package:galley_app_2/src/services/auth.dart';
import 'package:galley_app_2/src/ui/imagepages/viewimage/view_image_page.dart';
import 'package:galley_app_2/src/ui/imagepages/viewimage/select_image.dart';


//Creates the grid view panel and populates it with the data pulled from firebase

class GridPanel extends StatefulWidget {
  final AsyncSnapshot<QuerySnapshot> snapshot;
  final int gridNum;
  final bool locked;

  GridPanel(this.snapshot, this.gridNum, this.locked);

  @override
  _GridPanelState createState() => _GridPanelState();
}

class _GridPanelState extends State<GridPanel> {
  @override
  Widget build(BuildContext context) {
    var uid = AuthService().fetchID();
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
              MaterialPageRoute(builder: (context) => ViewImage(data, uid)),
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
            if (data['userID'] != uid || !widget.locked)
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
