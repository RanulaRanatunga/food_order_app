//
//  ModifierScreen
//  FoodOrderApp
//
//  Created by Ranula Ranatunga on 2024-12-06.
//

import 'package:flutter/material.dart';
import 'package:food_order_app/controllers/modifier_controller.dart';
import 'package:food_order_app/models/modifier_model.dart';
import 'package:provider/provider.dart';

class ModifierScreen extends StatefulWidget {
  final String? initialModifierGroupId;

  const ModifierScreen({
    super.key,
    this.initialModifierGroupId,
  });

  @override
  State<ModifierScreen> createState() => ModifierScreenState();
}

class ModifierScreenState extends State<ModifierScreen> {
  late final ModifierController _modifierController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _modifierController = ModifierController();
    _searchController.addListener(_onSearchChanged);
    _initializeModifierGroup();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
    });
  }

  void _initializeModifierGroup() {
    if (widget.initialModifierGroupId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final initialGroup = _modifierController
            .findModifierGroupById(widget.initialModifierGroupId!);
        if (initialGroup != null) {
          _modifierController.addModifierGroup(initialGroup);
        }
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<ModifierGroupModel> _filterModifierGroups(
      List<ModifierGroupModel> groups) {
    if (_searchQuery.isEmpty) return groups;

    return groups.where((group) {
      final lowercaseQuery = _searchQuery.toLowerCase();

      return group.title.toLowerCase().contains(lowercaseQuery) ||
          group.ids.any((id) => id.toLowerCase().contains(lowercaseQuery));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _modifierController,
      child: Scaffold(
        appBar: _buildAppBar(),
        body: _buildBody(),
        bottomNavigationBar: _buildBottomBar(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('Modifier Groups'),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search Modifier Groups',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();

                        setState(() {
                          _searchQuery = '';
                        });
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
          ),
        ),
      ),
      actions: [
        Consumer<ModifierController>(
          builder: (context, controller, child) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Text(
                  'Selected: ${controller.totalSelectedModifierGroups}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildBody() {
    return Consumer<ModifierController>(
      builder: (context, controller, child) {
        if (controller.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (controller.errorMessage != null) {
          return _buildErrorWidget(controller);
        }

        final filteredGroups = _filterModifierGroups(controller.modifierGroups);
        if (filteredGroups.isEmpty) {
          return _buildEmptyStateWidget();
        }

        return ListView.builder(
          itemCount: filteredGroups.length,
          itemBuilder: (context, index) {
            final modifierGroup = filteredGroups[index];
            return _buildModifierGroupTile(modifierGroup);
          },
        );
      },
    );
  }

  Widget _buildErrorWidget(ModifierController controller) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 60,
          ),
          const SizedBox(height: 16),
          Text(
            'Error: ${controller.errorMessage}',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => controller.refreshData(),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyStateWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.search_off,
            size: 60,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          const Text(
            'No Modifier Groups Found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try a different search term',
            style: TextStyle(
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModifierGroupTile(ModifierGroupModel modifierGroup) {
    return Consumer<ModifierController>(
      builder: (context, controller, child) {
        final isSelected = controller.isModifierGroupSelected(modifierGroup);

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: ListTile(
            title: Text(
              modifierGroup.title,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            subtitle: Text('ID: ${modifierGroup.ids.first}'),
            trailing: Checkbox(
              value: isSelected,
              onChanged: (bool? value) {
                if (value == true) {
                  controller.addModifierGroup(modifierGroup);
                } else {
                  controller.removeModifierGroup(modifierGroup);
                }
              },
            ),
            onTap: () {
              if (isSelected) {
                controller.removeModifierGroup(modifierGroup);
              } else {
                controller.addModifierGroup(modifierGroup);
              }
            },
          ),
        );
      },
    );
  }

  Widget _buildBottomBar() {
    return Consumer<ModifierController>(
      builder: (context, controller, child) {
        return BottomAppBar(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: controller.totalSelectedModifierGroups > 0
                      ? () {
                          Navigator.of(context).pop(
                            controller.selectedModifierGroups,
                          );
                        }
                      : null,
                  icon: const Icon(Icons.check),
                  label: const Text('Done'),
                ),
                ElevatedButton.icon(
                  onPressed: controller.totalSelectedModifierGroups > 0
                      ? controller.clearSelectedModifierGroups
                      : null,
                  icon: const Icon(Icons.clear),
                  label: const Text('Clear Selection'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
