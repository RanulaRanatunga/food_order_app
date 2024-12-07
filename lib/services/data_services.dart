//
//  DataService
//  FoodOrderApp
//
//  Created by Ranula Ranatunga on 2024-12-05.
//

import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class DataService {
  static Map<String, dynamic>? _cachedData;

  static Future<Map<String, dynamic>> loadJsonData() async {
    try {
      if (_cachedData != null) {
        return _cachedData!;
      }

      final String jsonString =
          await rootBundle.loadString('assets/json/dataset.json');

      if (jsonString.isEmpty) {
        return {'Status': false, 'Result': null, 'Error': 'Empty JSON file'};
      }

      final Map<String, dynamic> decodedData = json.decode(jsonString);

      if (!_validateJsonStructure(decodedData)) {
        return {
          'Status': false,
          'Result': null,
          'Error': 'Invalid JSON structure'
        };
      }
      _cachedData = decodedData;
      return decodedData;
    } catch (e) {
      return {'Status': false, 'Result': null, 'Error': e.toString()};
    }
  }

  static bool _validateJsonStructure(Map<String, dynamic> json) {
    if (!json.containsKey('Status') || !json.containsKey('Result')) {
      return false;
    }

    final result = json['Result'];
    if (result == null || result is! Map<String, dynamic>) {
      return false;
    }

    final requiredSections = ['Menu', 'Categories', 'Items'];
    for (final section in requiredSections) {
      if (!result.containsKey(section) || result[section] is! List) {
        return false;
      }
    }
    return true;
  }

  static void clearCache() {
    _cachedData = null;
  }
}
