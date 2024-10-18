class Bike {
  final String id;
  final String name;
  final String about;
  final String category;
  final String image;
  final String level;
  final double price;
  final double rating;

  Bike({
    required this.id,
    required this.name,
    required this.about,
    required this.category,
    required this.image,
    required this.level,
    required this.price,
    required this.rating,
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
    );
  }
}
