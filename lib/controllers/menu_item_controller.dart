//
//  MenuItemController
//  FoodOrderApp
//
//  Created by Ranula Ranatunga on 2024-12-06.
//

import 'package:flutter/foundation.dart';
import 'package:food_order_app/services/data_services.dart';
import '../models/menu_item_model.dart';

class MenuItemController extends ChangeNotifier {
  List<MenuItemModel> _menuItems = [];
  List<MenuItemModel> _filteredMenuItems = [];
  bool _isLoading = false;
  String? _errorMessage;
  MenuItemModel? _selectedMenuItem;

  List<MenuItemModel> get menuItems =>
      _filteredMenuItems.isNotEmpty ? _filteredMenuItems : _menuItems;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  MenuItemModel? get selectedMenuItem => _selectedMenuItem;

  Future<void> fetchMenuItems(String categoryId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final jsonData = await DataService.loadJsonData();
      print('Raw JSON Data: $jsonData');
      if (jsonData['Status'] == true && jsonData['Result'] != null) {
        final List<dynamic> menuItemsJson =
            jsonData['Result']['MenuItems'] ?? [];
        print('Menu Items JSON: $menuItemsJson');
        _menuItems = menuItemsJson.where((itemJson) {
          print('Item CategoryIDs: ${itemJson['CategoryIDs']}');
          print('Passed CategoryID: $categoryId');
          return (itemJson['CategoryIDs'] is List)
              ? (itemJson['CategoryIDs'] as List).contains(categoryId)
              : false;
        }).map((itemJson) {
          print('Processing menu item: $itemJson');
          return MenuItemModel.fromJson(itemJson);
        }).toList();
        print('Filtered Menu Items: $_menuItems');
        _menuItems.sort((a, b) => a.name.compareTo(b.name));
        _isLoading = false;
        notifyListeners();
      } else {
        throw Exception('Invalid menu items data structure');
      }
    } catch (e) {
      print('Error fetching menu items: $e');
      _isLoading = false;
      _errorMessage = 'Failed to load menu items: ${e.toString()}';
      _menuItems = [];
      notifyListeners();
    }
  }

  void selectMenuItem(MenuItemModel menuItem) {
    _selectedMenuItem = menuItem;
    notifyListeners();
  }

  void filterMenuItems(String query) {
    if (query.isEmpty) {
      _filteredMenuItems = [];
    } else {
      _filteredMenuItems = _menuItems
          .where((item) =>
              item.name.toLowerCase().contains(query.toLowerCase()) ||
              item.description.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  void resetFilter() {
    _filteredMenuItems = [];
    notifyListeners();
  }
}
