

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AuthService {
  // register
  //login
  // logout
  //alrady logined



  Future<DocumentSnapshot> loginUser(String? email, String password) async {
    UserCredential userData = await FirebaseAuth.instance
        .signInWithEmailAndPassword(
        email: email.toString(), password: password.toString());

    final artistSnap = await FirebaseFirestore.instance
        .collection('login')
        .doc(userData.user!.uid)
        .get();
    var token = await userData.user!.getIdToken();

    if(artistSnap['role']=="artist"){

      final artistSnap = await FirebaseFirestore.instance
          .collection('artist')
          .doc(userData.user!.uid)
          .get();

      SharedPreferences _pref = await SharedPreferences.getInstance();
      _pref.setString('token', token!);
      _pref.setString('name', artistSnap['name']);
      _pref.setString('email', artistSnap['email']);
      _pref.setString('phone', artistSnap['phone']);
      _pref.setString('cate', artistSnap['category']);
      _pref.setString('id',artistSnap['id']);
      _pref.setString('role', artistSnap['role']);
      _pref.setString('address', artistSnap['address']);
      _pref.setString('businessDetails', artistSnap['businessDetails']);
      _pref.setString('links', artistSnap['links']);
      _pref.setString('price', artistSnap['price'].toString());

    }else if(artistSnap['role']=='user'){


      final artistSnap = await FirebaseFirestore.instance
          .collection('user')
          .doc(userData.user!.uid)
          .get();
      SharedPreferences _pref = await SharedPreferences.getInstance();
      _pref.setString('token', token!);
      _pref.setString('name', artistSnap['name']);
      _pref.setString('id',artistSnap['id']);
      _pref.setString('email', artistSnap['email']);
      _pref.setString('phone', artistSnap['phone']);
      _pref.setString('address', artistSnap['address']);





      _pref.setString('role', artistSnap['role']);


    }else if(artistSnap['role']=='admin'){



      SharedPreferences _pref = await SharedPreferences.getInstance();
      _pref.setString('token', token!);
      _pref.setString('name', "admin");
      _pref.setString('email', email.toString());
      _pref.setString('phone', "9895663498");

      _pref.setString('id',artistSnap['id']);
      _pref.setString('role', artistSnap['role']);


    }




    return artistSnap;
  }

  Future<void>logout()async{

    SharedPreferences _pref=await SharedPreferences.getInstance();
    _pref.clear();

    await FirebaseAuth.instance.signOut();


  }



  Future<bool> isLoggedin() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    String? _token = await pref.getString('token');

    // checking if there a token
    if (_token == null) {
      return false;
    } else {
      return true;
    }
  }
}
