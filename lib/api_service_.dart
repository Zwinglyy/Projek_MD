import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl =
      'https://script.google.com/macros/s/AKfycbxTVAUFGkd0FrRmWlxJVoaWo-sTwcAhAcVZgyUmjR3FvAlWZy1pPzBGVbjZR1EjxieA/exec';

  static const String logoutUserAction = 'logoutUser';

  Future<Map<String, dynamic>> postCarbonProduced({
    required String action,
    required String dateTime,
    required String userId,
    required String carbonProducedTypeId,
    String? cptElectricpowId,
    String? cptTransportId,
    double? duration,
    double? distance,
  }) async {
    try {
      final Map<String, String> queryParameters = {
        'action': action,
        'dateTime': dateTime,
        'userId': userId,
        'carbonProducedTypeId': carbonProducedTypeId,
        'cptElectricpowId': cptElectricpowId ?? 'null',
        'cptTransportId': cptTransportId ?? 'null',
      };

      if (carbonProducedTypeId == 'CPT-ElectricPower' && duration != null) {
        queryParameters['duration'] = duration.toString();
      } else if (carbonProducedTypeId == 'CPT-Transport' && distance != null) {
        queryParameters['distance'] = distance.toString();
      }

      // Membentuk URI dengan queryParameters
      final Uri uri =
          Uri.parse(baseUrl).replace(queryParameters: queryParameters);

      // Melakukan POST request
      final response = await http.post(uri);

      if (response.statusCode == 200) {
        try {
          // Parsing hasil response JSON
          final data = jsonDecode(response.body);
          return data;
        } catch (e) {
          throw Exception('Error decoding response: $e');
        }
      } else {
        throw Exception(
            'Failed to post carbon produced data. Status code: ${response.statusCode}. Reason: ${response.reasonPhrase}. Headers: ${response.headers}');
      }
    } catch (error) {
      // Mengembalikan error dalam format map
      return {'status': 'FAILED', 'msg': error.toString()};
    }
  }

  Future<Map<String, dynamic>> getCarbonProducedType() async {
    try {
      final response =
          await http.get(Uri.parse(baseUrl).replace(queryParameters: {
            'action': 'getCarbonProducedType',
            }));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception(
            'Failed to fetch Carbon Produced Type. Status code: ${response.statusCode}');
      }
    } catch (error) {
      return {'status': 'FAILED', 'msg': error.toString()};
    }
  }

  // Fungsi untuk mengambil data CPT-ElectricPower
  Future<Map<String, dynamic>> getCPTElectricPower() async {
    try {
      final response =
          await http.get(Uri.parse(baseUrl).replace(queryParameters: {
            'action': 'getCPTElectricPower',
            }));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception(
            'Failed to fetch CPT-ElectricPower. Status code: ${response.statusCode}');
      }
    } catch (error) {
      return {'status': 'FAILED', 'msg': error.toString()};
    }
  }

  // Fungsi untuk mengambil data CPT-Transport
  Future<Map<String, dynamic>> getCPTTransport() async {
    try {
      final response = await http.get(Uri.parse(baseUrl).replace(queryParameters: {
        'action': 'getCPT_Transport',
      }));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception(
            'Failed to fetch CPT-Transport. Status code: ${response.statusCode}');
      }
    } catch (error) {
      return {'status': 'FAILED', 'msg': error.toString()};
    }
  }

  // Fungsi untuk mengambil data CarbonProduced berdasarkan userId
  Future<Map<String, dynamic>> getCarbonProduced(String userId) async {
    try {
      final Uri uri = Uri.parse(baseUrl).replace(queryParameters: {
        'action': 'getCarbonProduced',
        'userId': userId,
      });

      final response = await http.get(uri);
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception(
            'Failed to fetch Carbon Produced. Status code: ${response.statusCode}');
      }
    } catch (error) {
      return {'status': 'FAILED', 'msg': error.toString()};
    }
  }

  Future<void> signOutUser() async {
    final response = await http.post(
      Uri.parse('$baseUrl?action=$logoutUserAction'),
    );

    _handleResponse(response);
  }

  Future<Map<String, dynamic>> getTotalEmisiForUser({
    required String userId,
  }) async {
    final Uri uri = Uri.parse(baseUrl).replace(queryParameters: {
      'action':'getTotalEmisiForUser',
      'userId': userId,
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
      throw Exception(
          'Failed to load total emission. Status code: ${response.statusCode}. Reason: ${response.reasonPhrase}. Headers: ${response.headers}');
    }
  }

// GET PERSONAL QUESTION
  Future<List<Map<String, String>>> getQuestions() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl?action=getQuestion'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        return data
            .map((item) => {
                  'pqId':
                      item['pqId']?.toString() ?? 'Unknown',
                  'pqQuestion': item['pqQuestion']?.toString() ?? 'No Question',
                })
            .toList();
      } else {
        throw Exception('Failed to load questions');
      }
    } catch (e) {
      throw Exception('Error fetching questions: $e');
    }
  }
// GET PERSONAL QUESTION [END]

