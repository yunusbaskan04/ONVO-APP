class Models {
  final String id;
  final String model;
  final String categorieID;

  Models({required this.id, required this.model, required this.categorieID});

  factory Models.fromJson(Map<String, dynamic> json) {
    return Models(
      id: json["id"].toString(),
      model: json["model"],
      categorieID: json["categorieId"].toString(),
    );
  }
}
