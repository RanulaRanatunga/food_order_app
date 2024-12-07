//
//  MenuItemCard
//  FoodOrderApp
//
//  Created by Ranula Ranatunga on 2024-12-06.
//

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/menu_item_model.dart';
import '../controllers/menu_item_controller.dart';

class MenuItemCard extends StatelessWidget {
  final MenuItemModel menuItem;

  const MenuItemCard({
    super.key,
    required this.menuItem,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            if (menuItem.imageUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  menuItem.imageUrl!,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    menuItem.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    menuItem.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${menuItem.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
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
              child: const Text('Add to Cart'),
            ),
          ],
        ),
      ),
    );
  }
}

// Cart Screen
class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  CartScreenState createState() => CartScreenState();
}

class CartScreenState extends State<CartScreen> {
  final Map<MenuItemModel, int> cart = {};

  void _addToCart(MenuItemModel menuItem) {
    setState(() {
      if (cart.containsKey(menuItem)) {
        cart[menuItem] = cart[menuItem]! + 1;
      } else {
        cart[menuItem] = 1;
      }
    });
  }

  void _removeFromCart(MenuItemModel menuItem) {
    setState(() {
      if (cart.containsKey(menuItem)) {
        if (cart[menuItem]! > 1) {
          cart[menuItem] = cart[menuItem]! - 1;
        } else {
          cart.remove(menuItem);
        }
      }
    });
  }

  void _checkout() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Order placed successfully!'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (cart.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: cart.length,
                  itemBuilder: (context, index) {
                    final entry = cart.entries.elementAt(index);
                    final menuItem = entry.key;
                    final quantity = entry.value;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          if (menuItem.imageUrl != null)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                menuItem.imageUrl!,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                            ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  menuItem.name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '\$${menuItem.price.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Quantity: $quantity',
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () => _removeFromCart(menuItem),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () => _addToCart(menuItem),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              )
            else
              const Center(
                child: Text('Your cart is empty'),
              ),
            const SizedBox(height: 16),
            if (cart.isNotEmpty)
              ElevatedButton(
                onPressed: _checkout,
                child: const Text('Checkout'),
              ),
          ],
        ),
      ),
    );
  }
}
