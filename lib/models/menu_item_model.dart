//
//  MenuItemModel
//  FoodOrderApp
//
//  Created by Ranula Ranatunga on 2024-12-06.
//

class MenuItemModel {
  final String menuItemId;
  final String name;
  final String categoryId;
  final double price;
  final String description;
  final bool isDealProduct;
  final String? imageUrl;
  final List<ModifierGroupModel>? modifierGroups;
  final NutritionalInfoModel? nutritionalInfo;
  List<ModifierGroupModel>? modifiers;
  String? modifierGroupId;

  MenuItemModel({
    required this.menuItemId,
    required this.name,
    required this.categoryId,
    required this.price,
    required this.description,
    this.isDealProduct = false,
    this.imageUrl,
    this.modifierGroups,
    this.nutritionalInfo,
    this.modifiers,
    this.modifierGroupId,
  });

   factory MenuItemModel.fromJson(Map<String, dynamic> json) {
    return MenuItemModel(
      menuItemId: json['MenuItemID'] ?? '',
      name: json['Name']?['en'] ?? 'Unnamed Item', 
      categoryId: json['CategoryID'] ?? '',
      price: (json['Price'] ?? 0.0).toDouble(),
      description: json['Description']?['en'] ?? '',
      isDealProduct: json['MetaData']?['IsDealProduct'] ?? false,
      imageUrl: json['ImageURL'],
      modifierGroups: json['ModifierGroups'] != null
          ? (json['ModifierGroups'] as List)
              .map((mg) => ModifierGroupModel.fromJson(mg))
              .toList()
          : null,
      nutritionalInfo: json['NutritionalInfo'] != null
          ? NutritionalInfoModel.fromJson(json['NutritionalInfo'])
          : null,
      modifiers: json['Modifiers'] != null
          ? (json['Modifiers'] as List)
              .map((m) => ModifierGroupModel.fromJson(m))
              .toList()
          : null,
      modifierGroupId: json['ModifierGroupID'],
    );
  }
}

class ModifierGroupModel {
  final String modifierGroupId;
  final String name;
  final List<ModifierModel> modifiers;

  ModifierGroupModel({
    required this.modifierGroupId,
    required this.name,
    required this.modifiers,
  });

  factory ModifierGroupModel.fromJson(Map<String, dynamic> json) {
    return ModifierGroupModel(
      modifierGroupId: json['ModifierGroupID'] ?? '',
      name: json['Name'] ?? '',
      modifiers: (json['Modifiers'] as List)
          .map((m) => ModifierModel.fromJson(m))
          .toList(),
    );
  }
}

class ModifierModel {
  final String modifierId;
  final String name;
  final double price;

  ModifierModel({
    required this.modifierId,
    required this.name,
    required this.price,
  });

  factory ModifierModel.fromJson(Map<String, dynamic> json) {
    return ModifierModel(
      modifierId: json['ModifierID'] ?? '',
      name: json['Name'] ?? '',
      price: (json['Price'] ?? 0.0).toDouble(),
    );
  }
}

class NutritionalInfoModel {
  final int calories;
  final double protein;
  final double carbs;
  final double fat;

  NutritionalInfoModel({
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
  });

  factory NutritionalInfoModel.fromJson(Map<String, dynamic> json) {
    return NutritionalInfoModel(
      calories: json['Calories'] ?? 0,
      protein: (json['Protein'] ?? 0.0).toDouble(),
      carbs: (json['Carbs'] ?? 0.0).toDouble(),
      fat: (json['Fat'] ?? 0.0).toDouble(),
    );
  }
}
