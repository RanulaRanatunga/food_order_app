//
//  DataService
//  FoodOrderApp
//
//  Created by Ranula Ranatunga on 2024-12-05.
//

import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;


class  DataService {

  static Future<Map<String, dynamic>> loadJsonData() async {

    try {

      String jsonString = await rootBundle.loadString('assets/json/dataset.json');
      return json.decode(jsonString);
    } catch (e) {
      print('Error loading JSON: $e');
      return {'Status': false, 'Result': null};

    }

  }

    
  }
  
