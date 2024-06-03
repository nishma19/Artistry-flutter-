import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class BookingCheckoutPage extends StatefulWidget {
  final String bookingId;

  BookingCheckoutPage({required this.bookingId});

  @override
  _BookingCheckoutPageState createState() => _BookingCheckoutPageState();
}

class _BookingCheckoutPageState extends State<BookingCheckoutPage> {
  double estimatedTax = 0.0;
  double subtotal = 0.0;
  double total = 0.0;
  late Razorpay _razorpay;
  String? _uid;
  Map<String, dynamic>? bookingData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccessResponse);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentErrorResponse);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWalletSelected);
    getData();
    fetchBookingDetails();
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  Future<void> getData() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    _uid = _pref.getString('id');
    setState(() {});
  }

  Future<void> fetchBookingDetails() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('bookings_status')
          .doc(widget.bookingId)
          .get();
      if (doc.exists) {
        setState(() {
          bookingData = doc.data();
          calculateTotalValues();
          isLoading = false;
        });
      } else {
        showAlertDialog(context, "Error", "Booking not found.");
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      showAlertDialog(context, "Error", "Failed to fetch booking details.");
      setState(() {
        isLoading = false;
      });
    }
  }

  void calculateTotalValues() {
    double taxRate = 0.18;
    subtotal = bookingData?['servicePrice'] ?? 0.0;
    estimatedTax = subtotal * taxRate;
    total = subtotal + estimatedTax;
  }

  void handlePaymentErrorResponse(PaymentFailureResponse response) {
    showAlertDialog(context, "Payment Failed",
        "Code: ${response.code}\nDescription: ${response.message}\nMetadata:${response.error.toString()}");
  }

  void handlePaymentSuccessResponse(PaymentSuccessResponse response) {
    if (response.paymentId != null) {
      try {
        print("Payment successful: ${response.paymentId!}");
        var id = Uuid().v1();
        FirebaseFirestore.instance.collection('payments').doc(response.paymentId).set({
          'paymentId': response.paymentId,
          'bookingId': widget.bookingId,
          'userId': _uid,
          'amount': total,
          'tax': estimatedTax,
          'createdAt': DateTime.now(),
          'status': 'completed'
        });
        FirebaseFirestore.instance.collection('bookings').doc(widget.bookingId).update({
          'status': 'paid'
        });
        showAlertDialog(context, "Payment Successful", "Your payment was successful.");
      } catch (e) {
        print('Failed to process payment: $e');
        showAlertDialog(context, "Error", "Failed to process payment.");
      }
    }
  }

  void handleExternalWalletSelected(ExternalWalletResponse response) {
    showAlertDialog(context, "External Wallet Selected", "${response.walletName}");
  }

  void showAlertDialog(BuildContext context, String title, String message) {
    Widget continueButton = ElevatedButton(
      child: const Text("Continue"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [continueButton],
    );
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
      'amount': (total * 100).toInt(),
      'name': 'Artistry',
      'description': bookingData?['serviceName'] ?? '',
      'prefill': {'contact': '9895663498', 'email': 'support@artistry.com'}
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      appBar: AppBar(
        title: Text('Booking Checkout', style: TextStyle(color: Colors.white)),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : bookingData == null
          ? Center(child: Text('Booking details not available', style: TextStyle(color: Colors.white)))
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Booking Summary',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal, color: Colors.white),
            ),
            SizedBox(height: 8),
            Text(
              '${bookingData!['serviceName']} - ${bookingData!['serviceDuration']}',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Subtotal: \u{20B9} ${bookingData!['servicePrice'].toStringAsFixed(2)}',
                  textAlign: TextAlign.right,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ],
            ),
            Divider(thickness: 1.5, color: Colors.teal),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Estimated Tax (18%): \u{20B9} ${estimatedTax.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ],
            ),
            Divider(thickness: 1.5, color: Colors.teal),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Total: \u{20B9} ${total.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ],
            ),
            Divider(thickness: 1.5, color: Colors.teal),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                try {
                  _razorpay.open(generateRazorpayOptions());
                } catch (e) {
                  print(e);
                }
              },
              child: Text('Pay Now'),
            ),
          ],
        ),
      ),
    );
  }
}
