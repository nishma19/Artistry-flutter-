import 'dart:io';
import 'dart:math';

import 'package:artistry/models/workshop_model.dart';
import 'package:artistry/services/workshop_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class CheckoutPage extends StatefulWidget {
  final String ?artistId;
  final String ?artistName;
  final Workshop? workshop;
  //final double totalPrice; // You need to calculate the total price based on your logic

  CheckoutPage({required this.workshop,this.artistId,this.artistName });

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  double estimatedTax = 0.0;
  double subtotal = 0.0;
  double total = 0.0;
  late Razorpay _razorpay = Razorpay();


  String? _uid;
  getData() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();



    // if (imggurl == null) {
    //   setState(() {
    //     imggurl = "assets/image/profile.png";
    //   });
    // }

    _uid = await _pref.getString(
      'id',
    );



    setState(() {


    });
  }
  List<String>? courses;


  void handlePaymentErrorResponse(PaymentFailureResponse response){

    /** PaymentFailureResponse contains three values:
     * 1. Error Code
     * 2. Error Description
     * 3. Metadata
     **/
    showAlertDialog(context, "Payment Failed", "Code: ${response.code}\nDescription: ${response.message}\nMetadata:${response.error.toString()}");
  }

  void handlePaymentSuccessResponse(PaymentSuccessResponse response) {

    /** Payment Success Response contains three values:
     * 1. Order ID
     * 2. Payment ID
     * 3. Signature
     **/

    if(response.paymentId!=null){








      try {
        print("helo jobinfee collected ${response.paymentId!}");
        // Open the generated PDF file
        if(response.paymentId!=null) {
          var id = Uuid().v1();
          WorkshopService _workshopService = WorkshopService();

          _workshopService.joinList(
              widget.artistId.toString(), _uid.toString());


          FirebaseFirestore.instance.collection('subscription').doc(id).set({
            'subId': id,
            'paymentid': response.paymentId,
            'artistId': widget.artistId,
            'userid': _uid,
            'workshopid': widget.workshop!.id,
            'status': 1,
            'amount': total,
            'createdat': DateTime.now(),
            'settlementStatus': 0
          }).then((value) {
            FirebaseFirestore.instance.collection('payments').doc(
                response.paymentId).set({

              'paymentid': response.paymentId,
              'artistId': widget.artistId,
              'userid': _uid,
              'workshopid': widget.workshop!.id,
              'status': 1,
              'amount': total,
              'tax': estimatedTax,
              'createdat': DateTime.now(),
              'settlementStatus': 0
            });
          }).then((value) {


            FirebaseFirestore.instance.collection('workshops').doc(id).update(

                {

                  'participants': FieldValue.arrayUnion([_uid])


                }
            );
          });
        }

        
      } catch (e) {
        print(
            'Failed to collect fee: $e');
      }
    }







    //showAlertDialog(context, "Payment Successful", "Payment ID: ${response.paymentId}");
  }

//   collectFee()async{
//     TransactionService
//     transactionService =
//     TransactionService();
//     var id=Uuid().v1();
//     id = id;
// // Replace these values with the actual student and fee amount.
//     StudentModel
//     student = widget.student as StudentModel;// Get the student document.
//     double
//     feeAmount =
//     double.parse(
//         widget.student!.balance.toString()); // Specify the fee amount to collect.
//     final randomRT =
//     generateRandomRT();
//     await transactionService.collectFee(
//         student,
//         feeAmount,true,  "0.18");
//
//     // Generate the PDF invoice
//     final pdf =
//     InvoicePDF(
//       GSTNo: "NIL",
//       transactions: [
//         FinancialEntry(
//           usertype: "student",
//
//           gst:true,
//           id: id,
//           customerId:
//           student.id,
//           date:
//           DateTime.now(),
//           description:
//           'Fee Collection',
//           amount:
//           feeAmount,
//           type:
//           FinancialEntryType.income,
//           category:
//           'Fee',
//         ),
//       ],
//       customerName: student
//           .name
//           .toString(),
//       customerAddress: student
//           .city
//           .toString(), // Add address
//       invoiceNumber:
//       randomRT, // Add invoice number
//       tax:  0.18,
//
//       // Add tax percentage
//       paymentInfo:
//       'Account Number: 0537053000004834,\nAccount Holder: Managing Director,\nBank: South Indian Bank,\nBranch: Manjeri,\nIFSC: SIBL0000537,\nGoogle Pay: 9895663499,\nName: DriveX', // Add payment info
//       baseColor:
//       PdfColors.blue,
//       accentColor:
//       PdfColors.blueGrey,
//       customerEmail: student
//           .email
//           .toString(), // Add customer email
//       customerPhone: student
//           .mobile
//           .toString(), // Add customer phone
//     );
//     final pdfFile =
//    await  generateInvoicePdf(
//         pdf).then((value) => Navigator.pop(context));
//
//   }



  // randomnumber



  void handleExternalWalletSelected(ExternalWalletResponse response){
    showAlertDialog(context, "External Wallet Selected", "${response.walletName}");
  }
  @override
  void dispose() {
    _razorpay.clear(); // Removes all listeners
    super.dispose();
  }

  void showAlertDialog(BuildContext context, String title, String message){
    // set up the buttons
    Widget continueButton = ElevatedButton(
      child: const Text("Continue"),
      onPressed:  () {},
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Map<String, dynamic> generateRazorpayOptions() {
    return {
      'key': 'rzp_test_7ERJiy5eonusNC',
      'amount': (total * 100).toInt(), // Convert total to integer (paise)
      'name': 'Artistry',
      'description': '${widget.workshop!.description}',
      'prefill': {
        'contact': '9895663498',
        'email': 'support@artistry.com'
      }
    };
  }
  @override
  void initState() {
    getData();
    calculateTotalValues();

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccessResponse);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentErrorResponse);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWalletSelected);
    super.initState();
  }

  void calculateTotalValues() {
    // Adjust the tax rate based on your requirements
    double taxRate = 0.18;

    // Calculate the subtotal, estimated tax, and total
    subtotal = widget.workshop!.price;
    estimatedTax = subtotal * taxRate;
    total = subtotal + estimatedTax;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Colors.black54,
      appBar: AppBar(
        title: Text('Checkout',style: TextStyle(color: Colors.white),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cost Summary',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal,color: Colors.white),
            ),
            SizedBox(height: 8),

            Text(
              '${widget.workshop!.title} - ${widget.workshop!.description}',
              style: TextStyle(fontSize: 16,color: Colors.white),
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Subtotal: \u{20B9} ${widget.workshop!.price.toStringAsFixed(2)}',
                   textAlign: TextAlign.right,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.white),
                ),
              ],
            ),
            Divider(
              thickness: 1.5, color: Colors.teal,
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Estimated Tax (18%): \u{20B9} ${estimatedTax.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 16,color: Colors.white),
                ),
              ],
            ),
            Divider(
              thickness: 1.5, color: Colors.teal,
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Total: \u{20B9} ${total.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.white),
                ),
              ],
            ),
            Divider(
              thickness: 1.5, color: Colors.teal,
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                try{
                  _razorpay.open(generateRazorpayOptions());

                }catch(e){
                  print(e);
                }
                // Implement your payment logic here
                // You may want to use a payment gateway or navigate to a payment screen
                // For simplicity, let's print a message for now
                print('Payment successful. Course joined!');
                // You can also call the joinCourse method here if payment is successful
                // courseService.joinCourse(course.id, userId, booking);
               Navigator.pop(context);

              },
              child: Text('Pay Now'),
            ),
          ],
        ),
      ),
    );
  }
}
