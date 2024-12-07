//
//  MenuItemScreen
//  FoodOrderApp
//
//  Created by Ranula Ranatunga on 2024-12-06.
//

import 'package:flutter/material.dart';
import 'package:food_order_app/controllers/menu_item_controller.dart';
import 'package:food_order_app/models/menu_item_model.dart';
import 'package:food_order_app/util/app_theme.dart';
import 'package:food_order_app/views/modifier_screen.dart';
import 'package:provider/provider.dart';

class MenuItemScreen extends StatefulWidget {
  final String categoryId;

  const MenuItemScreen({super.key, required this.categoryId});

  @override
  State<MenuItemScreen> createState() => MenuItemScreenState();
}

class MenuItemScreenState extends State<MenuItemScreen> {
  String selectedMenu = 'Lunch : 10am - 5pm';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MenuItemController>(context, listen: false)
          .fetchMenuItemsByCategory(widget.categoryId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Center(
            child: Text('Menu Items', style: AppTheme.headingStyle)),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: _showSelectMenuBottomSheet,
            child: const Text('Select Menu'),
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
                  return Center(
                    child: Text(
                      menuItemController.errorMessage ??
                          'No menu items found for this category',
                      style: AppTheme.headingStyle,
                      textAlign: TextAlign.center,
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: menuItemController.menuItems.length,
                  itemBuilder: (context, index) {
                    final menuItem = menuItemController.menuItems[index];
                    return _buildMenuItemCard(menuItem);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showSelectMenuBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select menu',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              RadioListTile(
                title: const Text('Lunch : 10am - 5pm'),
                value: 'Lunch : 10am - 5pm',
                groupValue: selectedMenu,
                onChanged: (value) {
                  setState(() {
                    selectedMenu = value.toString();
                  });
                  Navigator.of(context).pop();
                },
              ),
              RadioListTile(
                title: const Text('Breakfast : 5pm - 11pm'),
                value: 'Breakfast : 5pm - 11pm',
                groupValue: selectedMenu,
                onChanged: (value) {
                  setState(() {
                    selectedMenu = value.toString();
                  });
                  Navigator.of(context).pop();
                },
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: AppTheme.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32.0),
                        ),
                      ),
                      child: const Text("Done"),
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildMenuItemCard(MenuItemModel menuItem) {
    return GestureDetector(
      onTap: () => _showMenuItemDetails(menuItem),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: AppTheme.cardDecoration,
        child: Row(
          children: [
            if (menuItem.imageUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  menuItem.imageUrl!,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      menuItem.name,
                      style: AppTheme.headingStyle.copyWith(fontSize: 18),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '\$${menuItem.price.toStringAsFixed(2)}',
                      style: AppTheme.bodyTextStyle,
                    ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 12),
              child: Icon(
                Icons.arrow_forward_ios,
                color: AppTheme.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showMenuItemDetails(MenuItemModel menuItem) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        builder: (_, controller) => Container(
          decoration: const BoxDecoration(
            color: AppTheme.backgroundColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: ListView(
            controller: controller,
            padding: const EdgeInsets.all(16),
            children: [
              if (menuItem.imageUrl != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    menuItem.imageUrl!,
                    width: double.infinity,
                    height: 240,
                    fit: BoxFit.cover,
                  ),
                ),
              const SizedBox(height: 16),
              Text(
                menuItem.name,
                style: AppTheme.headingStyle.copyWith(fontSize: 22),
              ),
              const SizedBox(height: 8),
              Text(
                menuItem.description,
                style: AppTheme.bodyTextStyle,
              ),
              const SizedBox(height: 16),
              Text(
                '\$${menuItem.price.toStringAsFixed(2)}',
                style: AppTheme.headingStyle.copyWith(
                  color: AppTheme.primaryColor,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 16),
              if (menuItem.nutritionalInfo != null)
                _buildNutritionalInfoSection(menuItem),
              ElevatedButton(
                onPressed: () => _navigateToModifierScreen(context, menuItem),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add),
                    SizedBox(width: 8),
                    Text('Add Modifiers'),
                  ],
                ),
              ),
              _buildSelectedModifiers(menuItem),
              ElevatedButton(
                onPressed: () {
                  Provider.of<MenuItemController>(context, listen: false)
                      .addToCart(menuItem);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${menuItem.name} added to cart'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
                child: const Text(
                  'Add to Cart',
                  style: AppTheme.buttonTextStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToModifierScreen(
      BuildContext context, MenuItemModel menuItem) async {
    final result = await Navigator.push<List<ModifierGroupModel>>(
      context,
      MaterialPageRoute(
        builder: (context) => ModifierScreen(
          initialModifierGroupId: menuItem.modifierGroupId,
        ),
      ),
    );

    if (result != null) {
      setState(() {
        menuItem.modifiers = result;
      });
    }
  }

  Widget _buildSelectedModifiers(MenuItemModel menuItem) {
    if (menuItem.modifiers == null || menuItem.modifiers!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Selected Modifiers',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        ...menuItem.modifiers!.map(
          (modifierGroup) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  modifierGroup.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                ...modifierGroup.modifiers.map(
                  (modifier) => Padding(
                    padding: const EdgeInsets.only(left: 16, top: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(modifier.name),
                        Text('\$${modifier.price.toStringAsFixed(2)}'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNutritionalInfoSection(MenuItemModel menuItem) {
    if (menuItem.nutritionalInfo == null) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Nutritional Information',
          style: AppTheme.headingStyle.copyWith(fontSize: 18),
        ),
        const SizedBox(height: 8),
        _buildNutritionalInfo(
          'Calories',
          '${menuItem.nutritionalInfo!.calories} kcal',
        ),
        _buildNutritionalInfo(
          'Fat',
          '${menuItem.nutritionalInfo!.fat}g',
        ),
        _buildNutritionalInfo(
          'Carbs',
          '${menuItem.nutritionalInfo!.carbs}g',
        ),
        _buildNutritionalInfo(
          'Protein',
          '${menuItem.nutritionalInfo!.protein}g',
        ),
      ],
    );
  }

  Widget _buildNutritionalInfo(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTheme.bodyTextStyle,
        ),
        Text(
          value,
          style: AppTheme.bodyTextStyle,
        ),
      ],
    );
  }
}
