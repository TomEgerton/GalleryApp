import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:galley_app_2/src/picture/gridpanel.dart';
import 'package:galley_app_2/src/picture/listpanel.dart';

//The main body that contains all the image panels

class MainBody extends StatefulWidget {
  final bool grid; //Allows the body to display the grid or list
  final int gridNum; //Sets the amount of panels per row on the grid
  final bool locked; //Locks the images
  final streamVal;

  MainBody(
      this.grid, this.gridNum, this.locked, this.streamVal);

  @override
  _MainBodyState createState() => _MainBodyState();
}

class _MainBodyState extends State<MainBody> {
  @override
  Widget build(BuildContext context) {

    //Builds the main body content
    return StreamBuilder<QuerySnapshot>(
        stream: widget.streamVal,
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
                ? GridPanel(snapshot, widget.gridNum, widget.locked)
                : ListPanel(snapshot, widget.locked);
          }
        });
  }
}
