import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:galley_app_2/src/picture/panelbuttons.dart';
import 'package:galley_app_2/src/ui/imagepages/viewimage/viewimagepage.dart';
import 'package:galley_app_2/src/ui/imagepages/viewimage/selectimage.dart';

//Creates the list view panel and populates it with the data pulled from firebase

class ListPanel extends StatefulWidget {
  final AsyncSnapshot<QuerySnapshot> snapshot;
  final bool locked;
  final String uid;

  ListPanel(this.snapshot, this.locked, this.uid);

  @override
  _ListPanelState createState() => _ListPanelState();
}

class _ListPanelState extends State<ListPanel> {
  Stream collectionStream =
      FirebaseFirestore.instance.collection('photos').snapshots();

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: widget.snapshot.data!.docs.map((DocumentSnapshot document) {
        FirebaseFirestore.instance
            .collection('photos')
            .snapshots(includeMetadataChanges: true);
        Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
        var selectedDoc = document.id;

        return Container(
          height: 160,
          child: Padding(
            padding: EdgeInsets.all(5),
            child: Stack(
              children: <Widget>[
                Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  Expanded(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                        GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ViewImage(data, widget.uid)),
                          ),
                          onLongPress: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      SelectImage(data['Download URL']))),
                          child: Image.network(
                              data['Download URL'] ??
                                  'https://thumbs.dreamstime.com/b/no-image-available-icon-flat-vector-no-image-available-icon-flat-vector-illustration-132482930.jpg',
                              height: 125,
                              width: 125),
                        ),
                      ])),
                  Expanded(
                      child: GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ViewImage(data, widget.uid)),
                    ),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text(data['title'],
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.orange)),
                          Text(
                            'Uploaded by user ${data['userID']}',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.orange),
                          )
                        ]),
                  )),
                  if (data['userID'] != widget.uid || !widget.locked)
                    SizedBox(width: 50)
                  else
                    PanelButtons(data, selectedDoc),
                ]),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
