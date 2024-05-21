import 'dart:ui';


import 'package:artistry/screens/user/end_user/review/Custom_rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';

class UserReviewCrd extends StatefulWidget {
  const UserReviewCrd({super.key});

  @override
  State<UserReviewCrd> createState() => _UserReviewCrdState();
}

class _UserReviewCrdState extends State<UserReviewCrd> {
  @override
  Widget build(BuildContext context) {
    return
      Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    backgroundImage: AssetImage(
                      "assets/img/profile.png",
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Text(
                    "John Doe",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
              IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            children: [
              const CustomRatingBarIndicator(rating: 4),
              const SizedBox(
                width: 10,

              ),
              Text("01 Nov,2023",style: Theme.of(context).textTheme.bodySmall,),
            ],
          ),
          const SizedBox(
            height: 5,
          ),

          ReadMoreText("the user interface of the app is quite intivitive.i was able to navigate and make participate . greate experience,good work guys,keep goingg.",
            trimLines: 2,
            trimMode: TrimMode.Line,
            trimExpandedText:'Read less' ,
            trimCollapsedText: 'Read more',
            moreStyle:  const TextStyle(fontSize: 14 ,fontWeight: FontWeight.bold,color: Colors.blue),
            lessStyle:const TextStyle(fontSize: 14 ,fontWeight: FontWeight.bold,color: Colors.blue) ,
          ),
          const SizedBox(
            height: 5,
          ),
          Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: Colors.grey.withOpacity(0.2),),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("PackBags",style: Theme.of(context).textTheme.bodySmall,) ,
                    Text("02 Nov ,2023",style: Theme.of(context).textTheme.bodySmall,)
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),

                ReadMoreText("The user interface of the app is quite intivitive.i was able to navigate and make participate . greate experience,good work guys,keep goingg.",
                  trimLines: 2,
                  trimMode: TrimMode.Line,
                  trimExpandedText:'Read less' ,
                  trimCollapsedText: 'Read more',
                  moreStyle:  const TextStyle(fontSize: 14 ,fontWeight: FontWeight.bold,color: Colors.blue),
                  lessStyle:const TextStyle(fontSize: 14 ,fontWeight: FontWeight.bold,color: Colors.blue) ,
                ),


              ],
            ),


          ),

          const SizedBox(
            height: 10,
          ),

        ],

      );
  }
}