import 'package:artistry/models/artist_model.dart';
import 'package:artistry/screens/user/end_user/booking_page.dart';
import 'package:artistry/services/media_service.dart';
import 'package:artistry/widgets/apptext.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Artistdetails extends StatefulWidget {
  const Artistdetails({super.key});

  @override
  State<Artistdetails> createState() => _ArtistdetailsState();
}

class _ArtistdetailsState extends State<Artistdetails> {
  var role;
  var name;
  var id;
  var email;
  var phone;
  var address;
  var links;
  List<String> mediaUrls = [];
  final MediaService _mediaService = MediaService();
  bool isLoading = true;

  getData() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    setState(() {
      role = _pref.getString('role');
      name = _pref.getString('name');
      id = _pref.getString('id');
      email = _pref.getString('email');
      phone = _pref.getString('phone');
      address = _pref.getString('address');
      links = _pref.getString('links');
    });
  }

  Future<void> fetchMediaUrls(String userId) async {
    final List<String> urls = await _mediaService.fetchMediaUrls(userId);
    setState(() {
      mediaUrls = urls;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final Artist artist = ModalRoute.of(context)!.settings.arguments as Artist;
      fetchMediaUrls(artist.id!);
    });
  }

  @override
  Widget build(BuildContext context) {
    final Artist artist = ModalRoute.of(context)!.settings.arguments as Artist;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffFFF5E9),
        actions: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Icon(Icons.favorite),
          )
        ],
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Stack(
          children: [
            SizedBox(height: 30),
            Container(
              height: 400,
              width: double.infinity,
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      artist.imageUrl.toString(),
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                  AppText(
                    data: "${artist.name}",
                    color: Color(0xFFB3261E),
                    fw: FontWeight.w600,
                    size: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Color(0xFFB3261E),
                          width: 1.0,
                        ),
                      ),
                      child: Center(
                        child: AppText(
                          data: artist.links,
                          color: Colors.blue,
                          size: 15,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              'subscriptionplan',
                              arguments: {
                                "artistId": artist.id,
                                'artistName': artist.name,
                                'artisPhone': artist.phone
                              },
                            );
                          },
                          child: Container(
                            width: 150,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  offset: Offset(4.0, 4.0),
                                  color: Colors.grey,
                                  blurRadius: 15,
                                  spreadRadius: 1.0,
                                ),
                                BoxShadow(
                                  color: Colors.white,
                                  offset: Offset(-4.0, -4.0),
                                  blurRadius: 15,
                                  spreadRadius: 1.0,
                                )
                              ],
                            ),
                            child: Center(
                              child: AppText(
                                data: "WorkShop",
                                color: Color(0xFFB3261E),
                                size: 15,
                                fw: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            // Replace 'BookingCalendarDemoApp' with your booking page widget
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BookingCalendarDemoApp(
                                  artist: artist,
                                  userData: {
                                    'name': name,
                                    'uid': id,
                                    'phone': phone,
                                    'email': email,
                                  },
                                ),
                              ),
                            );
                          },
                          child: Container(
                            width: 150,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  offset: Offset(4.0, 4.0),
                                  color: Colors.grey,
                                  blurRadius: 15,
                                  spreadRadius: 1.0,
                                ),
                                BoxShadow(
                                  color: Colors.white,
                                  offset: Offset(-4.0, -4.0),
                                  blurRadius: 15,
                                  spreadRadius: 1.5,
                                )
                              ],
                            ),
                            child: Center(
                              child: AppText(
                                data: "Order",
                                color: Color(0xFFB3261E),
                                size: 15,
                                fw: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                width: double.infinity,
                height: 400,
                decoration: BoxDecoration(),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: isLoading
                      ? Center(child: CircularProgressIndicator(color: Color(0xFFB3261E),))
                      : GridView.builder(
                    itemCount: mediaUrls.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                    ),
                    itemBuilder: (context, index) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          mediaUrls[index],
                          height: 150,
                          width: 150,
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
