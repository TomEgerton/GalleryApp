import 'package:flutter/material.dart';
import 'homepage_viewmodel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:galley_app_2/main.dart';
import 'package:galley_app_2/src/services/auth.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final viewModel = HomePageViewModel();

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        leading: IconButton(color: Colors.white,
            onPressed: viewModel.logoutButton,
            icon: const Icon(Icons.logout)),
        title: const Text('Gallery App',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        actions:  [

          IconButton(color: Colors.white,
              onPressed: (){},
              icon: const Icon(Icons.grid_view_outlined)),

          IconButton(color: Colors.white,
              onPressed: (){},
              icon: const Icon(Icons.sort)),

          IconButton(color: Colors.white,
              onPressed: (){},
              icon: const Icon(Icons.lock_outlined)),
        ],
        backgroundColor: Colors.orange,
      ),

      body: Center(
        child: Column(children: const <Widget>[
          Text("Hello this is the main page"),],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        color: Colors.orange,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[

            Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[

                  IconButton(icon: const Icon(Icons.home_outlined,
                    color: Colors.white,
                    size: 35,), onPressed: (){}),

                  const Text('Home', style: TextStyle(fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white)),
                ]
            ),

            Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[

                  IconButton(icon: const Icon(Icons.people_outlined,
                    color: Colors.white,
                    size: 35,), onPressed: (){},
                  ),

                  const Text('Shared', style: TextStyle(fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white)),
                ]
            ),
          ],
        ),
      ),



      floatingActionButton: FloatingActionButton(
        onPressed: () {
        }, child: const Icon(Icons.add_a_photo_outlined, color: Colors.white),
      ),


      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

    );
  }
}