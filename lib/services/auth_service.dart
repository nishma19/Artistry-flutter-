import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  Future<DocumentSnapshot?> loginUser(String? email, String password) async {
    try {
      UserCredential userData = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email!, password: password);

      final userSnap = await FirebaseFirestore.instance
          .collection('login')
          .doc(userData.user!.uid)
          .get();
      var token = await userData.user!.getIdToken();

      if (userSnap.exists && userSnap['role'] == "artist") {
        final artistSnap = await FirebaseFirestore.instance
            .collection('artist')
            .doc(userData.user!.uid)
            .get();

        // Handle status field type correctly
        var status = artistSnap['status'];
        if (status is String) {
          status = int.tryParse(status);
        }

        if (status == 1) {
          SharedPreferences _pref = await SharedPreferences.getInstance();
          _pref.setString('token', token!);
          _pref.setString('name', artistSnap['name']);
          _pref.setString('email', artistSnap['email']);
          _pref.setString('phone', artistSnap['phone']);
          _pref.setString('cate', artistSnap['category']);
          _pref.setString('id', artistSnap['id']);
          _pref.setString('role', artistSnap['role']);
          _pref.setString('address', artistSnap['address']);
          _pref.setString('businessDetails', artistSnap['businessDetails']);
          _pref.setString('links', artistSnap['links']);
          _pref.setString('price', artistSnap['price'].toString());

          return artistSnap;
        } else {
          await FirebaseAuth.instance.signOut();
          return null;
        }
      } else if (userSnap.exists && userSnap['role'] == 'user') {
        final userSnap = await FirebaseFirestore.instance
            .collection('user')
            .doc(userData.user!.uid)
            .get();
        SharedPreferences _pref = await SharedPreferences.getInstance();
        _pref.setString('token', token!);
        _pref.setString('name', userSnap['name']);
        _pref.setString('id', userSnap['id']);
        _pref.setString('email', userSnap['email']);
        _pref.setString('phone', userSnap['phone']);
        _pref.setString('address', userSnap['address']);
        _pref.setString('role', userSnap['role']);

        return userSnap;
      } else if (userSnap.exists && userSnap['role'] == 'admin') {
        SharedPreferences _pref = await SharedPreferences.getInstance();
        _pref.setString('token', token!);
        _pref.setString('name', "admin");
        _pref.setString('email', email);
        _pref.setString('phone', "9895663498");
        _pref.setString('id', userSnap['id']);
        _pref.setString('role', userSnap['role']);

        return userSnap;
      } else {
        await FirebaseAuth.instance.signOut();
        return null;
      }
    } catch (e) {
      print('Login error: $e');
      return null;
    }
  }

  Future<void> logout() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    _pref.clear();
    await FirebaseAuth.instance.signOut();
  }

  Future<bool> isLoggedin() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? _token = pref.getString('token');
    return _token != null;
  }
}
