import 'dart:io';
import 'package:artistry/models/media_model.dart';
import 'package:artistry/services/media_service.dart';
import 'package:artistry/widgets/apptext.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddMedia extends StatefulWidget {
  const AddMedia({Key? key}) : super(key: key);

  @override
  State<AddMedia> createState() => _AddMediaState();
}

class _AddMediaState extends State<AddMedia> {
  File? _image;
  final MediaService _mediaService = MediaService();
  bool _isTextBlinking = false;
  List<String> mediaUrls = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchMediaUrls();
  }

  Future<void> _fetchMediaUrls() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User not logged in')),
      );
      setState(() {
        isLoading = false;
      });
      return;
    }

    final urls = await _mediaService.fetchMediaUrls(userId);
    setState(() {
      mediaUrls = urls;
      isLoading = false;
    });
  }

  Future<void> _selectImage() async {
    final imageFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (imageFile != null) {
      setState(() {
        _image = File(imageFile.path);
      });
    }
  }

  Future<void> _saveImage() async {
    if (_image != null) {
      setState(() {
        _isTextBlinking = true;
      });

      final userId = FirebaseAuth.instance.currentUser?.uid;

      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User not logged in')),
        );
        setState(() {
          _isTextBlinking = false;
        });
        return;
      }

      try {
        await _mediaService.addMedia(_image!, userId);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Image saved successfully!')),
        );
        _fetchMediaUrls();
      } catch (e) {
        print('Error saving image: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save image. Please try again later.')),
        );
      } finally {
        setState(() {
          _isTextBlinking = false;
          _image = null;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No image selected')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppText(
          data: "Add Media",
          color: Color(0xFFB3261E),
          size: 18,
        ),
        backgroundColor: Color(0xffFFF5E9),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 20),
              GestureDetector(
                onTap: _selectImage,
                child: CircleAvatar(
                  radius: 35,
                  backgroundColor: Color(0xffFFF5E9),
                  child: _image != null
                      ? ClipOval(
                    child: Image.file(
                      _image!,
                      fit: BoxFit.cover,
                      width: 70,
                      height: 70,
                    ),
                  )
                      : Icon(
                    Icons.camera_alt_sharp,
                    color: Color(0xffD77272),
                  ),
                ),
              ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: _saveImage,
                child: AnimatedDefaultTextStyle(
                  style: _isTextBlinking
                      ? TextStyle(color: Colors.blue, fontSize: 15, fontWeight: FontWeight.bold)
                      : TextStyle(color: Color(0xffD77272), fontSize: 15),
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                  child: Text('Save'),
                ),
              ),
              SizedBox(height: 20),
              isLoading
                  ? CircularProgressIndicator(
                color: Color(0xFFB3261E),
              )
                  : Expanded(
                child: GridView.builder(
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
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
