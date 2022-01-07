import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:galley_app_2/src/ui/imagepages/viewimage/selectimage.dart';

class ViewImage extends StatefulWidget {
  var data;
  var uid;

  ViewImage(this.data, this.uid, {Key? key}) : super(key: key);

  @override
  _ViewImageState createState() => _ViewImageState();
}

class _ViewImageState extends State<ViewImage> {
  @override
  Widget build(BuildContext context) {

    //Converts the saved time stamp to just display day month and year format
    var date = DateTime.fromMicrosecondsSinceEpoch(widget.data['createdAt'].microsecondsSinceEpoch);
    String formattedDate = DateFormat('dd/MM/yyyy').format(date);

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
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: GestureDetector(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            SelectImage(widget.data['Download URL']))),
                child: Image.network(widget.data['Download URL'],
                    width: 300, height: 300, fit: BoxFit.cover),
              )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(children: <Widget>[
              //Displays the image name
              Text(widget.data['title'],
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: Colors.orange)),

              //Displays the userID of the uploaded image
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text("Uploaded by: ${widget.data['userID']}",
                    style: const TextStyle(fontSize: 16, color: Colors.orange)),
              ),

              //Displays the date uploaded
              Text("Uploaded on: $formattedDate",
                  style: const TextStyle(fontSize: 16, color: Colors.orange)),

              //Checks to see if the image is a favourite. Only displays if it is the users own image
              widget.uid == widget.data['userID']
                  ? widget.data['Favourite']
                      ? const Padding(
                          padding: EdgeInsets.symmetric(vertical: 18),
                          child: Text("This is a favourite",
                              style: TextStyle(
                                  fontSize: 16, color: Colors.orange)),
                        )
                      : Container()
                  : Container(),
            ]),
          ),
        ],
      )),
    );
  }
}
