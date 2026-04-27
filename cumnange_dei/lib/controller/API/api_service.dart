import 'dart:convert';
import 'package:cumnange_dei/views/Auth/Login.dart';
import 'package:cumnange_dei/views/Auth/Welcom.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
class ApiService {
  static const String baseUrl = 'https://cumnage-dei-api.onrender.com/';
//https://cumnage-dei-api.onrender.com/
//http://10.0.2.2:8000/
  // មុខងារសម្រាប់រៀបចំ Header
  static Future<Map<String, String>> _getHeaders({bool isLogin = false}) async {
    final box = GetStorage();
    String? token = box.read('access_token');
//======បានន័យថាត្រូវបោះមកជាjson និងទទួលdataជាjson==========
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    
    // បើផ្ញើ Authorization ទៅកាន់ Login វានឹងបណ្តាលឱ្យមានកំហុស 401 បើ Token នោះហួសសុពលភាព
    if (!isLogin && token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  // មុខងារ GET
  // មុខងារ GET ដែលមាន Auto Refresh Token
  static Future<http.Response> get(String endpoint) async {
    final url = Uri.parse('$baseUrl$endpoint');
    var response = await http.get(url, headers: await _getHeaders());

    // បើ Server តបមកថា 401 (Token ហួសកំណត់)
    if (response.statusCode == 401) {
      bool isRefreshed = await _refreshToken();
      if (isRefreshed) {
        // បើ Refresh ជោគជ័យ ហៅ API ម្តងទៀតជាមួយ Token ថ្មី
        response = await http.get(url, headers: await _getHeaders());
      }
    }
    return response;
  }

  // មុខងារ POST ដែលមាន Auto Refresh Token
  static Future<http.Response> post(String endpoint, Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl$endpoint');
    bool isLogin = endpoint.contains('login');

    var response = await http.post(
      url,
      headers: await _getHeaders(isLogin: isLogin), 
      body: jsonEncode(data),
    );

    // បើមិនមែនជាការ Login ហើយជាប់ 401
    if (!isLogin && response.statusCode == 401) {
      bool isRefreshed = await _refreshToken();
      if (isRefreshed) {
        response = await http.post(
          url,
          headers: await _getHeaders(isLogin: isLogin),
          body: jsonEncode(data),
        );
      }
    }
    return response;
  }

  // មុខងារសម្រាប់ Refresh Token
  static Future<bool> _refreshToken() async {
    try {
      final box = GetStorage();
      String? refreshToken = box.read('refresh_token');

      if (refreshToken == null || refreshToken.isEmpty) {
        return false;
      }

      final url = Uri.parse('${baseUrl}api/token/refresh/');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'refresh': refreshToken}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        box.write('access_token', data['access']);
        return true;
      } else {
        // បើ Refresh Token មិនមានសុពលភាព សូមលុប Token
        box.remove('access_token');
        box.remove('refresh_token');
        Get.offAll(Login());
        return false;
      }
    } catch (e) {
      return false;
    }
  }
  //========================put  and delete ==========================
  // --- មុខងារ PUT ធម្មតា (សម្រាប់ Update ទិន្នន័យជា JSON) ---
  static Future<http.Response> put({
    required String endpoint, 
    required Map<String, dynamic> data
  }) async {
    final url = Uri.parse('$baseUrl$endpoint');
    var response = await http.put(
      url,
      headers: await _getHeaders(),
      body: jsonEncode(data),
    );

    // ប្រសិនបើ Token ហួសកំណត់ (401)
    if (response.statusCode == 401) {
      bool isRefreshed = await _refreshToken();
      if (isRefreshed) {
        response = await http.put(
          url,
          headers: await _getHeaders(),
          body: jsonEncode(data),
        );
      }
    }
    return response;
  }
  // --- មុខងារ DELETE (សម្រាប់លុបទិន្នន័យ) ---
  static Future<http.Response> delete({required String endpoint}) async {
    final url = Uri.parse('$baseUrl$endpoint');
    var response = await http.delete(url, headers: await _getHeaders());

    // ប្រសិនបើ Token ហួសកំណត់ (401) ព្យាយាម Refresh និងហៅម្ដងទៀត
    if (response.statusCode == 401) {
      bool isRefreshed = await _refreshToken();
      if (isRefreshed) {
        response = await http.delete(url, headers: await _getHeaders());
      }
    }
    return response;
  }

  //===============Logout====================
  static Future<void> logout() async {
  final box = GetStorage();
  box.remove('access_token');
  box.remove('refresh_token');
  box.remove('user_data'); // បើមានរក្សាទុកព័ត៌មាន User
  Get.offAll(WelcomeScreen()); // ឬ WelcomeScreen 
}

}