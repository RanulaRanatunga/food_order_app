//
//  MenuModel
//  FoodOrderApp
//
//  Created by Ranula Ranatunga on 2024-12-06.
//

class MenuModel {

  final String menuId;
  final String name;
  final List<String> menuCategoryIds;


  MenuModel({

    required this.menuId,
    required this.name,
    required this.menuCategoryIds,

  });


  factory MenuModel.fromJson(Map<String, dynamic> json) {

    return MenuModel(

      menuId: json['MenuID'] ?? '',
      name: json['Title']?['en'] ?? '', 
      menuCategoryIds: json['MenuCategoryIDs'] != null 
          ? List<String>.from(json['MenuCategoryIDs']) 
          : [],
    );

  }

}