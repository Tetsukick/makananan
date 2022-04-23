import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {

  final String uid;
  DatabaseService({
    this.uid
  });

  // Collection reference
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');

  // update userdata
  Future updateUserData(String fullName, String email, String password) async {
    return await userCollection.doc(uid).set({
      'fullName': fullName,
      'email': email,
      'password': password,
      'likes': []
    });
  }


  // get if liked restaurants
  Future togglingLikes(dynamic restaurantId) async {
    DocumentReference docRef = userCollection.doc(uid);
    DocumentSnapshot doc = await docRef.get();

    List<dynamic> likes = await doc.get('likes');

    if(likes.contains(restaurantId)) {
      docRef.update(
        {
          'likes': FieldValue.arrayRemove([restaurantId])
        }
      );
    }
    else {
      docRef.update(
        {
          'likes': FieldValue.arrayUnion([restaurantId])
        }
      );
    }
  }


  // get user data
  Future getUserData(String email) async {

    QuerySnapshot snapshot = await userCollection.where('email', isEqualTo: email).get();
    print(snapshot.docs[0].data);
    return snapshot;
  }
}