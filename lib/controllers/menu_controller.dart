//
//  MenuController
//  FoodOrderApp
//
//  Created by Ranula Ranatunga on 2024-12-06.
//

import 'package:flutter/foundation.dart';
import 'package:food_order_app/services/data_services.dart';
import '../models/menu_model.dart';

class MenuController extends ChangeNotifier {
  List<MenuModel> _menus = [];
  List<MenuModel> get menus => _menus;

  Future<void> fetchMenus() async {
    try {
      final jsonData = await DataService.loadJsonData();
      print('Raw JSON Data: $jsonData');
      if (jsonData['Status'] == true &&
          jsonData['Result'] != null &&
          jsonData['Result']['Menu'] is List) {
        _menus = (jsonData['Result']['Menu'] as List).map((menuJson) {
          print('Processing menu: $menuJson');
          return MenuModel.fromJson(menuJson);
        }).toList();
        print('Menus: $_menus');
      } else {
        print('Menus data is not available');

        _menus = [];
      }
      notifyListeners();
    } catch (e) {
      print('Detailed Error fetching menus: $e');
      _menus = [];
      notifyListeners();
    }
  }
}
