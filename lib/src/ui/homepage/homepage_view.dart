import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'homepage_viewmodel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:galley_app_2/main.dart';
import 'package:galley_app_2/src/services/auth.dart';
import 'package:galley_app_2/src/picture/mainbody.dart';
import 'package:galley_app_2/src/picture/listpanel.dart';
import 'package:galley_app_2/src/ui/imagepages/uploadimage/uploadimageview.dart';
import 'package:galley_app_2/src/picture/mainbody.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final viewModel = HomePageViewModel();
  int gridCount = 0;
  int gridNum = 2;
  bool grid = true;
  String order = 'Name';
  bool locked = true;
  int streamVal = 0;
  TextEditingController searchControl = TextEditingController();
  String searchText = '';

  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        extendBody: true,
        appBar: AppBar(
          leading: IconButton(
              color: Colors.white,
              onPressed: viewModel.logoutButton,
              icon: const Icon(Icons.logout)), //LOGOUT BUTTON
          title: const Text('Gallery App',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
          actions: [
            PopupMenuButton(
              child: Icon(Icons.more_vert, color: Colors.white, size: 30),
              itemBuilder: (BuildContext context) => [
                PopupMenuItem(child: Text("Name"), value: 1),
                PopupMenuItem(child: Text("Oldest"), value: 2),
                PopupMenuItem(child: Text("Newest"), value: 3),
                PopupMenuItem(child: Text("Favourites"), value: 4),
              ],
              onSelected: (int index) {
                if (index == 1) {
                  setState(() {
                    streamVal = 0;
                  });
                }

                if (index == 2) {
                  setState(() {
                    streamVal = 1;
                  });
                }

                if (index == 3) {
                  setState(() {
                    streamVal = 2;
                  });
                }

                if (index == 4) {
                  setState(() {
                    streamVal = 3;
                  });
                }
              },
            ),

            IconButton(
                color: Colors.white,
                onPressed: () {
                  setState(
                    () {
                      if (gridCount == 0) {
                        grid = true;
                        gridNum = 2;
                        gridCount++;
                      } else if (gridCount == 1) {
                        grid = true;
                        gridNum = 3;
                        gridCount = 0;
                      }
                    },
                  );
                },
                icon: const Icon(Icons.grid_view_outlined)), //GRID CHANGE

            IconButton(
              color: Colors.white,
              icon: const Icon(Icons.sort),
              onPressed: () {
                setState(() {
                  grid = false;
                });
              },
            ),

            IconButton(
              icon: Icon(locked ? Icons.lock_open_outlined : Icons.lock_outlined),
              color: Colors.white,
              onPressed: () {
                setState(() {
                  if (locked == false) {
                    locked = true;
                  } else {
                    locked = false;
                  }
                });
              },
            ),
          ],
          backgroundColor: Colors.orange,
        ),
        resizeToAvoidBottomInset: false,
        body: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              child: Container(
                height: 50,
                child: TextFormField(
                  controller: searchControl,
                  decoration: InputDecoration(
                    hintText: 'Search',
                  ),
                  onChanged: (value) {
                    setState(() {
                      searchText = searchControl.text;
                    });
                  },


                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Add a valid name";
                    }
                  },
                ),
              ),
            ),
            Container(
              child: Expanded(
                child: GestureDetector(
                  child: MainBody(grid, gridNum, locked, streamVal, searchText),
                  onTap: () {
                    FocusScope.of(context).unfocus();
                  },
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          color: Colors.orange,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                IconButton(
                    icon: const Icon(
                      Icons.home_outlined,
                      color: Colors.white,
                      size: 35,
                    ),
                    onPressed: () {
                      setState(() {
                        streamVal = 0;
                      });
                    }),
                const Text('Home',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white)),
              ]),
              Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                IconButton(
                  icon: const Icon(
                    Icons.people_outlined,
                    color: Colors.white,
                    size: 35,
                  ),
                  onPressed: () {
                    setState(() {
                      streamVal = 4;
                    });
                  },
                ),
                const Text('Shared',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white)),
              ]),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => UploadImagePage()));
            },
            child: const Icon(Icons.add_a_photo_outlined, color: Colors.white)),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}
