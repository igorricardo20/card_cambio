import 'package:flutter/material.dart';
import '../services/ptax_service.dart';

class PtaxProvider with ChangeNotifier {
  double? _ptax;
  bool _loading = false;
  String? _error;

  double? get ptax => _ptax;
  bool get loading => _loading;
  String? get error => _error;

  Future<void> fetchPtaxForToday() async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      final today = DateTime.now();
      final yesterday = DateTime(today.year, today.month, today.day - 1);
      final value = await PtaxService().fetchCurrentPtax(yesterday);
      _ptax = value;
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
