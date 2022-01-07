import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:galley_app_2/src/services/storage.dart';

// The upload page, allows the user to select an image from their photos and uploads it to firebase
class UploadImagePage extends StatefulWidget {
  const UploadImagePage({Key? key}) : super(key: key);

  @override
  State<UploadImagePage> createState() => _UploadImagePageState();
}

class _UploadImagePageState extends State<UploadImagePage> {
  UploadTask? task;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  File? file;
  final ImagePicker _picker = ImagePicker();
  final FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController nameControl = TextEditingController();

  CollectionReference photos = FirebaseFirestore.instance.collection('photos');

  @override
  Widget build(BuildContext context) {
    final fileName = file != null ? basename(file!.path) : 'No File Selected';
    var imageURL = file;
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        leading: IconButton(
            color: Colors.white,
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.chevron_left)),
        title: const Text('Gallery App',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.orange,
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          file != null
              ? Image.file(imageURL!,
                  width: 200, height: 200, fit: BoxFit.cover)
              : Container(),
          ElevatedButton(
            onPressed: selectFile,
            child: Text("Select an Image"),
          ),
          file != null
              ? ElevatedButton(
                  child: Text("Remove Image"),
                  onPressed: () {
                    setState(() {
                      task = null;
                      file = null;
                    });
                  })
              : Container(),
          Text(fileName),
          Form(
            key: _formKey,
            child: Column(children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: TextFormField(
                  controller: nameControl,
                  decoration: InputDecoration(hintText: 'Add Image Name'),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Please add a name";
                    }
                  },
                ),
              ),
              ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      String name = nameControl.text;
                      await uploadFile(name);

                      setState(() => task = null);
                      setState(() => file = null);
                      nameControl.clear();
                    }
                  },
                  child: Text("Upload Image")),
            ]),
          ),
          task != null ? buildUploadStatus(task!) : Container(),
        ],
      )),
    );
  }

  Future selectFile() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;
    setState(() => file = File(image.path));
  }

  Future uploadFile(String name) async {
    if (file == null) return;
    final User user = auth.currentUser as User;
    final uid = user.uid;
    var imageName = file!.path.split('/').last;
    final destination = 'image/$uid/$imageName';
    task = FirebaseApi.uploadFile(destination, file!);
    setState(() {});
    if (task == null) return;
    final snapshot = await task!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    print('Download-Link: $urlDownload');

    addPhoto(name, uid, urlDownload);
  }

  Future<void> addPhoto(name, user, urlDownload) {
    // Call the user's CollectionReference to add a new user
    return photos
        .add({
          'title': name,
          'userID': user,
          'Download URL': urlDownload,
          'Favourite': false,
          'Shared': false,
          'createdAt': DateTime.now(),
        })
        .then((value) => print("Photo Added"))
        .catchError((error) => print("Failed to add photo: $error"));
  }

  Widget buildUploadStatus(UploadTask task) => StreamBuilder<TaskSnapshot>(
        stream: task.snapshotEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final snap = snapshot.data!;
            final progress = snap.bytesTransferred / snap.totalBytes;
            var percentage = (progress * 100).toStringAsFixed(2);
            var textnum = '$percentage %';
            if (percentage == '100.00') {
              textnum = 'Upload complete';
            }
            return Text(textnum,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange));
          } else {
            return Container();
          }
        },
      );
}
