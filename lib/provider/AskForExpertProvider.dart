import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../constant/constant.dart';
import '../models/AskForExpertRequest.dart';
class AskForExpertProvider with ChangeNotifier {
  AskForExpertResponse? _expertResponse;
  bool _isLoading = false;

  // Getters for response and loading state
  AskForExpertResponse? get expertResponse => _expertResponse;
  bool get isLoading => _isLoading;

  // Setter for isLoading (with notifyListeners)
  set isLoading(bool value) {
    if (_isLoading != value) {
      _isLoading = value;
      notifyListeners();
    }
  }

  /// Method to send the request for an expert
  Future<AskForExpertResponse?> askForExpert(AskForExpertRequest request) async {
    isLoading = true; // Set loading state to true

    final url = Uri.parse('$base_url/api/ask-for-expert');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(request.toJson()),
      );

      // Check if the response is successful
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);

        if (data['success'] == true) {
          // Parse and set the response
          _expertResponse = AskForExpertResponse.fromJson(data['data']);
          notifyListeners(); // Notify listeners about the new response
          return _expertResponse;
        } else {
          throw Exception(data['message'] ?? 'Request failed: success is false');
        }
      } else {
        throw Exception('Server returned an error: ${response.statusCode}');
      }
    } catch (error) {
      rethrow; // Rethrow the error for the caller to handle
    } finally {
      isLoading = false; // Set loading state to false
    }
  }
}
