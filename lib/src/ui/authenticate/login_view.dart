import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:galley_app_2/src/ui/homepage/homepage_view.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // User is not signed in
        if (!snapshot.hasData) {
          return SignInScreen(
              headerBuilder: (context, constraints, _) {
                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: Center(
                      child: Column(children: const <Widget>[
                    Icon(Icons.image, color: Colors.orange, size: 64),
                    Text("Gallery App",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            color: Colors.orange)),
                  ])),
                );
              },
              providerConfigs: const [
                EmailProviderConfiguration(),
              ]);
        }
        // Render your application if authenticated
        return Home();
      },
    );
  }
}