// Login User [START]
  Future<Map<String, dynamic>> loginUser({
    required String action,
    required String phoneNumber,
    required String userPasswd,
  }) async {
    final Uri uri = Uri.parse(baseUrl).replace(queryParameters: {
      'action': action,
      'phoneNumber': phoneNumber,
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
      throw Exception(
          'Failed to login user. Status code: ${response.statusCode}. Reason: ${response.reasonPhrase}. Headers: ${response.headers}');
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
    required String address,
    required String pqId,
    required String pqAnswer,
  }) async {
    final Uri uri = Uri.parse(baseUrl).replace(queryParameters: {
      'action': action,
      'dateTime': dateTime,
      'userName': userName,
      'userPasswd': userPasswd,
      'phoneNumber': phoneNumber,
      'address': address,
      'pqId': pqId,
      'pqAnswer': pqAnswer,
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
      throw Exception(
          'Failed to register user. Status code: ${response.statusCode}. Reason: ${response.reasonPhrase}. Headers: ${response.headers}');
    }
  }
// Register User [END]

// POST REQUEST [START]
  Future<Map<String, dynamic>> _postRequest(
      String action, Map<String, String> body) async {
    final response = await http.post(
      Uri.parse('$baseUrl?action=$action'),
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );
    return _handleResponse(response);
  }
// POST REQUEST [END]

// EXPENSE RESPONSE HANDLER [START]
  dynamic _handleExpenseResponse(http.Response response) {
    if (response.statusCode == 200) {
      try {
        final decodedData = jsonDecode(response.body);

        // Periksa apakah data adalah List
        if (decodedData is List) {
          return decodedData; // Mengembalikan List jika tipe data sesuai
        }
        // Jika data adalah Map, ambil nilai tertentu atau kembalikan list kosong
        else if (decodedData is Map) {
          // Misalnya, jika map berisi pesan atau detail lainnya
          print('Received a Map: $decodedData');
          return []; // Mengembalikan list kosong jika tidak ada data
        } else {
          throw Exception(
              'Unexpected response format: ${decodedData.runtimeType}');
        }
      } catch (e) {
        print('Error decoding response: $e');
        throw Exception('Error decoding response: $e');
      }
    } else {
      print('Error ${response.statusCode}: ${response.reasonPhrase}');
      throw Exception(
          'Failed to load data: ${response.statusCode} - ${response.reasonPhrase}');
    }
  }

// fgt
// HANDLE RESPONSE [START]
  dynamic _handleResponseFgt(http.Response response) {
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
      throw Exception(
          'Failed to load data: ${response.statusCode} - ${response.reasonPhrase}');
    }
  }

  // inc
  dynamic _handleResponse(http.Response response) {
    if (response.statusCode == 200) {
      try {
        final decodedData = jsonDecode(response.body);
        if (decodedData is List) {
          return decodedData; // If it's a list, return it
        } else if (decodedData is Map) {
          // If it's a map, check for an error message or return an empty list
          print('Received a Map: $decodedData');
          return []; // Return an empty list or handle it accordingly
        } else {
          throw Exception('Unexpected response format');
        }
      } catch (e) {
        print('Error decoding response: $e');
        throw Exception('Error decoding response: $e');
      }
    } else {
      print('Error ${response.statusCode}: ${response.reasonPhrase}');
      throw Exception(
          'Failed to load data: ${response.statusCode} - ${response.reasonPhrase}');
    }
  }

// HANDLE RESPONSE [END]

// LOGOUT USER [START]
  Future<Map<String, dynamic>> logoutUser() async {
    final Uri uri = Uri.parse(baseUrl).replace(queryParameters: {
      'action': logoutUserAction,
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
      throw Exception('Failed to logout. Status code: ${response.statusCode}');
    }
  }
// LOGOUT USER [END]

// API untuk verifikasi nomor telepon dan mendapatkan pertanyaan pribadi
  Future<Map<String, dynamic>> verifyPhoneNumber({
    required String action,
    required String phoneNumber,
  }) async {
    final Uri uri = Uri.parse(baseUrl).replace(queryParameters: {
      'action': action,
      'phoneNumber': phoneNumber,
    });

    final response = await http.get(uri);

    return _handleResponseFgt(response);
  }

// API untuk memverifikasi jawaban dari pertanyaan pribadi
  Future<Map<String, dynamic>> validatePQAnswer({
    required String action,
    required String phoneNumber,
    required String pqId,
    required String pqAnswer,
  }) async {
    final Uri uri = Uri.parse(baseUrl).replace(queryParameters: {
      'action': action,
      'phoneNumber': phoneNumber,
      'pqId': pqId,
      'pqAnswer': pqAnswer,
    });

    final response = await http.get(uri);
    return _handleResponseFgt(response);
  }

// API untuk mengubah kata sandi
  Future<Map<String, dynamic>> changePassword({
    required String action,
    required String phoneNumber,
    required String newPasswd,
  }) async {
    final Uri uri = Uri.parse(baseUrl).replace(queryParameters: {
      'action': action,
      'phoneNumber': phoneNumber,
      'newPasswd': newPasswd,
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
      throw Exception(
          'Failed to register user. Status code: ${response.statusCode}. Reason: ${response.reasonPhrase}. Headers: ${response.headers}');
    }
  }
}
