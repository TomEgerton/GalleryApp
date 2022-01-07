import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;


  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }

  }
  fetchID(){
    final User user = _auth.currentUser as User;
    final uid = user.uid;
    return uid;
  }

  nameQuery(){
    return FirebaseFirestore.instance
        .collection('photos')
        .where('userID', isEqualTo: fetchID())
        .orderBy('title')
        .snapshots();
  }

  favQuery(){
    return FirebaseFirestore.instance
        .collection('photos')
        .where('userID', isEqualTo: fetchID())
        .where('Favourite', isEqualTo: true)
        .snapshots();
  }

  oldQuery(){
    return FirebaseFirestore.instance
        .collection('photos')
        .where('userID', isEqualTo: fetchID())
        .orderBy('createdAt')
        .snapshots();
  }

  newestQuery(){
    return FirebaseFirestore.instance
        .collection('photos')
        .where('userID', isEqualTo: fetchID())
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  sharedQuery(){
    return FirebaseFirestore.instance
        .collection('photos')
        .where('Shared', isEqualTo: true)
        .snapshots();
  }

  textCheck(searchText, shared){
    if (searchText != '') {
      if (!shared) {
        return FirebaseFirestore.instance
            .collection('photos')
            .where('userID', isEqualTo: fetchID())
            .where(
          'title',
          isGreaterThanOrEqualTo: searchText,
          isLessThan: searchText.substring(
              0, searchText.length - 1) +
              String.fromCharCode(searchText
                  .codeUnitAt(searchText.length - 1) +
                  1),).snapshots();
      }

      if (shared) {
        return FirebaseFirestore.instance
            .collection('photos')
            .where(
          'title',
          isGreaterThanOrEqualTo: searchText,
          isLessThan: searchText.substring(
              0, searchText.length - 1) +
              String.fromCharCode(searchText
                  .codeUnitAt(searchText.length - 1) +
                  1),)
            .where('Shared', isEqualTo: true)
            .snapshots();
      }

    }
    else if (shared){
      return sharedQuery();
    }

    else{
      return nameQuery();
    }

  }
}
