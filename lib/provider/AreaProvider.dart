import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../constant/constant.dart';
import '../models/Area.dart';

class AreaProvider with ChangeNotifier {
  List<Area> _areas = [];
  bool _isLoading = false;

  List<Area> get areas => _areas;
  bool get isLoading => _isLoading;

  // Fetch areas from the API
  Future<void> fetchAreas() async {
    _isLoading = true;
    notifyListeners();

    final url = Uri.parse('$base_url/api/areas');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          final List<dynamic> areasJson = data['data'];
          _areas = areasJson.map((json) => Area.fromJson(json)).toList();
        }
      } else {
        throw Exception('Failed to load areas');
      }
    } catch (error) {
      throw error;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
