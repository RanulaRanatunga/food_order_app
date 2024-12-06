//
//  CategoryController
//  FoodOrderApp
//
//  Created by Ranula Ranatunga on 2024-12-06.
//

import 'package:flutter/foundation.dart';
import 'package:food_order_app/services/data_services.dart';
import '../models/category_model.dart';

class CategoryController extends ChangeNotifier {
  List<CategoryModel> _categories = [];

  List<CategoryModel> _filteredCategories = [];

  bool _isLoading = false;

  String? _errorMessage;

  List<CategoryModel> get categories =>
      _filteredCategories.isNotEmpty ? _filteredCategories : _categories;

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  Future<void> fetchCategories(String menuId) async {
    _isLoading = true;

    _errorMessage = null;

    notifyListeners();

    try {
      final jsonData = await DataService.loadJsonData();

      print('Raw JSON Data: $jsonData');

      if (jsonData['Status'] == true &&
          jsonData['Result'] != null &&
          jsonData['Result']['Categories'] is List) {
        final List<dynamic> categoriesJson = jsonData['Result']['Categories'];

        print('Categories JSON: $categoriesJson');
        _categories = categoriesJson.where((categoryJson) {
          print('Category MenuID: ${categoryJson['MenuID']}');
          print('Passed MenuID: $menuId');

          return categoryJson['MenuID'] == menuId;
        }).map((categoryJson) {
          print('Processing category: $categoryJson');

          return CategoryModel.fromJson(categoryJson);
        }).toList();

        print('Filtered Categories: $_categories');

        _categories.sort((a, b) => a.name.compareTo(b.name));
        _isLoading = false;

        notifyListeners();
      } else {
        throw Exception('Invalid categories data structure');
      }
    } catch (e) {
      print('Error fetching categories: $e');

      _isLoading = false;

      _errorMessage = 'Failed to load categories: ${e.toString()}';

      _categories = [];

      notifyListeners();
    }
  }

  void filterCategories(String query) {
    if (query.isEmpty) {
      _filteredCategories = [];
    } else {
      _filteredCategories = _categories
          .where((category) =>
              category.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }

    notifyListeners();
  }

  CategoryModel? getCategoryById(String categoryId) {
    try {
      return _categories
          .firstWhere((category) => category.categoryId == categoryId);
    } catch (e) {
      return null;
    }
  }

  bool hasCategoryItems(String categoryId) {
    return _categories.any((category) => category.categoryId == categoryId);
  }

  void resetFilter() {
    _filteredCategories = [];
    notifyListeners();
  }
}
