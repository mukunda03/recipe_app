class CategoryModel {
  final String id;
  final String name;
  final String imageUrl;
  final String description;

  CategoryModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.description,
  });

  factory CategoryModel.fromMap(String id, Map<String, dynamic> map) {
    return CategoryModel(
      id: id,
      name: map['name'] ?? "",
      imageUrl: map['imageUrl'] ?? "",
      description: map['description'] ?? "",
    );
  }
}
