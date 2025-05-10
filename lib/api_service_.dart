import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl =
      'https://script.google.com/macros/s/AKfycbxbEMur-PKA00sZPVh3yPSQ46Y0VbfYAntltATRd2Bo1-fp9rj3dmR0t8J0s_wJAaiQ/exec';

  static const String getIncomeAction = 'getIncome';
  static const String getExpenseAction = 'getExpense';
  static const String getUsersAction = 'getUsers';
  static const String getProductsAction = 'getProducts';
  static const String getServicesAction = 'getServices';
  static const String getDashboardAction = 'getDashboard';
  static const String registerUserAction = 'registerUser';
  static const String addIncomeAction = 'addIncome';
  static const String addIncomeTypeAction = 'addIncomeType';
  static const String addExpenseAction = 'addExpense';
  static const String addExpenseTypeAction = 'addExpenseType';
  static const String updateExpenseAmountAction = 'updateExpenseAmount';
  static const String updateIncomeQuantityAction = 'updateIncomeQuantity';
  static const String getExpenseTypesAction = 'getExpenseTypes';
  static const String getIncomeTypesAction = 'getIncomeTypes';
  static const String logoutUserAction = 'logoutUser';
  static const String filterTransactionsAction = 'filterTransactions';

  Future<List<dynamic>> fetchIncome({
    required String userId,
  }) async {
    final Uri uri = Uri.parse(baseUrl).replace(queryParameters: {
      'action': 'getIncome',
      'userId': userId,
    });
    final response = await http.post(uri);

    return _handleResponse(response);
  }

  Future<List<dynamic>> fetchExpense({
    required String userId,
  }) async {
    final Uri uri = Uri.parse(baseUrl).replace(queryParameters: {
      'action': 'getExpense',
      'userId': userId,
    });
    final response = await http.post(uri);
    return _handleResponse(response);
  }

  Future<List<dynamic>> fetchUsers() async {
    final response =
        await http.get(Uri.parse('$baseUrl?action=$getUsersAction'));
    return _handleResponse(response);
  }

  Future<List<dynamic>> fetchProducts() async {
    final response =
        await http.get(Uri.parse('$baseUrl?action=$getProductsAction'));
    return _handleResponse(response);
  }

  Future<List<dynamic>> fetchServices() async {
    final response =
        await http.get(Uri.parse('$baseUrl?action=$getServicesAction'));
    return _handleResponse(response);
  }

  Future<List<dynamic>> fetchDashboard() async {
    final response =
        await http.get(Uri.parse('$baseUrl?action=$getDashboardAction'));
    return _handleResponse(response);
  }

  Future<List<dynamic>> fetchExpenseTypes() async {
    final response =
        await http.get(Uri.parse('$baseUrl?action=$getExpenseTypesAction'));
    return _handleResponse(response);
  }

  Future<List<dynamic>> fetchIncomeTypes() async {
    final response =
        await http.get(Uri.parse('$baseUrl?action=$getIncomeTypesAction'));
    return _handleResponse(response);
  }

  Future<void> signOutUser() async {
    final response = await http.post(
      Uri.parse('$baseUrl?action=$logoutUserAction'),
    );

    _handleResponse(response);
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
                      item['pqId']?.toString() ?? 'Unknown', // Default value
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

// ADD INCOME [START]
  Future<void> addIncome({
    required String action,
    required String dateTime,
    required String transactionId,
    required String productsName,
    required String qtyProducts,
    required int revenue,
    required String userId,
    required String incomeId,
  }) async {
    final String dateTime = DateTime.now().toIso8601String();

    // Convert int to String
    final Uri uri = Uri.parse(baseUrl).replace(queryParameters: {
      'action': action,
      'dateTime': dateTime,
      'transactionsId': transactionId,
      'productsName': productsName,
      'qtyProducts': qtyProducts,
      'revenue': revenue.toString(),
      'userId': userId,
      'incomeId': incomeId,
    });

    final response = await http.post(uri);

    if (response.statusCode == 200) {
      print('Income added sucessfully');
      print('Response body: ${response.body}');
    } else {
      print('Failed add income. Status code: ${response.statusCode}');
    }
  }
// ADD INCOME [END]

// ADD INCOME TYPE [START]
  Future<void> addIncomeType({
    String action = addIncomeTypeAction,
    required String incomeTypeName,
    required String userId,
  }) async {
    // Convert int to String
    final Uri uri = Uri.parse(baseUrl).replace(queryParameters: {
      'action': action,
      'incomeTypeName': incomeTypeName,
      'userId': userId,
    });

    final response = await http.post(uri);

    if (response.statusCode == 200) {
      print('Income type added successfully');
      print('Response body: ${response.body}');
    } else {
      print('Failed add income. Status code: ${response.statusCode}');
    }
  }
// ADD INCOME [END]

// ADD EXPENSE [START]
  Future<void> addExpense({
    required String action,
    required String dateTime,
    required String transactionId,
    required String expenseName,
    required String qtyProducts,
    required int expenseAmounts,
    required String userId,
    required String expenseId,
  }) async {
    final String dateTime = DateTime.now().toIso8601String();

    // Convert int to String
    final Uri uri = Uri.parse(baseUrl).replace(queryParameters: {
      'action': action,
      'dateTime': dateTime,
      'transactionsId': transactionId,
      'expenseName': expenseName,
      'qtyProducts': qtyProducts,
      'expenseAmounts': expenseAmounts.toString(),
      'userId': userId,
      'expenseId': expenseId,
    });

    final response = await http.post(uri);

    if (response.statusCode == 200) {
      print('Expense added successfully');
      print('Response body: ${response.body}');
    } else {
      print('Failed add expense. Status code: ${response.statusCode}');
    }
  }
// ADD EXPENSE [END]

  Future<List<dynamic>> getExpenseType() async {
    final Uri uri = Uri.parse(baseUrl).replace(queryParameters: {
      'action': 'getExpenseType',
    });
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return data['data'];
    } else {
      throw Exception('Failed to fetch expense types');
    }
  }

  Future<List<dynamic>> getIncomeType() async {
    final Uri uri = Uri.parse(baseUrl).replace(queryParameters: {
      'action': 'getIncomeType',
    });
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return data['data'];
    } else {
      throw Exception('Failed to fetch income types');
    }
  }

