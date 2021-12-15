import 'package:galley_app_2/src/ui/homepage/homepage_view.dart';
import 'package:galley_app_2/src/services/auth.dart';

class HomePageViewModel {
  final AuthService _auth = AuthService();

  void logoutButton() async {
    await _auth.signOut();
  }

  void gridButton(){

  }

  void sort(){

  }

  void lock(){

  }

  void home(){

  }

  void shared(){

  }

}