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

  fetchID() {
    final User user = _auth.currentUser as User;
    final uid = user.uid;
    return uid;
  }

  shareCheck(shared) {
    if (!shared) {
      return true;
    } else {
      return false;
    }
  }

  streamCheck(shared) {
    if (shareCheck(shared) == true) {
      var Query = FirebaseFirestore.instance
          .collection('photos')
          .where('userID', isEqualTo: fetchID());
      return Query;
    } else {
      var Query = FirebaseFirestore.instance
          .collection('photos')
          .where('Shared', isEqualTo: true);
      return Query;
    }
  }

  nameQuery(shared) {
    return streamCheck(shared).orderBy('title').snapshots();
  }

  favQuery(shared) {
    return streamCheck(shared).where('Favourite', isEqualTo: true).snapshots();
  }

  oldQuery(shared) {
    return streamCheck(shared).orderBy('createdAt').snapshots();
  }

  newestQuery(shared) {
    return streamCheck(shared)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  sharedQuery(shared) {
    return streamCheck(shared).snapshots();
  }

  homeQuery(shared) {
    return streamCheck(shared).snapshots();
  }

  textCheck(searchText, shared) {
    if (searchText != '') {
      return streamCheck(shared)
          .where(
            'title',
            isGreaterThanOrEqualTo: searchText,
            isLessThan: searchText.substring(0, searchText.length - 1) +
                String.fromCharCode(
                    searchText.codeUnitAt(searchText.length - 1) + 1),
          )
          .snapshots();
    } else {
      return sharedQuery(shared);
    }
  }
}
