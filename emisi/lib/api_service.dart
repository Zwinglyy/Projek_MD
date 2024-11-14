import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://script.google.com/macros/s/AKfycbzH2q5vUjJsxShhl0oE1vE111oRS4af2UFZRW32kPWXS3C77wavzkSubtX5tJSMK6ow/exec';

  static const String getUsersAction = 'getUsers';
  static const String getDashboardAction = 'getDashboard';
  static const String registerUserAction = 'registerUser';


  Future<List<dynamic>> fetchUsers() async {
    final response = await http.get(Uri.parse('$baseUrl?action=$getUsersAction'));
    return _handleResponse(response);
  }

  Future<List<dynamic>> fetchDashboard() async {
    final response = await http.get(Uri.parse('$baseUrl?action=$getDashboardAction'));
    return _handleResponse(response);
  }


// Login User [START]
  Future<Map<String, dynamic>> loginUser({
    required String action,
    required String userName,
    required String userPasswd,
  }) async {
    final Uri uri = Uri.parse(baseUrl).replace(queryParameters: {
      'action': action,
      'userName': userName,
      'userPasswd': userPasswd,
    });

  final response = await http.get(uri);
  print(response.body);

    if (response.statusCode == 200) {
      try {
        // Decode the response body
        final data = jsonDecode(response.body);
        print(data);
        return data;
      } catch (e) {
        throw Exception('Error decoding response: $e');
      }
    } else {
      throw Exception('Failed to register user. Status code: ${response.statusCode}. Reason: ${response.reasonPhrase}. Headers: ${response.headers}');
    }
  }


// Login User [END]

// Register User [START]
  Future<Map<String, dynamic>> registerUser({
    required String action,
    required String dateTime,
    required String userName,
    required String userPasswd,
    required String phoneNumber,
  }) async {
    final Uri uri = Uri.parse(baseUrl).replace(queryParameters: {
      'action': action,
      'dateTime': dateTime,
      'userName': userName,
      'userPasswd': userPasswd,
      'phoneNumber': phoneNumber,
    });

    final response = await http.post(uri);

    if (response.statusCode == 200) {
      try {
        // Decode the response body
        final data = jsonDecode(response.body);
        return data;
      } catch (e) {
        throw Exception('Error decoding response: $e');
      }
    } else {
      throw Exception('Failed to register user. Status code: ${response.statusCode}. Reason: ${response.reasonPhrase}. Headers: ${response.headers}');
    }
  }

// Register User [END]

// POST REQUEST [START]
  Future<Map<String, dynamic>> _postRequest(String action, Map<String, String> body) async {
    final response = await http.post(
      Uri.parse('$baseUrl?action=$action'),
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );
    return _handleResponse(response);
  }
// POST REQUEST [END]

// HANDLE RESPONSE [START]
  dynamic _handleResponse(http.Response response) {
    if (response.statusCode == 200) {
      try {
        final decodedData = jsonDecode(response.body);
        if (decodedData is Map || decodedData is List) {
          return decodedData;
        } else {
          throw Exception('Unexpected response format');
        }
      } catch (e) {
        print('Error decoding response: $e');
        throw Exception('Error decoding response: $e');
      }
    } else {
      print('Error ${response.statusCode}: ${response.reasonPhrase}');
      throw Exception('Failed to load data: ${response.statusCode} - ${response.reasonPhrase}');
    }
  }
  logoutUser() {}
// HANDLE RESPONSE [END]
}

