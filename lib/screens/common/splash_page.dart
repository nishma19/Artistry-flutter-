

import 'package:artistry/screens/common/login_page.dart';
import 'package:artistry/services/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();

}

class _SplashPageState extends State<SplashPage> {


  AuthService _authService = AuthService();
  bool isLogin = false;
  var role;

  checkLogin() async {
    isLogin = await _authService.isLoggedin();

    if (isLogin == true) {
      if (role == 'user') {
        Navigator.pushNamedAndRemoveUntil(
            context, 'navbar', (route) => false);
      } else if (role == 'artist') {
        Navigator.pushNamedAndRemoveUntil(context, 'artistnavbar', (route) => false);
      } else if (role == 'admin') {
        Navigator.pushNamedAndRemoveUntil(
            context, 'admindashboard', (route) => false);
      } else {
        Navigator.pushNamedAndRemoveUntil(context, 'login', (route) => false);
      }
    }else {
      Navigator.pushNamedAndRemoveUntil(context, 'login', (route) => false);
    }
  }

  getData() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();

    role = await _pref.getString('role');
  }

  @override
  void initState() {
    getData();
    Future.delayed(Duration(seconds:5), () {
      checkLogin();
    });

    super.initState();
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Image.asset("assets/img/logoartnew.png"),
        ),

      ),

    );
  }
}
