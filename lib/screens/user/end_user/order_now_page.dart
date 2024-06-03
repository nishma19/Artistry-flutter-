import 'package:artistry/models/product_model.dart';
import 'package:artistry/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:artistry/models/order_model.dart';
import 'package:artistry/models/user_model.dart';
import 'package:artistry/services/order_service.dart';
import 'package:artistry/services/user_service.dart';
import 'package:artistry/services/location_service.dart';
import 'package:artistry/widgets/apptext.dart';
import 'package:artistry/screens/common/calender_page.dart';
import 'package:uuid/uuid.dart';

class OrderNowPage extends StatefulWidget {
  final String? productId;
  final String? artistId;
  final String? artistName;
  final String? productName;
  final double? productPrice;
  final String? uid;
  final String? name;
  final String? address;
  final String? email;
  final String? phone;

  const OrderNowPage({
    Key? key,
    this.productId,
    this.artistId,
    this.artistName,
    this.productName,
    this.productPrice,
    this.phone,
    this.email,
    this.uid,
    this.name,
    this.address,
  }) : super(key: key);

  @override
  State<OrderNowPage> createState() => _OrderNowPageState();
}

class _OrderNowPageState extends State<OrderNowPage> {
  final OrderService _orderService = OrderService();
  final UserService _userService = UserService();
  final LocationService _locationService = LocationService();

  Position? _currentPosition;
  Placemark? _currentLocationName;
  bool _loading = true;
  UserModel? _user;
  String? _errorMessage;
  String? _selectedPaymentMethod;
  double? _productPrice;

  @override
  void initState() {
    super.initState();
    _fetchUser();
    _determineLocation();
  }

  Future<void> _fetchUser() async {
    try {
      User? user = await FirebaseAuth.instance.currentUser;
      if (user != null) {
        UserModel fetchedUser = await _userService.getUserById(user.uid);
        setState(() {
          _user = fetchedUser;
          print(_user);
        });
      } else {
        setState(() {
          _errorMessage = 'No user is currently logged in.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error fetching user information';
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error fetching user information')));
    }
  }

  Future<void> _determineLocation() async {
    setState(() {
      _loading = true;
    });

    try {
      _currentPosition = await _locationService.determinePosition();
      _currentLocationName = await _locationService.getLocationName(_currentPosition);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error determining location')));
    }

    setState(() {
      _loading = false;
    });
  }

  Map<String,dynamic> ?product;

  Future<void> _createProductOrder() async {
    try {
      if (_user != null && _currentLocationName != null) {
        OrderModel newOrder = OrderModel(
          orderId: Uuid().v1(),
          userId: _user!.uid.toString(),
          userName: _user!.name ?? '',
          userPhone: _user!.phone ?? '',
          userAddress: _user!.address ?? '',
          productId: product!['id'] ?? 'product_id',
          productName: product!['name'] ?? 'Unknown Product',
          productImageUrl: product!['imageUrl'],
          artistId: product!['artistId'] ?? 'artist_id',
          artistName: product!['artistName'] ?? 'Unknown Artist',
          status: 'Pending',
          createdAt: DateTime.now(),
          deadline: DateTime.now().add(Duration(days: 7)),
          productPrice: _productPrice ?? 0.0,
          payment: _selectedPaymentMethod ?? 'Not Specified',
        );

        await _orderService.createOrder(newOrder);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Order created successfully!')));
      } else {
        setState(() {
          _errorMessage = 'No user logged in or user data not available';
        });
      }
    } catch (error) {
      setState(() {
        _errorMessage = 'Error creating order: $error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String locationCity = _currentLocationName?.locality ?? "Unknown City";
    String subLocality = _currentLocationName?.subLocality ?? "Loading";
    product =ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffFFF5E9),
        title: AppText(data: "Order Now", color: Color(0xFFB3261E), size: 20, fw: FontWeight.w400),
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator(color: Color(0xFFB3261E)))
          : Container(
        height: double.infinity,
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              if (_errorMessage != null) ...[
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(color: Colors.red, fontSize: 16),
                  ),
                ),
              ],
              ListTile(
                leading: Icon(Icons.location_on, color: Color(0xFFB3261E), size: 25),
                title: Text(
                  locationCity,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Text(
                  subLocality,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(height: 20),
              DatePickerWidget(),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: AppText(data: "Address:", color: Color(0xFFB3261E)),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  height: 100,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFFB3261E), width: 1.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(_user?.address ?? 'No address available'),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: AppText(data: "Phone No:", color: Color(0xFFB3261E)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFFB3261E), width: 1.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(_user?.phone ?? '1234567890'),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: AppText(data: "Product Price:", color: Color(0xFFB3261E)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFFB3261E), width: 1.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      initialValue: widget.productPrice?.toString() ?? '',
                      decoration: InputDecoration(
                        hintText: 'Enter product price',
                        border: InputBorder.none,
                      ),
                      onChanged: (value) {
                        setState(() {
                          _productPrice = double.tryParse(value);
                        });
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: AppText(data: "Payment Method:", color: Color(0xFFB3261E)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFFB3261E), width: 1.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: _selectedPaymentMethod,
                      hint: Text('Select payment method'),
                      items: <String>['Credit Card', 'Debit Card', 'PayPal', 'Cash on Delivery']
                          .map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _selectedPaymentMethod = newValue;
                        });
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(height: 70),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ElevatedButton(
                  onPressed: _createProductOrder,
                  child: Text(
                    'Check Out',
                    style: TextStyle(color: Color(0xFFB3261E), fontWeight: FontWeight.w400),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xffFFF5E9),
                    minimumSize: Size(double.infinity, 50),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
