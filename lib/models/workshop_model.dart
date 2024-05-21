import 'dart:convert';

class Workshop {
  final String id;
  final String title;
  final String description;
  final double price;
  final DateTime date;
  final String venue;
  final int status;
  final String artistId;
  final List<String> participants;

  Workshop({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.date,
    required this.venue,
    required this.status,
    required this.artistId,
    required this.participants,
  });

  factory Workshop.fromJson(Map<String, dynamic> json) {
    return Workshop(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      price: json['price'],
      date: DateTime.parse(json['date']),
      venue: json['venue'],
      status: json['status'],
      artistId: json['artistId'],
      participants: List<String>.from(json['participants']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'date': date.toIso8601String(),
      'venue': venue,
      'status': status,
      'artistId': artistId,
      'participants': participants,
    };
  }
}
