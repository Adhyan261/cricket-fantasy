import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../screen/login_signup/login_page.dart';
import '../screen/login_signup/registration_screen.dart';

class AuthService {
  final FirebaseAuth _auth;

  AuthService(this._auth);

  Stream<User?> get authStateChanges => _auth.idTokenChanges();

  Future<String> login(String email,String password) async{
    try{
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return "logged in";
    }
    on FirebaseAuthException catch(e)
    {
      return e.message.toString();
    }
  }

  Future<String> register(String email,String password,String name,String phone) async{
    try{
      await _auth.createUserWithEmailAndPassword(email: email, password: password).then((value) async {
        User? user = FirebaseAuth.instance.currentUser;

        await FirebaseFirestore.instance.collection('Users').doc(user?.uid).set({
          'uid':user?.uid,
          'email':user?.email,
          'name':name,
          'phone':phone,
        });
      });
      return "signed up";
    }
    on FirebaseAuthException catch(e)
    {
      return e.message.toString();
    }
  }
}