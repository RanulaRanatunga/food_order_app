//
//  MenuScreen
//  FoodOrderApp
//
//  Created by Ranula Ranatunga on 2024-12-06.
//

import 'package:flutter/material.dart';
import 'package:food_order_app/util/app_theme.dart';
import 'package:food_order_app/views/category_screen.dart';
import 'package:provider/provider.dart';
import '../controllers/menu_controller.dart' as app;

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<app.MenuController>(context, listen: false).fetchMenus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Food Menus', style: AppTheme.headingStyle),
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
      ),
      body: Consumer<app.MenuController>(
        builder: (context, menuController, child) {
          // print('Menus length: ${menuController.menus.length}');
          if (menuController.menus.isEmpty) {
            return const Center(
              child: Text(
                'No menus available',
                style: AppTheme.headingStyle,
              ),
            );
          }
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.8,
            ),
            itemCount: menuController.menus.length,
            itemBuilder: (context, index) {
              final menu = menuController.menus[index];
              return GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CategoryScreen(menuId: menu.menuId),
                  ),
                ),
                child: Container(
                  decoration: AppTheme.cardDecoration,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.restaurant_menu,
                        size: 80,
                        color: AppTheme.primaryColor,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        menu.name,
                        style: AppTheme.headingStyle.copyWith(fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