// UPDATE EXPENSE AMOUNT [START]
  Future<Map<String, dynamic>> updateExpenseAmount(
      String expenseId, int newAmount) async {
    return await _postRequest(
      updateExpenseAmountAction,
      {
        'expenseId': expenseId,
        'newAmount': newAmount.toString(),
      },
    );
  }
// UPDATE EXPENSE AMOUNT [END]

// UPDATE INCOME QUANTITY [START]
  Future<Map<String, dynamic>> updateIncomeQuantity(
      String productId, int quantity) async {
    return await _postRequest(
      updateIncomeQuantityAction,
      {
        'productId': productId,
        'quantity': quantity.toString(),
      },
    );
  }
// UPDATE INCOME QUANTITY [END]

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

// EXPENSE RESPONSE HANDLER [END]
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

  Future<Map<String, dynamic>> generateReport({
    required String userId,
    required String startDate,
    required String endDate,
    required bool includeIncome,
    required bool includeExpense,
    required String format, // 'CSV' or 'Excel'
  }) async {
    final Uri uri = Uri.parse(baseUrl).replace(queryParameters: {
      'action': 'generateReport',
      'userId': userId,
      'startDate': startDate,
      'endDate': endDate,
      'includeIncome': includeIncome.toString(),
      'includeExpense': includeExpense.toString(),
      'format': format,
    });

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      try {
        final data = jsonDecode(response.body);

        if (data['status'] == 'SUCCESS') {
          if (format == 'CSV') {
            // For CSV, return the CSV data as a string
            return {'status': 'SUCCESS', 'csvData': data['csvData']};
          } else if (format == 'Excel') {
            // For Excel, return the URL of the generated Excel file
            return {'status': 'SUCCESS', 'fileUrl': data['fileUrl']};
          } else {
            throw Exception('Unsupported format: $format');
          }
        } else {
          throw Exception('Error generating report: ${data['msg']}');
        }
      } catch (e) {
        throw Exception('Error decoding response: $e');
      }
    } else {
      throw Exception(
          'Failed to generate report. Status code: ${response.statusCode}');
    }
  }


//API Filtter
  /// Filter transactions based on period (weekly/monthly) and userId
  Future<Map<String, dynamic>> filterTransactions({
    required String userId,
    required String period, // "weekly" or "monthly"
  }) async {
    final Uri uri = Uri.parse(baseUrl).replace(queryParameters: {
      'action': filterTransactionsAction,
      'userId': userId,
      'period': period,
    });

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      try {
        final data = jsonDecode(response.body);
        if (data['status'] == 'SUCCESS') {
          return data['data']; // Return the filtered transaction data
        } else {
          throw Exception(data['msg'] ?? 'Unknown error occurred.');
        }
      } catch (e) {
        throw Exception('Error decoding response: $e');
      }
    } else {
      throw Exception(
          'Failed to filter transactions. Status code: ${response.statusCode}.');
    }
  }
}
