import 'package:artistry/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  // register
  //login
  // logout
  //alrady logined
  final CollectionReference usersCollection =
  FirebaseFirestore.instance.collection('users');

  Future<String?> registerUser(UserModel user) async {
    try {
      UserCredential userResponse = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
          email: user.email.toString(), password: user.password.toString());

      final usermodel=UserModel(
        imageUrl: "",
        role: user.role,

        email:user.email,
        uid: userResponse.user!.uid,
        password:user.password,
        name: user.name, phone: user.phone,

      );


      FirebaseFirestore.instance
          .collection('login')
          .doc(userResponse.user!.uid)
          .set({

        'uid':usermodel.uid,
        'role':usermodel.role,
        'email':usermodel.email
      });

      FirebaseFirestore.instance
          .collection('user')
          .doc(userResponse.user!.uid)
          .set(usermodel.toMap());

      return "";
    } on FirebaseAuthException catch (e) {
      print('Firebase Auth Exception: ${e.message}');
      return e.message; // Return Firebase Auth error message
    } catch (e) {
      print('Error: $e');
      return 'Registration failed: $e'; // Return generic error message
    }
  }


  Future<void>updateUser(String? uid,String name,  String address, String phone )async{


    FirebaseFirestore.instance.collection('user').doc(uid!).update({

      'phone':phone,
      'address':address,
      'name':name






    });


    SharedPreferences _pref=await SharedPreferences.getInstance();
    _pref.setString('name',name);


    _pref.setString('phone', phone);
    _pref.setString('address',address);



  }






  // Future<void> updateUserImage(String? uid, String? imageUrl) async {
  //   try {
  //     await usersCollection.doc(uid).update({'imageUrl': imageUrl});
  //   } catch (e) {
  //     print('Error updating user image: $e');
  //     // Handle error appropriately
  //   }
  // }





  Future<String?> getUserProfilePicURL(String serviceId) async {
    try {
      // Step 1: Fetch the booking document using the service ID
      var userId;
      final bookingSnapshot = await FirebaseFirestore.instance
          .collection('bookings')
          .where('serviceId', isEqualTo: userId)
          .get();

      // Check if the booking document exists
      if (bookingSnapshot.docs.isNotEmpty) {
        // Extract the user ID from the booking document
        final userId = bookingSnapshot.docs.first.get('userId');

        // Step 2: Fetch the user document using the user ID
        final userSnapshot = await FirebaseFirestore.instance
            .collection('user')
            .doc(userId)
            .get();

        // Check if the user document exists and has an image URL
        if (userSnapshot.exists && userSnapshot.data() != null) {
          final imageUrl = userSnapshot.data()!['imageUrl'];
          return imageUrl; // Return the image URL
        }
      }

      // Return null if no image URL is found or if the user or booking does not exist
      return null;
    } catch (error) {
      print("Error fetching user profile picture: $error");
      return null;
    }
  }



  Future<String> getUserProfileImageUrl(String userId) async {
    var userData = await FirebaseFirestore.instance
        .collection('user')
        .doc(userId)
        .get();
    return userData['imageUrl']; // Assuming 'imageUrl' is the field name in your user collection
  }



  Future<List<UserModel>> getAllUsers() async {
    try {
      QuerySnapshot querySnapshot = await usersCollection.get();
      List<UserModel> users = querySnapshot.docs
          .map((doc) => UserModel.fromJoson(doc))
          .toList();
      return users;
    } catch (error) {
      print('Error fetching users: $error');
      return []; // Return an empty list in case of an error
    }
  }

  Future<void> deleteUser(String userId) async {
    try {
      await usersCollection.doc(userId).delete();
    } catch (error) {
      print('Error deleting user: $error');
      // Handle error appropriately (e.g., show error message)
    }
  }



}

