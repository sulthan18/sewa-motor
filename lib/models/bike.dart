import 'package:cloud_firestore/cloud_firestore.dart';

class Bike {
  final String id;
  final String name;
  final String about;
  final String category;
  final String image;
  final String level;
  final double price;
  final double rating;
  final DateTime release;

  Bike({
    required this.id,
    required this.name,
    required this.about,
    required this.category,
    required this.image,
    required this.level,
    required this.price,
    required this.rating,
    required this.release,
  });

  factory Bike.fromJson(Map<String, dynamic> json) {
    return Bike(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Unknown',
      about: json['about'] ?? 'No description',
      category: json['category'] ?? 'Unknown',
      image: json['image'] ?? 'https://via.placeholder.com/220x170',
      level: json['level'] ?? 'Beginner',
      price: (json['price'] ?? 0.0).toDouble(),
      rating: (json['rating'] ?? 0.0).toDouble(),
      release: (json['release'] != null)
          ? (json['release'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  static Bike get empty => Bike(
      id: '',
      name: '',
      about: '',
      category: '',
      image: '',
      level: '',
      price: 0,
      rating: 0,
      release: DateTime.now());
}
