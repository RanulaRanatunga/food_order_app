//
//  ModifierModel
//  FoodOrderApp
//
//  Created by Ranula Ranatunga on 2024-12-06.
//

class ModifierGroupModel {
  final String id;
  final String title;
  final List<String> ids;
  final List<ModifierOverride>? overrides;

  ModifierGroupModel({
    required this.id,
    required this.title,
    required this.ids,
    this.overrides,
  });

  factory ModifierGroupModel.fromJson(Map<String, dynamic> json) {
    return ModifierGroupModel(
      id: json['IDs']?[0] ?? '',
      title: json['Title']?['en'] ?? '',
      ids: List<String>.from(json['IDs'] ?? []),
      overrides: json['Overrides'] != null
          ? (json['Overrides'] as List)
              .map((override) => ModifierOverride.fromJson(override))
              .toList()
          : null,
    );
  }
}

class ModifierOverride {
  final String? type;
  final dynamic value;

  ModifierOverride({
    this.type,
    this.value,
  });

  factory ModifierOverride.fromJson(Map<String, dynamic> json) {
    return ModifierOverride(
      type: json['Type'],
      value: json['Value'],
    );
  }
}
