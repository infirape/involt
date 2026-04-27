import 'package:flutter/material.dart';
import '../../data/database.dart';

class AppStateProvider extends ChangeNotifier {
  final AppDatabase db;
  String _selectedPeriod = '';
  bool _isLoading = true;

  AppStateProvider(this.db) {
    _init();
  }

  String get selectedPeriod => _selectedPeriod;
  bool get isLoading => _isLoading;
  
  List<String> get availablePeriods {
    final now = DateTime.now();
    return List.generate(6, (i) {
      final date = DateTime(now.year, now.month - i);
      return '${date.year}-${date.month.toString().padLeft(2, '0')}';
    });
  }

  Future<void> _init() async {
    await loadPeriod();
  }

  Future<void> loadPeriod() async {
    _isLoading = true;
    notifyListeners();

    final setting = await (db.select(db.settings)
          ..where((t) => t.key.equals('current_period')))
        .getSingleOrNull();

    if (setting != null) {
      _selectedPeriod = setting.value;
    } else {
      // Default to current month if not set
      final now = DateTime.now();
      _selectedPeriod = '${now.year}-${now.month.toString().padLeft(2, '0')}';
      await setPeriod(_selectedPeriod);
    }
    
    _isLoading = false;
    notifyListeners();
  }

  Future<void> setPeriod(String period) async {
    _selectedPeriod = period;
    await db.into(db.settings).insertOnConflictUpdate(
          SettingsCompanion.insert(key: 'current_period', value: period),
        );
    notifyListeners();
  }
}
