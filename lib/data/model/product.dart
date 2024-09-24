class Product {
  int id;
  String name;
  String description;
  double price;
  String image;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.image
  });

//   Chuyen doi tu Map sang Product khi lay du lieu tu CSDL ve
  factory Product.fromMap(Map<String, dynamic> json) => Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
      image: json['image']
  );

//   Chuyen doi tu product sang Map de day du lieu len CSDL
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'image': image
    };
  }
}