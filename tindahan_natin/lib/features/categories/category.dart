class Category {
  final String id;
  final String name;
  final String storeId;

  Category({required this.id, required this.name, required this.storeId});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as String,
      name: json['name'] as String,
      storeId: json['storeId'] as String,
    );
  }
}
