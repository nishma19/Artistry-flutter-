import 'package:artistry/widgets/apptext.dart';
import 'package:artistry/widgets/customtextformfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WriteReviewPage extends StatefulWidget {
  @override
  _WriteReviewPageState createState() => _WriteReviewPageState();
}

class _WriteReviewPageState extends State<WriteReviewPage> {
  TextEditingController _review=TextEditingController();
  double _rating = 0.0; // Variable to store the rating

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Color(0xffFFF5E9),
        title: AppText(data: "Write a review",color:Color(0xffD77272),size: 20,fw: FontWeight.w600 ,)
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Rating:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            // Rating stars
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.star),
                  onPressed: () {
                    setState(() {
                      _rating = 1.0;
                    });
                  },
                  color: _rating >= 1 ? Colors.amber : Colors.grey,
                ),
                IconButton(
                  icon: Icon(Icons.star),
                  onPressed: () {
                    setState(() {
                      _rating = 2.0;
                    });
                  },
                  color: _rating >= 2 ? Colors.amber : Colors.grey,
                ),
                IconButton(
                  icon: Icon(Icons.star),
                  onPressed: () {
                    setState(() {
                      _rating = 3.0;
                    });
                  },
                  color: _rating >= 3 ? Colors.amber : Colors.grey,
                ),
                IconButton(
                  icon: Icon(Icons.star),
                  onPressed: () {
                    setState(() {
                      _rating = 4.0;
                    });
                  },
                  color: _rating >= 4 ? Colors.amber : Colors.grey,
                ),
                IconButton(
                  icon: Icon(Icons.star),
                  onPressed: () {
                    setState(() {
                      _rating = 5.0;
                    });
                  },
                  color: _rating >= 5 ? Colors.amber : Colors.grey,
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Your Review:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            // Review text input field
            TextFormField(
              maxLines: 5,
              controller: _review,
              decoration: InputDecoration(focusColor: Color(0xffD77272),focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Color(0xffD77272),
                    width: 1.2,
                  )),

                hintText: 'Write your review here...',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xffD77272))
                ),
              ),
            ),
            // CustomTextFormField(
            //     maxlines: 6,
            //     controller: _review, hintText:'Write your review here...' ),
            SizedBox(height: 20),
            // Submit button
            // ElevatedButton(
            //
            //   onPressed: () {
            //     // Submit review logic
            //     // You can implement your logic here, such as saving the review to a database
            //     Navigator.pop(context); // Close the WriteReviewPage
            //   },
            //   child: Center(child: Text('Submit')),
            // ),
            InkWell(
              onTap: (){
                Navigator.pop(context);
              },
              child: Center(
                child: Container(height: 48,
                width: 250,
                decoration: BoxDecoration(
                  borderRadius: BorderRadiusDirectional.circular(20),
                  color: Color(0xffFFF5E9)
                ),

                child: Center(child: AppText(data: "Submit",size:20,color:Color(0xffD77272)  ,fw: FontWeight.w600,)),),
              ),
            )
          ],
        ),
      ),
    );
  }
}
