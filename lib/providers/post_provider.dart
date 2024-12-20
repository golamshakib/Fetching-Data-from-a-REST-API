import 'dart:convert';

import 'package:assignment_1_fetching_data_from_api/models/post_model.dart';
import 'package:assignment_1_fetching_data_from_api/services/api_services.dart';
import 'package:flutter/foundation.dart';

class PostProvider with ChangeNotifier {
  List<PostModel> _postsList = [];
  String? _errorMessage;
  bool _isLoading = false;

  /// -- Getter
  List<PostModel> get postsList => _postsList;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;

  /// -- Get all Posts Method
  Future<void> getAllPosts({required bool isConnected}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    if (isConnected) {
      try {
        final response = await ApiServices.getAllPosts();

        if (response.statusCode == 200) {
          final List<dynamic> mapData = jsonDecode(response.body);
          _postsList = mapData.map((json) => PostModel.fromJson(json)).toList();
        } else {
          _errorMessage = 'Error: ${response.statusCode}';
        }
      } catch (e) {
        _errorMessage = 'Error fetching the data: ${e.toString()}';
      }
    }
    _isLoading = false;
    notifyListeners();
  }

  /// -- Clear Posts Method
  void clearPosts() {
    _postsList = [];
    notifyListeners();
  }
}
