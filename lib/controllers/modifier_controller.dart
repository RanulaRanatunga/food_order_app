//
//  ModifierController
//  FoodOrderApp
//
//  Created by Ranula Ranatunga on 2024-12-06.
//

import 'package:flutter/foundation.dart';
import 'package:food_order_app/models/modifier_model.dart';
import 'package:food_order_app/services/data_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ModifierController extends ChangeNotifier {
  final List<ModifierGroupModel> _selectedModifierGroups = [];
  List<ModifierGroupModel> _modifierGroups = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<ModifierGroupModel> get selectedModifierGroups =>
      List.unmodifiable(_selectedModifierGroups);

  List<ModifierGroupModel> get modifierGroups =>
      List.unmodifiable(_modifierGroups);

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get totalSelectedModifierGroups => _selectedModifierGroups.length;

  ModifierController() {
    loadModifierGroups();
  }

  Future<void> loadModifierGroups() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final jsonData = await DataService.loadJsonData();
      if (jsonData['Status'] == true) {
        final result = jsonData['Result'];
        final modifierGroupsJson = result['ModifierGroups'] ?? [];
        _modifierGroups =
            modifierGroupsJson.map<ModifierGroupModel>((groupJson) {
          return ModifierGroupModel.fromJson(groupJson);
        }).toList();

        _isLoading = false;

        notifyListeners();
      } else {
        _isLoading = false;
        _errorMessage = jsonData['Error'] ?? 'Failed to load modifier groups';
        notifyListeners();
      }
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  void addModifierGroup(ModifierGroupModel modifierGroup) {
    if (canAddModifierGroup(modifierGroup)) {
      _selectedModifierGroups.add(modifierGroup);
      notifyListeners();
    }
  }

  void removeModifierGroup(ModifierGroupModel modifierGroup) {
    if (_selectedModifierGroups.remove(modifierGroup)) {
      notifyListeners();
    }
  }

  bool canAddModifierGroup(ModifierGroupModel modifierGroup) {
    return !_selectedModifierGroups
        .any((group) => group.id == modifierGroup.id);
  }

  bool isModifierGroupSelected(ModifierGroupModel modifierGroup) {
    return _selectedModifierGroups.contains(modifierGroup);
  }

  void clearSelectedModifierGroups() {
    if (_selectedModifierGroups.isNotEmpty) {
      _selectedModifierGroups.clear();
      notifyListeners();
    }
  }

  ModifierGroupModel? findModifierGroupById(String id) {
    try {
      return _modifierGroups.firstWhere((group) => group.id == id);
    } catch (e) {
      return null;
    }
  }

  List<ModifierGroupModel> getModifierGroupsByIds(List<String> ids) {
    return ids
        .map((id) => findModifierGroupById(id))
        .where((group) => group != null)
        .cast<ModifierGroupModel>()
        .toList();
  }

  Future<void> refreshData() async {
    DataService.clearCache();
    await loadModifierGroups();
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
            subtitle: Text(
              modifierGroup.ids.isNotEmpty
                  ? 'ID: ${modifierGroup.ids.first}'
                  : 'No ID available',
            ),
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
          ),
        );
      },
    );
  }

  Widget buildModifierGroupList() {
    return ListView.builder(
      itemCount: modifierGroups.length,
      itemBuilder: (context, index) {
        return _buildModifierGroupTile(modifierGroups[index]);
      },
    );
  }
}
