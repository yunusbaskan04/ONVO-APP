class Product {
  final int id;
  final String name;
  final String categoryId;
  final String modelId;
  final String price;
  final String technicalFeature;

  Product({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.modelId,
    required this.price,
    required this.technicalFeature,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json["id"],
      name: json["name"],
      categoryId: json["categoryId"].toString(),
      modelId: json["modelId"].toString(),
      price: json["price"].toString(),
      technicalFeature: json["technical_feature"].toString(),
    );
  }
}
