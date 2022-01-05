import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:galley_app_2/src/picture/panelbuttons.dart';

//Panel for the photo grid view

class ListPanel extends StatefulWidget {

  final AsyncSnapshot<QuerySnapshot> snapshot;
  final int gridNum;
  final bool locked;
  final int streamVal;

  ListPanel(this.snapshot, this.gridNum, this.locked, this.streamVal);

  @override
  _ListPanelState createState() => _ListPanelState();
}

class _ListPanelState extends State<ListPanel> {
  Stream collectionStream = FirebaseFirestore.instance.collection('photos')
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: widget.snapshot.data!.docs.map((DocumentSnapshot document) {
        FirebaseFirestore.instance
            .collection('photos')
            .snapshots(includeMetadataChanges: true);
        Map<String, dynamic> data = document.data()! as Map<
            String,
            dynamic>;
        var selectedDoc = document.id;

        return Container(
          height: 160,
          child: Padding(
            padding: EdgeInsets.all(5),
            child: Stack(
              children: <Widget>[

                Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [

                      Expanded(child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image.network(data['Download URL']
                              ,
                              height: 125, width: 125,)
                          ])),

                      Expanded(child: Column(
                          mainAxisAlignment: MainAxisAlignment
                              .spaceEvenly, children: <Widget>[
                        Text(data['title'], style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.orange)),
                        Text('Uploaded by user ${data['userID']}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.orange),)
                      ])),

                      widget.locked ? widget.streamVal == 4
                          ? Container()
                          : panelButtons(data, selectedDoc) : Container(),

                    ]),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}



