import 'package:artistry/services/auth_service.dart';
import 'package:artistry/widgets/apptext.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminProfilePage extends StatefulWidget {
  const AdminProfilePage({super.key});

  @override
  State<AdminProfilePage> createState() => _AdminProfilePageState();
}

class _AdminProfilePageState extends State<AdminProfilePage> {


  var role;
  var name;
  var id;
  var email;
  var phone;
  var cat;
  var address;



  getData() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();

    role = await _pref.getString('role');


    name = await _pref.getString('name');
    id = await _pref.getString('id');
    email = await _pref.getString('email');
    phone = await _pref.getString('phone');
    address = await _pref.getString('address');






    print(id);
    setState(() {});
  }

  @override
  void initState() {
    getData();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(

        title: AppText(data: name,color: Colors.black,),
        actions: [
          IconButton(onPressed: ()async{
            await AuthService().logout().then((value) => Navigator.pushNamedAndRemoveUntil(context, 'login', (route) => false));

          }, icon: Icon(Icons.logout))
        ],
      ),


    );
  }
}
