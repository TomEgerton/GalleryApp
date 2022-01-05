import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class panelButtons extends StatefulWidget {
  var data;
  var selectedDoc;

  panelButtons(this.data, this.selectedDoc);

  @override
  _panelButtonsState createState() => _panelButtonsState();
}

class _panelButtonsState extends State<panelButtons> {
  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Expanded(
              child: PopupMenuButton(
                child: Icon(Icons.more_vert, color: Colors.orange, size:30),
                itemBuilder: (BuildContext context) => [
                  PopupMenuItem(child: Text( widget.data['Shared'] ? "Unshare" : "Share"), value: 1),
                  PopupMenuItem(child: Text("Edit"), value: 2),
                  PopupMenuItem(child: Text("Remove"), value: 3),
                ],
                onSelected: (int index){
                  if(index == 1){
                    setState(() {
                      if(widget.data['Shared']){
                        var selection = false;
                        updatePhotoShare(widget.selectedDoc, selection);
                      }
                      else{
                        var selection = true;
                        updatePhotoShare(widget.selectedDoc, selection);
                      }
                    });
                  }

                  if(index == 2){

                  }

                  if(index == 3){

                    setState(() {

                      deleteUser(widget.selectedDoc);
                    });

                  }
                },

              )
          ),
          Expanded(
            child: IconButton(
              icon: Icon(
                widget.data['Favourite'] ? Icons.favorite : Icons
                    .favorite_outline,
                color: Colors.orange,),
              onPressed: () {
                setState(() {
                  if (widget.data['Favourite']) {
                    var selection = false;
                    updatePhotoFav(widget.selectedDoc, selection);
                  }
                  else {
                    var selection = true;
                    updatePhotoFav(widget.selectedDoc, selection);
                  }
                });
              },
            ),
          ),
        ],
      );
  }
}

CollectionReference photo = FirebaseFirestore.instance.collection('photos');

Future<void> updatePhotoFav(data, selection) {

  return photo
      .doc(data)
      .update({'Favourite': selection})
      .then((value) => print("Photo Updated"))
      .catchError((error) => print("Failed to update photo: $error"));
}

Future<void> updatePhotoShare(data, selection) {

  return photo
      .doc(data)
      .update({'Shared': selection})
      .then((value) => print("Photo Updated"))
      .catchError((error) => print("Failed to update photo: $error"));
}

Future<void> deleteUser(data) {
  return photo
      .doc(data)
      .delete()
      .then((value) => print("User Deleted"))
      .catchError((error) => print("Failed to delete user: $error"));
}