
import 'package:artistry/screens/user/end_user/review/rating_progression.dart';
import 'package:flutter/material.dart';
class OverAllRating extends StatelessWidget {
  const OverAllRating({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            flex: 3,
            child: Text(
              '4.8',
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 25),
            )),
        Expanded(
          flex: 7,
          child: Column(
            children: [
              RatingProgressionIndicator(text: '5', value: 1.0,),
              RatingProgressionIndicator(text: '4', value: 0.8,),
              RatingProgressionIndicator(text: '3', value: 0.76,),
              RatingProgressionIndicator(text: '2', value: 0.3,),
              RatingProgressionIndicator(text: '1', value: 0.2,),
            ],
          ),
        )
      ],
    );
  }
}