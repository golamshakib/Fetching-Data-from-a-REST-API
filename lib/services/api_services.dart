import 'package:assignment_1_fetching_data_from_api/utils/constants/api_endpoints.dart';
import 'package:http/http.dart' as http;

class ApiServices {
  static Future<http.Response> getAllPosts() async {
    try {
      return await http.get(ApiEndpoints.getAllPosts);
    } catch (e) {
      throw Exception('Failed to connect to the server: ${e.toString()}');
    }
  }
}
