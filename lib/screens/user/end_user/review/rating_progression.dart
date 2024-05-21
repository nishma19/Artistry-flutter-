import 'package:flutter/material.dart';

class RatingProgressionIndicator extends StatelessWidget {
  const RatingProgressionIndicator({
    super.key,required this.text,required this.value,
  });
  final String text;final double value;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            flex: 1,
            child: Text(
              text,
              style: TextStyle(fontSize: 15),
            )),
        Expanded(
          flex: 11,
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: LinearProgressIndicator(
              value: value,
              minHeight: 11,
              backgroundColor: Colors.grey,
              borderRadius: BorderRadius.circular(7),
              valueColor: const AlwaysStoppedAnimation(
                  Colors.blue),
            ),
          ),
        )
      ],
    );
  }
}