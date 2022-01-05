import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:galley_app_2/src/picture/panelbuttons.dart';

class GridPanel extends StatefulWidget {
  final AsyncSnapshot<QuerySnapshot> snapshot;
  final int gridNum;
  final bool locked;
  final int streamVal;

  GridPanel(this.snapshot, this.gridNum, this.locked, this.streamVal);

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
        return Container(
            child: Padding(
              padding: EdgeInsets.all(5),
              child: Stack(
                children: <Widget>[
                  Image.network(data['Download URL']),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        widget.locked ? widget.streamVal == 4 ?  Container() : panelButtons(data, selectedDoc) : Container(),

                      ]
                  ),
                ],
              ),
            )
        );
      }).toList(),

    );
  }
}
