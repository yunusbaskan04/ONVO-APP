class Category {
  final String categoryId;
  final String name;
  final String photo;

  Category({required this.categoryId, required this.name, required this.photo});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      categoryId: json["id"],
      name: json["name"],
      photo: json["photo"],
    );
  }
}
