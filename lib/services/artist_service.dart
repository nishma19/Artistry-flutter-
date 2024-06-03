import 'package:artistry/models/artist_model.dart';
import 'package:artistry/models/product_model.dart';
import 'package:artistry/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ArtistService {


  // register
  //login
  // logout
  //alrady logined

  Future<String?> registerUser(Artist user) async {
    try {
      UserCredential userResponse = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
          email: user.email.toString(), password: user.password.toString());

      final artist = Artist(
          price: user.price,
          role: user.role,
           imageUrl: "",
          email: user.email,
          id: userResponse.user!.uid,
          password: user.password,
          name: user.name,
          phone: user.phone,
          category: user.category,
          address: user.address,
          businessDetails: user.businessDetails,
          links: user.links,
          status: 0


      );

      await
      FirebaseFirestore.instance
          .collection('login')
          .doc(userResponse.user!.uid)
          .set({

        'uid': artist.id,
        'role': artist.role,
        'email': artist.email,
        'status':artist.status
      });
      await
      FirebaseFirestore.instance
          .collection('artist')
          .doc(userResponse.user!.uid)
          .set(artist.toJson());

      await _notifyAdmin(artist);

      return "";
    } on FirebaseAuthException catch (e) {
      print('Firebase Auth Exception: ${e.message}');
      return e.message; // Return Firebase Auth error message
    } catch (e) {
      print('Error: $e');
      return 'Registration failed: $e'; // Return generic error message
    }
  }

  Future<void>updateArtist(String? uid,String name,  String address, String phone,String links,double price )async{


    FirebaseFirestore.instance.collection('artist').doc(uid!).update({

      'phone':phone,
      'address':address,
      'name':name,
      'price':price.toString(),

      'links':links,







    });


    SharedPreferences _pref=await SharedPreferences.getInstance();
    _pref.setString('name',name);


    _pref.setString('phone', phone);
    _pref.setString('address',address);
    _pref.setString('price',price.toString());
    _pref.setString('links',links);



  }

  Stream<List<Artist>> getArtistsStream() {
    return FirebaseFirestore.instance
        .collection('artist')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => Artist.fromJson(doc)).toList());
  }


  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String artistCollection = 'artist';

  Future<List<Artist>> getArtists() async {
    print("hello Jobin");
    try {
      final querySnapshot = await _firestore.collection(artistCollection).get();
      return querySnapshot.docs.map((doc) => Artist.fromJson(doc)).toList();
    } catch (e) {
      print("Error fetching artists: $e");
      return [];
    }
  }

  Future<List<String>> getDistinctCategories() async {
    try {
      final querySnapshot = await _firestore.collection(artistCollection).get();
      final categories = querySnapshot.docs.map((doc) => doc['category']).toSet().toList();
      return categories.cast<String>();
    } catch (e) {
      print("Error fetching categories: $e");
      return [];
    }
  }


  Future<List<String>> getDistinctCategoriesWithCrafterBusinessDetail() async {
    try {
      final querySnapshot = await _firestore.collection(artistCollection).where('businessDetails', isEqualTo: 'crafter').get();
      final categories = querySnapshot.docs.map((doc) => doc['category']).toSet().toList();
      return categories.cast<String>();
    } catch (e) {
      print("Error fetching categories with crafter business detail: $e");
      return [];
    }
  }


  Future<List<Product>> getProductsForCategory(String category) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('products')
          .where('category', isEqualTo: category)
          .get();

      List<Product> products = querySnapshot.docs
          .map((doc) => Product.fromJson(doc))
          .toList();

      return products;
    } catch (e) {
      print('Error fetching products: $e');
      return []; // Return an empty list in case of error
    }
  }




  Future<void> deleteUser(String artistId) async {
    try {
      await FirebaseFirestore.instance.collection('artist').doc(artistId).delete();
      await FirebaseFirestore.instance.collection('login').doc(artistId).delete();
    } catch (e) {
      throw Exception('Failed to delete user: $e');
    }
  }

  Future<List<Artist>> getPendingRegistrations() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
          .collection('artist')
          .where('status', isEqualTo: 0)
          .get();

      List<Artist> pendingRegistrations = snapshot.docs
          .map((DocumentSnapshot<Map<String, dynamic>> doc) => Artist.fromJson(doc))
          .toList();
      return pendingRegistrations;
    } catch (e) {
      throw Exception('Failed to get pending registrations: $e');
    }
  }
  Future<void> approveRegistration(String registrationId) async {
    try {
      await FirebaseFirestore.instance
          .collection('artist')
          .doc(registrationId)
          .update({'status': 1}).then((value) {


        FirebaseFirestore.instance
            .collection('login')
            .doc(registrationId)
            .update({'status': 1});

      });
    } catch (e) {
      throw Exception('Failed to approve registration: $e');
    }
  }

  // Method to reject a registration

  Future<void> rejectRegistration(String registrationId) async {
    try {
      await FirebaseFirestore.instance
          .collection('artist')
          .doc(registrationId)
          .update({'status': 'rejected'});
    } catch (e) {
      throw Exception('Failed to reject registration: $e');
    }
  }



  Future<void> _notifyAdmin(Artist artist) async {
    // Create a notification for the admin
    await FirebaseFirestore.instance.collection('admin_notifications').add({
      'message': 'New artist registration: ${artist.name}',
      'artist_id': artist.id,
      'timestamp': DateTime.now(),
    });
  }


}
