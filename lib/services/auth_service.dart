import 'package:firebase_auth/firebase_auth.dart' as FirebaseAuth;
import 'package:foodspace/helper/helper_functions.dart';
import 'package:foodspace/models/user.dart';
import 'package:foodspace/services/database_service.dart';

class AuthService {
  final FirebaseAuth.FirebaseAuth _auth = FirebaseAuth.FirebaseAuth.instance;


  // create user object based on FirebaseUser
  User _userFromFirebaseUser(FirebaseAuth.User user) {
    return (user != null) ? User(uid: user.uid) : null;
  }


  // sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      FirebaseAuth.UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseAuth.User user = result.user;
      return _userFromFirebaseUser(user);
    } catch(e) {
      print(e.toString());
      return null;
    }
  }


  // register with email and password
  Future registerWithEmailAndPassword(String fullName, String email, String password) async {
    try {
      FirebaseAuth.UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseAuth.User user = result.user;

      // Create a new document for the user with uid
      await DatabaseService(uid: user.uid).updateUserData(fullName, email, password);
      return _userFromFirebaseUser(user);
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

  //sign out
  Future signOut() async {
    try {
      await HelperFunctions.saveUserLoggedInSharedPreference(false);
      await HelperFunctions.saveUserEmailSharedPreference('');
      await HelperFunctions.saveUserNameSharedPreference('');

      return await _auth.signOut().whenComplete(() async {
        print("Logged out");
        await HelperFunctions.getUserLoggedInSharedPreference().then((value) {
          print("Logged in: $value");
        });
        await HelperFunctions.getUserEmailSharedPreference().then((value) {
          print("Email: $value");
        });
        await HelperFunctions.getUserNameSharedPreference().then((value) {
          print("Full Name: $value");
        });
      });
    } catch(e) {
      print(e.toString());
      return null;
    }
  }
}