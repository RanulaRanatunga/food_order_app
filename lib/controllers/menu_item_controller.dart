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

  Future<void> fetchMenuItemsByCategory(String categoryId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final jsonData = await DataService.loadJsonData();
      if (jsonData['Status'] != true) {
        _errorMessage = 'Data loading failed';
        return;
      }

      if (jsonData['Result'] == null ||
          !jsonData['Result'].containsKey('Items')) {
        _errorMessage = 'Invalid data structure';
        return;
      }

      final List<dynamic> menuItemsJson = jsonData['Result']['Items'];

      if (menuItemsJson.isEmpty) {
        _errorMessage = 'No menu items found';
        return;
      }

      _menuItems = menuItemsJson
          .where((itemJson) {
            final categoryIdsFromItem = itemJson['CategoryIDs'];
            return categoryIdsFromItem != null &&
                (categoryIdsFromItem as List).contains(categoryId);
          })
          .map((itemJson) => MenuItemModel.fromJson(itemJson))
          .toList();

      if (_menuItems.isEmpty) {
        _errorMessage = 'No menu items found for this category';
      }
    } catch (e) {
      _errorMessage = 'Error: $e';
      _menuItems = [];
    } finally {
      _isLoading = false;
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
