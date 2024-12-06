//
//  Main entry point of the application
//  FoodOrderApp
//
//  Created by Ranula Ranatunga on 2024-12-05.
//

import 'package:flutter/material.dart';
import 'package:food_order_app/controllers/category_controller.dart';
import 'package:food_order_app/controllers/menu_item_controller.dart';
import 'package:food_order_app/views/menu_screen.dart';
import 'package:provider/provider.dart';
import 'controllers/menu_controller.dart' as app_menu_controller;

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) => app_menu_controller.MenuController()),
        ChangeNotifierProvider(create: (context) => CategoryController()),
        ChangeNotifierProvider(create: (context) => MenuItemController()),
        // ChangeNotifierProvider(create: (context) => ModifierController()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Food Order App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MenuScreen(),
    );
  }
}
