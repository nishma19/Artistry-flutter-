// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:learningappproejct/application/core/constants/colors.dart';
// import 'package:learningappproejct/application/user/checkout/invocie_number_generator.dart';
// import 'package:learningappproejct/application/user/checkout/invoicepage.dart';
// import 'package:learningappproejct/application/user/courses/models/course_model.dart';
// import 'package:learningappproejct/application/user/courses/service/course_service.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:uuid/uuid.dart';
//
// class CheckoutPage extends StatefulWidget {
//   final DocumentSnapshot? course;
//   final double totalPrice; // You need to calculate the total price based on your logic
//
//   CheckoutPage({required this.course, required this.totalPrice});
//
//   @override
//   _CheckoutPageState createState() => _CheckoutPageState();
// }
//
// class _CheckoutPageState extends State<CheckoutPage> {
//   double estimatedTax = 0.0;
//   double subtotal = 0.0;
//   double total = 0.0;
//   late Razorpay _razorpay = Razorpay();
//   YourInvoiceGenerator invoiceGenerator = YourInvoiceGenerator();
//
//   String? _uid;
//   getData() async {
//     SharedPreferences _pref = await SharedPreferences.getInstance();
//
//
//
//     // if (imggurl == null) {
//     //   setState(() {
//     //     imggurl = "assets/image/profile.png";
//     //   });
//     // }
//
//     _uid = await _pref.getString(
//       'uid',
//     );
//
//
//
//     setState(() {
//
//
//     });
//   }
//   List<String>? courses;
//
//
//   void handlePaymentErrorResponse(PaymentFailureResponse response){
//
//     /** PaymentFailureResponse contains three values:
//      * 1. Error Code
//      * 2. Error Description
//      * 3. Metadata
//      **/
//     showAlertDialog(context, "Payment Failed", "Code: ${response.code}\nDescription: ${response.message}\nMetadata:${response.error.toString()}");
//   }
//
//   void handlePaymentSuccessResponse(PaymentSuccessResponse response) {
//
//     /** Payment Success Response contains three values:
//      * 1. Order ID
//      * 2. Payment ID
//      * 3. Signature
//      **/
//
//     if(response.paymentId!=null){
//       var id=Uuid().v1();
//       CourseService _courseService=CourseService();
//       String uniqueInvoiceNumber = invoiceGenerator.generateInvoiceNumber();
//       _courseService.joinCourse(widget.course!['id'], _uid!, widget.course!['booking']);
//
//
//
//       FirebaseFirestore.instance.collection('booking').doc(response.paymentId).set({
//         'bookingid':id,
//         'orderId':id,
//         'paymentid':response.paymentId,
//         'courseid':widget.course!['id'],
//         'authid':widget.course!['authid'],
//         'coursename':widget.course!['title'],
//         'status':1,
//         'amount':total,
//         'createdat':DateTime.now(),
//         'settlementStatus':0
//       }).then((value) {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => InvoicePage(
//               userid: _uid,
//               course: widget.course,
//               invoiceNumber:uniqueInvoiceNumber,
//               itemName: '${widget.course!['title']}', // Replace with your actual item name
//               itemPrice: widget.totalPrice,
//               quantity: 1, // Assuming one course is purchased in this example
//               totalAmount: total,
//               orderId: id,
//               paymentId: response.paymentId,
//               signature: id,
//
//             ),
//           ),
//         );
//       });
//
//     }
//
//
//
//     //showAlertDialog(context, "Payment Successful", "Payment ID: ${response.paymentId}");
//   }
//
//   void handleExternalWalletSelected(ExternalWalletResponse response){
//     showAlertDialog(context, "External Wallet Selected", "${response.walletName}");
//   }
//   @override
//   void dispose() {
//     _razorpay.clear(); // Removes all listeners
//     super.dispose();
//   }
//
//   void showAlertDialog(BuildContext context, String title, String message){
//     // set up the buttons
//     Widget continueButton = ElevatedButton(
//       child: const Text("Continue"),
//       onPressed:  () {},
//     );
//     // set up the AlertDialog
//     AlertDialog alert = AlertDialog(
//       title: Text(title),
//       content: Text(message),
//     );
//     // show the dialog
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return alert;
//       },
//     );
//   }
//
//   Map<String, dynamic> generateRazorpayOptions() {
//     return {
//       'key': 'rzp_test_7ERJiy5eonusNC',
//       'amount': (total * 100).toInt(), // Convert total to integer (paise)
//       'name': 'Mentor U',
//       'description': '${widget.course!['title']}',
//       'prefill': {
//         'contact': '9895663498',
//         'email': 'support@ralfiz.com'
//       }
//     };
//   }
//   @override
//   void initState() {
//     getData();
//     calculateTotalValues();
//
//     _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccessResponse);
//     _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentErrorResponse);
//     _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWalletSelected);
//     super.initState();
//   }
//
//   void calculateTotalValues() {
//     // Adjust the tax rate based on your requirements
//     double taxRate = 0.18;
//
//     // Calculate the subtotal, estimated tax, and total
//     subtotal = widget.totalPrice;
//     estimatedTax = subtotal * taxRate;
//     total = subtotal + estimatedTax;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.scaffoldColor,
//       appBar: AppBar(
//         title: Text('Checkout',style: TextStyle(color: Colors.white),),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Cost Summary',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal,color: Colors.white),
//             ),
//             SizedBox(height: 8),
//
//             Text(
//               '${widget.course!['title']} - ${widget.course!['description']}',
//               style: TextStyle(fontSize: 16,color: Colors.white),
//             ),
//             SizedBox(height: 30),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 Text(
//                   'Subtotal: \$${widget.totalPrice.toStringAsFixed(2)}',
//                   textAlign: TextAlign.right,
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.white),
//                 ),
//               ],
//             ),
//             Divider(
//               thickness: 1.5, color: Colors.teal,
//             ),
//             SizedBox(height: 8),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 Text(
//                   'Estimated Tax (18%): \$${estimatedTax.toStringAsFixed(2)}',
//                   style: TextStyle(fontSize: 16,color: Colors.white),
//                 ),
//               ],
//             ),
//             Divider(
//               thickness: 1.5, color: Colors.teal,
//             ),
//             SizedBox(height: 8),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 Text(
//                   'Total: \$${total.toStringAsFixed(2)}',
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.white),
//                 ),
//               ],
//             ),
//             Divider(
//               thickness: 1.5, color: Colors.teal,
//             ),
//             SizedBox(height: 32),
//             ElevatedButton(
//               onPressed: () {
//                 try{
//                   _razorpay.open(generateRazorpayOptions());
//                 }catch(e){
//                   print(e);
//                 }
//                 // Implement your payment logic here
//                 // You may want to use a payment gateway or navigate to a payment screen
//                 // For simplicity, let's print a message for now
//                 print('Payment successful. Course joined!');
//                 // You can also call the joinCourse method here if payment is successful
//                 // courseService.joinCourse(course.id, userId, booking);
//               },
//               child: Text('Pay Now'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }