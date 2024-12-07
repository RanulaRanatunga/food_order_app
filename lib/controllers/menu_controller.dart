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
      if (jsonData['Status'] == true &&
          jsonData['Result'] != null &&
          jsonData['Result']['Menu'] is List) {
        _menus = (jsonData['Result']['Menu'] as List).map((menuJson) {
          return MenuModel.fromJson(menuJson);
        }).toList();
        // print(' ***** $_menus');
      } else {
        _menus = [];
      }
      notifyListeners();
    } catch (e) {
      _menus = [];
      notifyListeners();
    }
  }
}
