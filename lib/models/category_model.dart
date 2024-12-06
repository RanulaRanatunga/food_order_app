//
//  CategoryModel
//  FoodOrderApp
//
//  Created by Ranula Ranatunga on 2024-12-05.
//

class CategoryModel {
  final String categoryId;
  final String name;
  final List<String> menuEntities;
  final String? description;
  final String? imageUrl;

  CategoryModel({
    required this.categoryId,
    required this.name,
    required this.menuEntities,
    this.description,
    this.imageUrl,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      categoryId: json['MenuCategoryID'] ?? '',
      name: json['Title']?['en'] ?? 'Unnamed Category',
      menuEntities: json['MenuEntities'] != null
          ? List<String>.from(
              json['MenuEntities'].map((entity) => entity['ID']))
          : [],
      description: json['SubTitle']?['en'],
      imageUrl: json['ImageURL'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'MenuCategoryID': categoryId,
      'Title': {'en': name},
      'MenuEntities': menuEntities.map((id) => {'ID': id}).toList(),
      'SubTitle': {'en': description},
      'ImageURL': imageUrl,
    };
  }
}
