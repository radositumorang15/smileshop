class Product {
  final int id;
  final String title;
  final double price;
  final String description;
  final String image;
  final int? quantity;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.image,
    this.quantity,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      price: json['price'].toDouble(),
      description: json['description'],
      image: json['image'],
    );
  }

  Product copyWith({
    int? id,
    String? title,
    double? price,
    String? description,
    String? image,
    int? quantity,
  }) {
    return Product(
      id: id ?? this.id,
      title: title ?? this.title,
      price: price ?? this.price,
      description: description ?? this.description,
      image: image ?? this.image,
      quantity: quantity ?? this.quantity,
    );
  }
}