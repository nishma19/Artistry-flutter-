import 'package:artistry/widgets/apptext.dart';
import 'package:flutter/material.dart';

class AddMedia extends StatefulWidget {
  const AddMedia({super.key});

  @override
  State<AddMedia> createState() => _AddMediaState();
}

class _AddMediaState extends State<AddMedia> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppText(data: "Add Media",color: Color(0xFFB3261E),size: 20,),
        backgroundColor:  Color(0xffFFF5E9),



      ),

      body: Container(
        height: double.infinity,
        width: double.infinity,
        child:Center(
          child: CircleAvatar(radius: 35,backgroundColor: Color(0xffFFF5E9),
            child: Icon(Icons.add_a_photo,color: Color(0xffD77272),),),
        ),
      ),
    );
  }
}
