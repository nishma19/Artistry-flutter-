// import 'package:artistry/widgets/apptext.dart';
// import 'package:flutter/material.dart';
//  import 'dart:math' as math;
//
// class UserFrontPage extends StatefulWidget {
//   const UserFrontPage({super.key});
//
//   @override
//   State<UserFrontPage> createState() => _UserFrontPageState();
// }
//
// class _UserFrontPageState extends State<UserFrontPage> {
//   @override
//   Widget build(BuildContext context) {
//
//
//     return Scaffold(
//       appBar: AppBar(
//         iconTheme: IconThemeData(
//           color: Color(0xff0A123B)
//         ),
//       ),
//
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//
//
//           children: [
//             InkWell( onTap: (){
//               setState(() {
//
//               });
//             },
//               child: Container(
//
//                height: 200,
//                 width: 300,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadiusDirectional.circular(130),
//                     gradient: LinearGradient(colors: [
//                       Color(0xff9BA1BF),
//                       Color(0xff77769D),
//                       Color(0xff404D8F),
//                       Color(0xff0A123B),
//                     ],
//                         stops: [0.1,0.20,0.50,0.75],
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight,
//                         transform:GradientRotation(math.pi/4)
//                     )
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Image.asset("assets/img/performer log.png",height: 120,),
//                     AppText(data: "PERFORMER",color: Colors.white,size: 25,fw: FontWeight.w800,)
//                   ],
//                 ),
//
//               ),
//             ),
//             SizedBox(height: 20,),
//             Container(
//               height: 200,
//               width: 300,
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadiusDirectional.circular(130),
//                   gradient: LinearGradient(colors: [
//                     Color(0xff9BA1BF),
//                     Color(0xff77769D),
//                     Color(0xff404D8F),
//                     Color(0xff0A123B)
//                   ],
//                  stops: [0.1,0.20,0.50,0.75],
//                  begin: Alignment.topLeft,
//                  end: Alignment.bottomRight,
//                  transform:GradientRotation(math.pi/4)
//                   )
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Image.asset("assets/img/craft log.png",height: 120,),
//                   AppText(data: "CRAFTER",color: Colors.white,size: 25,fw: FontWeight.w800,)
//                 ],
//               ),
//
//             )
//
//           ],
//         ),
//       ),
//     );
//   }
// }
