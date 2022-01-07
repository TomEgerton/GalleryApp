import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PanelButtons extends StatefulWidget {
  final data;
  final selectedDoc;

  const PanelButtons(this.data, this.selectedDoc, {Key? key}) : super(key: key);

  @override
  _PanelButtonsState createState() => _PanelButtonsState();
}

class _PanelButtonsState extends State<PanelButtons> {
  TextEditingController rename = TextEditingController();
  bool _validate = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Expanded(
            child: PopupMenuButton(
          child: const Icon(Icons.more_vert, color: Colors.orange, size: 30),
          itemBuilder: (BuildContext context) => [
            PopupMenuItem(
                child: Text(widget.data['Shared'] ? "Unshare" : "Share"),
                value: 1),
            const PopupMenuItem(child: Text("Rename"), value: 2),
            const PopupMenuItem(child: Text("Remove"), value: 3),
          ],
          onSelected: (int index) {
            if (index == 1) {
              setState(() {
                if (widget.data['Shared']) {
                  var selection = false;
                  updatePhotoShare(widget.selectedDoc, selection);
                } else {
                  var selection = true;
                  updatePhotoShare(widget.selectedDoc, selection);
                }
              });
            }

            if (index == 2) {
              showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  content: TextField(
                    controller: rename,
                    decoration: InputDecoration(
                      hintText: widget.data['title'],
                      labelText: "Rename Image",
                      errorText: _validate ? 'Title Can\'t Be Empty' : null,
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'Cancel'),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        if (!rename.text.isEmpty) {
                          Navigator.pop(context, 'OK');
                          updatePhotoName(widget.selectedDoc, rename.text);
                          rename.clear();
                        } else {
                          setState(() {
                            _validate = false;
                          });
                        }
                      },
                      child: const Text('Submit'),
                    ),
                  ],
                ),
              );
            }
            if (index == 3) {
              setState(() {
                deleteUser(widget.selectedDoc);
              });
            }
          },
        )),
        Expanded(
          child: IconButton(
            icon: Icon(
              widget.data['Favourite']
                  ? Icons.favorite
                  : Icons.favorite_outline,
              color: Colors.orange,
            ),
            onPressed: () {
              setState(() {
                if (widget.data['Favourite']) {
                  var selection = false;
                  updatePhotoFav(widget.selectedDoc, selection);
                } else {
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

Future<void> updatePhotoName(data, rename) {
  return photo
      .doc(data)
      .update({'title': rename})
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
