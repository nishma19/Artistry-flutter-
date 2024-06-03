import 'package:artistry/firebase_options.dart';

import 'package:artistry/screens/admin/admin_usermanagement.dart';
import 'package:artistry/screens/admin/admin_dashboard.dart';
import 'package:artistry/screens/admin/notification.dart';
import 'package:artistry/screens/admin/user_details.dart';
import 'package:artistry/screens/common/addinfo.dart';
import 'package:artistry/screens/user/Artist_user/Artist_nav_bar.dart';
import 'package:artistry/screens/user/Artist_user/Artist_notification_page.dart';
import 'package:artistry/screens/user/Artist_user/aritst_homepage.dart';
import 'package:artistry/screens/user/end_user/notification_user.dart';
import 'package:artistry/screens/user/end_user/art_bottom_nav.dart';
import 'package:artistry/screens/user/end_user/art_detail.dart';
import 'package:artistry/screens/user/end_user/bottom_navigation.dart';
import 'package:artistry/screens/common/login_page.dart';
import 'package:artistry/screens/common/register_tab.dart';
import 'package:artistry/screens/common/splash_page.dart';
import 'package:artistry/screens/user/Artist_user/artist_profile.dart';
import 'package:artistry/screens/user/end_user/cart_page.dart';
import 'package:artistry/screens/user/end_user/booking_page.dart';
import 'package:artistry/screens/user/end_user/order_now_page.dart';
import 'package:artistry/screens/user/end_user/review/write_review.dart';
import 'package:artistry/screens/user/end_user/subscription_plan.dart';
import 'package:artistry/screens/user/end_user/artist_detail.dart';

import 'package:artistry/screens/user/end_user/user_forgot_password.dart';
import 'package:artistry/screens/user/end_user/user_front_page.dart';
import 'package:artistry/screens/user/end_user/user_homepage.dart';
import 'package:artistry/screens/user/end_user/user_register_page.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/':(context)=>SplashPage(),
        'login':(context)=>LoginPage(),
        'forgot':(context)=>UserForgotPassword(),
        'register':(context)=>UserRegisterPage(),
        'registertab':(context)=>RegisterTab(),
        'addinfo':(context)=>AddInfoPage(),
        'userhome':(context)=>UserHomePage(),
        'artistprofile':(context)=>ArtistProfilePage(),
        'artistnoticn':(context)=>ArtistNotificationPage(),
        'artistnavbar':(context)=>ArtistBottomNavBarPage(),
        'artisthome':(context)=>ArtistHomePage(),
        'usermanagement': (context) => UserManagement(),

        'admindashboard':(context)=> AdminDashboard(),
        // 'userdetails':(context)=> UserDetailScreen(),

        'navbar':(context)=>BottomNavigationPage(),
        'artistdetail':(context)=>Artistdetails(),
        'artdetail':(context)=>ArtDetails(),
        'artbottomnav':(context)=>ArtBottomNav(),

        'cartpage':(context)=>CartPage(),
        'usernotifcn':(context)=>UserNotificationsPage(),
        'notify':(context)=>NotificationAccess(),
        'writereview':(context)=>WriteReviewPage(),
        'subscriptionplan':(context)=>SubscriptionPlanScreen(),
        'ordernow':(context)=>OrderNowPage(),






      },
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

          appBarTheme: AppBarTheme(
            backgroundColor: Colors.transparent,
              titleTextStyle: TextStyle(
                  color: Colors.white,fontSize: 18
              ),

              iconTheme: IconThemeData(
                  color: Color(0xffD77272)
              )
          ),
          textTheme: TextTheme(
            displayLarge: TextStyle(
              color: Color(0xffD77272),
                fontSize: 32,fontWeight: FontWeight.w500
            ),
            displaySmall: TextStyle(color:Color(0xffD77272),fontSize: 24,fontWeight: FontWeight.w400),
            labelSmall: TextStyle(color: Colors.black54,),
            titleSmall: TextStyle(color: Color(0xffD77272),),

          )
      ),
      // home: SplashPage(
      //
      //
      // ),
    );
  }
}
