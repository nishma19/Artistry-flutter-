import 'package:artistry/screens/admin/artist_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:artistry/models/artist_model.dart';
import 'package:artistry/services/artist_service.dart';
// Import the artist detail screen

class ArtistListScreen extends StatefulWidget {

  ArtistListScreen({Key? key}) : super(key: key);

  @override
  State<ArtistListScreen> createState() => _ArtistListScreenState();
}

class _ArtistListScreenState extends State<ArtistListScreen> {
  final ArtistService _artistService = ArtistService();
  late Future<List<Artist>> _artistsFuture;
  @override
  void initState() {
    super.initState();
    _artistsFuture = _artistService.getArtists();
  }

  Future<void> _deleteArtist(String artistId) async {
    try {
      await _artistService.deleteUser(artistId);
      // Refresh user list after deletion
      setState(() {
        _artistsFuture = _artistService.getArtists();
      });
    } catch (e) {
      // Handle error
      print('Error deleting user: $e');
    }
  }



  Future<void> _showDeleteConfirmationDialog(String artistId, String artistName) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete User'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to delete $artistName?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                _deleteArtist(artistId);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Artists'),
      ),
      body: FutureBuilder<List<Artist>>(
        future: _artistsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color:Color(0xFFB3261E)));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No artists found.'));
          } else {
            List<Artist> artists = snapshot.data!;
            return ListView.builder(
              itemCount: artists.length,
              itemBuilder: (context, index) {
                Artist artist = artists[index];
                return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Dismissible(
                    key: UniqueKey(), // Provide a unique key for each Dismissible
                onDismissed: (direction) {
                // Delete the user when dismissed
                _deleteArtist(artist.id!);
                },
                background: Container(color: Colors.grey), // Add background color when swiping
                child: GestureDetector(
                onTap: () {
                // Navigate to user detail screen when tapped
                Navigator.push(
                context,
                MaterialPageRoute(
                builder: (context) => ArtistDetailScreen(artist: artist),
                ),
                );
                },




                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0,horizontal: 17),
                    child: Container(

                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey), // Add border
                            borderRadius: BorderRadius.circular(10), // Add border radius
                            // Add more decorations as needed
                          ),
                      child: ListTile(
                        leading: artist.imageUrl.isNotEmpty
                            ? Image.network(artist.imageUrl, width: 50, height: 50, fit: BoxFit.cover)
                            : Icon(Icons.person),
                        title: Text(artist.name),
                        subtitle: Text(artist.category),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ArtistDetailScreen(artist: artist),
                            ),
                          );
                        },
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            // Trigger deletion when delete button is pressed
                            _showDeleteConfirmationDialog(artist.id!, artist.name ?? '');
                          },
                        ),
                      ),
                    ),
                  ),
                ),),

                );



              },
            );
          }
        },
      ),
    );
  }
}
