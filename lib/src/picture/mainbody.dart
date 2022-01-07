import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:galley_app_2/src/picture/gridpanel.dart';
import 'package:galley_app_2/src/picture/listpanel.dart';

//The main body that contains all the image panels

class MainBody extends StatefulWidget {
  final bool grid; //Allows the body to display the grid or list
  final int gridNum; //Sets the amount of panels per row on the grid
  final bool locked; //Locks the images
  final int streamVal;
  final String searchText;

  MainBody(
      this.grid, this.gridNum, this.locked, this.streamVal, this.searchText);

  @override
  _MainBodyState createState() => _MainBodyState();
}

class _MainBodyState extends State<MainBody> {
  @override
  Widget build(BuildContext context) {
    //Finds the current instance of firebase and gets the UID to check in the stream
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser as User;
    final uid = user.uid;

    final searchText = widget.searchText;

    //Sets the stream to display
    var streamName;

    if (widget.streamVal == 0) {
      Stream<QuerySnapshot> _nameStream = FirebaseFirestore.instance
          .collection('photos')
          .where('userID', isEqualTo: uid)
          .orderBy('title')
          .snapshots();
      streamName = _nameStream;
    }
    if (widget.streamVal == 1) {
      Stream<QuerySnapshot> _newestStream = FirebaseFirestore.instance
          .collection('photos')
          .where('userID', isEqualTo: uid)
          .orderBy('createdAt')
          .snapshots();
      streamName = _newestStream;
    }
    if (widget.streamVal == 2) {
      Stream<QuerySnapshot> _oldestStream = FirebaseFirestore.instance
          .collection('photos')
          .where('userID', isEqualTo: uid)
          .orderBy('createdAt', descending: true)
          .snapshots();
      streamName = _oldestStream;
    }
    if (widget.streamVal == 3) {
      Stream<QuerySnapshot> _favStream = FirebaseFirestore.instance
          .collection('photos')
          .where('userID', isEqualTo: uid)
          .where('Favourite', isEqualTo: true)
          .snapshots();
      streamName = _favStream;
    }

    if (widget.streamVal == 4) {
      Stream<QuerySnapshot> _shareStream = FirebaseFirestore.instance
          .collection('photos')
          .where('Shared', isEqualTo: true)
          .snapshots();
      streamName = _shareStream;
    }

    if (searchText != '') {
      if (widget.streamVal != 4) {
        Stream<QuerySnapshot> _searchStream = FirebaseFirestore.instance
            .collection('photos')
            .where('userID', isEqualTo: uid)
            .where(
              'title',
              isGreaterThanOrEqualTo: searchText,
              isLessThan: searchText.substring(0, searchText.length - 1) +
                  String.fromCharCode(
                      searchText.codeUnitAt(searchText.length - 1) + 1),
            )
            .snapshots();
        streamName = _searchStream;
      }
      if (widget.streamVal == 4) {
        Stream<QuerySnapshot> _searchStream = FirebaseFirestore.instance
            .collection('photos')
            .where(
              'title',
              isGreaterThanOrEqualTo: searchText,
              isLessThan: searchText.substring(0, searchText.length - 1) +
                  String.fromCharCode(
                      searchText.codeUnitAt(searchText.length - 1) + 1),
            )
            .where('Shared', isEqualTo: true)
            .snapshots();
        streamName = _searchStream;
      }
    }



    //Builds the main body content
    return StreamBuilder<QuerySnapshot>(
        stream: streamName,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong',
                style: TextStyle(
                  color: Colors.orange,
                  fontSize: 20,
                ));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[
                  CircularProgressIndicator(),
                  Text('Loading...',
                      style: TextStyle(
                        color: Colors.orange,
                        fontSize: 20,
                      ))
                ]);
          }

          if (snapshot.data!.docs.isEmpty) {
            return Container(
                alignment: Alignment.center,
                child: const Text("No results",
                    style: TextStyle(
                      color: Colors.orange,
                      fontSize: 20,
                    )));
          }
          else {
            return widget.grid
                ? GridPanel(snapshot, widget.gridNum, widget.locked, uid)
                : ListPanel(snapshot, widget.locked, uid);
          }
        });
  }
}
