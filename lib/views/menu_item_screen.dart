//
//  MenuItemScreen
//  FoodOrderApp
//
//  Created by Ranula Ranatunga on 2024-12-06.
//

import 'package:flutter/material.dart';
import 'package:food_order_app/controllers/menu_item_controller.dart';
import 'package:food_order_app/util/app_theme.dart';
import 'package:provider/provider.dart';

class MenuItemScreen extends StatefulWidget {
  final String categoryId;
  const MenuItemScreen({super.key, required this.categoryId});

  @override
  State<MenuItemScreen> createState() => _MenuItemScreenState();
}

class _MenuItemScreenState extends State<MenuItemScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MenuItemController>(context, listen: false)
          .fetchMenuItems(widget.categoryId);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Menu Items', style: AppTheme.headingStyle),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search Menu Items',
                prefixIcon:
                    const Icon(Icons.search, color: AppTheme.primaryColor),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear,
                            color: AppTheme.primaryColor),
                        onPressed: () {
                          _searchController.clear();
                          Provider.of<MenuItemController>(context,
                                  listen: false)
                              .resetFilter();
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                Provider.of<MenuItemController>(context, listen: false)
                    .filterMenuItems(value);
              },
            ),
          ),
          Expanded(
            child: Consumer<MenuItemController>(
              builder: (context, menuItemController, child) {
                if (menuItemController.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppTheme.primaryColor,
                    ),
                  );
                }
                if (menuItemController.errorMessage != null) {
                  return Center(
                    child: Text(
                      menuItemController.errorMessage!,
                      style: AppTheme.headingStyle.copyWith(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  );
                }
                if (menuItemController.menuItems.isEmpty) {
                  return const Center(
                    child: Text(
                      'No menu items found',
                      style: AppTheme.headingStyle,
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: menuItemController.menuItems.length,
                  itemBuilder: (context, index) {
                    final menuItem = menuItemController.menuItems[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        title: Text(
                          menuItem.name,
                          style: AppTheme.headingStyle.copyWith(fontSize: 18),
                        ),
                        subtitle: Text(
                          menuItem.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: Text(
                          '\$${menuItem.price.toStringAsFixed(2)}',
                          style: AppTheme.headingStyle.copyWith(
                            color: AppTheme.primaryColor,
                            fontSize: 16,
                          ),
                        ),
                        onTap: () {
                         menuItemController.selectMenuItem(menuItem);
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
