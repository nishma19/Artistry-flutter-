import 'package:artistry/models/artist_model.dart';
import 'package:artistry/services/artist_service.dart';
import 'package:flutter/material.dart';

class NotificationAccess extends StatefulWidget {
  const NotificationAccess({Key? key}) : super(key: key);

  @override
  State<NotificationAccess> createState() => _NotificationAccessState();
}

class _NotificationAccessState extends State<NotificationAccess> {
  final ArtistService _artistService = ArtistService();
  late Future<List<Artist>> _pendingRegistrations;

  @override
  void initState() {
    super.initState();
    _fetchPendingRegistrations();
  }

  void _fetchPendingRegistrations() {
    setState(() {
      _pendingRegistrations = _artistService.getPendingRegistrations();
    });
  }

  void _approveRegistration(String? registrationId) async {
    if (registrationId == null) return;
    try {
      await _artistService.approveRegistration(registrationId);
      _fetchPendingRegistrations(); // Reload pending registrations after approval
    } catch (e) {
      print('Error approving registration: $e');
    }
  }

  void _rejectRegistration(String? registrationId) async {
    if (registrationId == null) return;
    try {
      await _artistService.rejectRegistration(registrationId);
      _fetchPendingRegistrations(); // Reload pending registrations after rejection
    } catch (e) {
      print('Error rejecting registration: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Pending Registrations'),
      ),
      body: FutureBuilder<List<Artist>>(
        future: _pendingRegistrations,
        builder: (BuildContext context, AsyncSnapshot<List<Artist>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No Pending Requests'));
          } else {
            List<Artist> registrations = snapshot.data!;
            return ListView.builder(
              itemCount: registrations.length,
              itemBuilder: (BuildContext context, int index) {
                Artist registration = registrations[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    tileColor: Colors.grey.withOpacity(0.1),
                    title: Text(registration.name ?? 'No Name'),
                    subtitle: Text(registration.email),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.check),
                          color: Colors.green,
                          onPressed: () {
                            _approveRegistration(registration.id); // Approve registration
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.close),
                          color: Colors.red,
                          onPressed: () {
                            _rejectRegistration(registration.id); // Reject registration
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
