import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../constant/constant.dart';
import '../models/reservation_model.dart';

class ReservationProvider with ChangeNotifier {
  static const String _baseUrl = '$base_url/api/reservations';
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  // Modify the return type to ReservationResponse
  Future<ReservationResponse?> createReservation({
    required String name,
    required String phone,
    required String carType,
    required String carModel,
    required int manufacturingYear,
    required String problemDetails,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "name": name,
          "phone": phone,
          "car_type": carType,
          "car_model": carModel,
          "manufacturing_year": manufacturingYear,
          "problem_details": problemDetails,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return ReservationResponse.fromJson(data);  // Update to return ReservationResponse
      } else {
        throw Exception('Failed to create reservation: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
