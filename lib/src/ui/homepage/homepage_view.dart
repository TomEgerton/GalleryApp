import 'package:flutter/material.dart';
import 'package:galley_app_2/src/services/auth.dart';
import 'homepage_viewmodel.dart';
import 'package:galley_app_2/src/picture/main_body.dart';
import 'package:galley_app_2/src/ui/imagepages/uploadimage/upload_image_view.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final viewModel = HomePageViewModel();

  int gridCount = 0; //Used to check which grid layout is displaying
  int gridNum = 2; //Sets how many columns the grid will display
  bool grid = true; //Checks if the grid or list is selected
  bool locked = true; //Checks if changes are locked
  bool shared = false;

  TextEditingController searchControl =
      TextEditingController(); //The control for the search form
  String searchText =
      ''; //The variable used to pass the search form text to the MainBody widget
  var streamVal = AuthService().homeQuery(false);

  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //Ensures the search box drops focus when the user taps on the page
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
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
          actions: [
            PopupMenuButton(
              child: const Icon(Icons.more_vert, color: Colors.white, size: 30),
              itemBuilder: (BuildContext context) => [
                PopupMenuItem(
                    child: Text("Name"),
                    value: AuthService().nameQuery(shared)),
                PopupMenuItem(
                    child: Text("Oldest"),
                    value: AuthService().oldQuery(shared)),
                PopupMenuItem(
                    child: Text("Newest"),
                    value: AuthService().newestQuery(shared)),
                PopupMenuItem(
                    child: Text("Favourites"),
                    value: AuthService().favQuery(shared)),
              ],
              //Sets the stream value for the MainBody widget to know what stream to display
              onSelected: (stream) {
                setState(() {
                  streamVal = stream;
                  searchControl.clear();
                });
              },
            ),

            IconButton(
                //Switches to the grid view and swaps between 2-3 images per row when pressed again
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
              //Switches the view to the list
              color: Colors.white,
              icon: const Icon(Icons.sort),
              onPressed: () {
                setState(() {
                  grid = false;
                });
              },
            ),

            IconButton(
              //Locks the images to stop the user from making and changes
              icon:
                  Icon(locked ? Icons.lock_open_outlined : Icons.lock_outlined),
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
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              child: SizedBox(
                height: 50,
                child: TextFormField(
                  controller: searchControl,
                  decoration: const InputDecoration(
                    labelText: 'Search',
                  ),
                  onChanged: (value) {
                    setState(() {
                      searchText = searchControl.text;
                      streamVal = AuthService().textCheck(searchText, shared);
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
            Expanded(
              child: GestureDetector(
                child: MainBody(grid, gridNum, locked, streamVal),
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
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
                        shared = false;
                        AuthService().shareCheck(shared);
                        streamVal = AuthService().homeQuery(shared);
                        searchControl.clear();
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
                      shared = true;
                      ;
                      streamVal = AuthService().sharedQuery(shared);
                      searchControl.clear();
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
