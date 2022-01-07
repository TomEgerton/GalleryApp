import 'package:galley_app_2/src/services/auth.dart';

class HomePageViewModel {
  // Creates the Authentication service
  final AuthService _auth = AuthService();

  void logoutButton() async {
    // Calls the built auth service and logs the user out
    await _auth.signOut();
  }

}
