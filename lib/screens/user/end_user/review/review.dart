
import 'package:artistry/screens/user/end_user/review/Custom_rating_bar.dart';
import 'package:artistry/screens/user/end_user/review/overall_rating.dart';
import 'package:artistry/screens/user/end_user/review/user_review_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:iconsax/iconsax.dart';



class UserReviewPage extends StatefulWidget {
  const UserReviewPage({super.key});

  @override
  State<UserReviewPage> createState() => _UserReviewPageState();
}

class _UserReviewPageState extends State<UserReviewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Reviews & Ratings",
          style: TextStyle(color: Colors.white),
        ),
      ),

      body:  SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(

            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                  "Ratings & Reviews for users vjhg vujlm nbhggg  bfg  bghj aaaa fff bbb cccc hbjnj hbhbhbh  hftdtg  vtfrdtg vggt gvfyh gghuh"),
              const SizedBox(
                height: 15,
              ),
              const  OverAllRating(),

              // RatingBarIndicator(rating: 4.5,)
              CustomRatingBarIndicator(rating: 3.5),
              Text("11,611",style: TextStyle(fontSize: 12),),
              const SizedBox(height: 15,),
              const   UserReviewCrd(),
              const   UserReviewCrd(),
              const   UserReviewCrd(),
            ],
          ),
        ),
      ),
    );
  }
}
