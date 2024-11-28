//this is the product class that is main json class
class Product {
  final int id;
  final String title;
  final double price;
  final String description;
  final List<String> images;
  final DateTime creationAt;
  final DateTime updatedAt;
  final Category category;
  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.images,
    required this.creationAt,
    required this.updatedAt,
    required this.category,
  });
  // here factory is a key word that used for create constructor one time. that means no need to create multipal object
  //product is a return type
  // fromJson it's a factory constructor that takes a json data and convert it to dart object
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? "",
      title: json['title'],
      // Convert int to double
      price: (json['price'] is int)
          ? (json['price'] as int).toDouble()
          : json['price'],
      description: json['description'],
      // Safely parse as List<String>
      images: List<String>.from((json['images'] as List).map((item) {
        return item
            .replaceAll("\"", "")
            .replaceAll("[", "")
            .replaceAll("]", "");
      })),
      creationAt:
          DateTime.parse(json['creationAt']), // Parse String to DateTime
      updatedAt: DateTime.parse(json['updatedAt']), // Parse String to DateTime
      category: Category.fromJson(json['category']),
    ); // Parse `category` here
  }
}

//This is the catagory class that are menction in json data
class Category {
  final int id;
  final String name;
  final String image;
  final DateTime creationAt;
  final DateTime updatedAt;

  Category({
    required this.id,
    required this.name,
    required this.image,
    required this.creationAt,
    required this.updatedAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      creationAt:
          DateTime.parse(json['creationAt']), // Parse String to DateTime
      updatedAt: DateTime.parse(json['updatedAt']), // Parse String to DateTime
    );
  }
}
