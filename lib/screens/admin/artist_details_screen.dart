import 'package:flutter/material.dart';
import 'package:artistry/models/artist_model.dart';

class ArtistDetailScreen extends StatefulWidget {
  final Artist artist;
  final String? serviceId;


  ArtistDetailScreen({required this.artist,this.serviceId});

  @override
  State<ArtistDetailScreen> createState() => _ArtistDetailScreenState();
}

class _ArtistDetailScreenState extends State<ArtistDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.artist.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display the artist's image
            Center(
              child: widget.artist.imageUrl != null
                  ? Image.network(
                widget.artist.imageUrl!,
                height: 200,
                width: 200,
                fit: BoxFit.cover,
              )
                  : Placeholder(
                fallbackHeight: 200,
                fallbackWidth: 200,
              ),
            ),
            SizedBox(height: 20),
            // Display artist details
            Text('Name: ${widget.artist.name}', style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            Text('Email: ${widget.artist.email}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Phone: ${widget.artist.phone}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Category: ${widget.artist.category}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Address: ${widget.artist.address}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Business Details: ${widget.artist.businessDetails}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Links: ${widget.artist.links}', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
