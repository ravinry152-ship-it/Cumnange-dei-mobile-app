import 'dart:convert';
import 'package:cumnange_dei/controller/API/api_service.dart';
import 'package:cumnange_dei/views/Create_system/system_list.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get_storage/get_storage.dart';

class LoginController extends GetxController {
  final controllerUsername = TextEditingController();
  final controllerEmail = TextEditingController();
  final controllerPassword = TextEditingController();
  
  var usernameDisplay = "".obs;
  var isLoading = false.obs;

  //=================== fetch api user login =========================
  Future<void> login() async {
    final username = controllerUsername.text.trim();
    final email = controllerEmail.text.trim();
    final password = controllerPassword.text.trim();

    // Validation
    if (username.isEmpty || password.isEmpty) {
      _showErrorDialog('សូមបញ្ចូលឈ្មោះអ្នកប្រើប្រាស់ និងលេខសម្ងាត់');
      return;
    }

    try {
      isLoading.value = true;

      Map<String, dynamic> loginData = {
        'username': username,
        'email': email,
        'password': password,
      };

      // 1. Send Login Request
      final response = await ApiService.post('api/login/', loginData);

      if (response.statusCode == 200) {
        final resBody = jsonDecode(response.body);
        final box = GetStorage();

        // 2. Check and Save Tokens
        if (resBody['access'] != null) {
          // Store tokens securely in local storage
          await box.write('access_token', resBody['access']);
          await box.write('refresh_token', resBody['refresh']);

          _showSuccessSnackbar();

          // 3. Navigate to next screen and clear navigation history
          Get.offAll(() => SystemList());
        } else {
          _showErrorDialog('មិនមាន Token ត្រឹមត្រូវពី Server ឡើយ');
        }
      } else {
        // 4. Handle Login Failure (Wrong password, etc.)
        final resBody = jsonDecode(response.body);
        String errorMessage = resBody['error'] ?? resBody['detail'] ?? 'ឈ្មោះអ្នកប្រើប្រាស់ ឬលេខសម្ងាត់មិនត្រឹមត្រូវ';
        _showErrorDialog(errorMessage);
      }
    } catch (e) {
      _showErrorDialog('មិនអាចតភ្ជាប់ទៅកាន់ Server បានទេ');
      debugPrint("Login Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  //=================== UI Components: Dialogs & Snackbars ==========================
  
  void _showErrorDialog(String message) {
    Get.defaultDialog(
      title: 'បញ្ហា!',
      titleStyle: GoogleFonts.kantumruyPro(
        color: Colors.red, 
        fontWeight: FontWeight.bold
      ),
      middleText: message,
      middleTextStyle: GoogleFonts.kantumruyPro(
        color: Colors.black,
        fontWeight: FontWeight.w500
      ),
      confirm: TextButton(
        onPressed: () => Get.back(),
        child: Text("យល់ព្រម", style: GoogleFonts.kantumruyPro()),
      ),
    );
  }

  void _showSuccessSnackbar() {
    Get.snackbar(
      'ចូលប្រើប្រាស់ជោគជ័យ',
      'សូមស្វាគមន៍មកកាន់ កម្មវិធីកត់ចំណងដៃឆ្លាតវៃ',
      backgroundColor: const Color.fromARGB(255, 92, 169, 96),
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 3),
      titleText: Text(
        'ចូលប្រើប្រាស់ជោគជ័យ',
        style: GoogleFonts.kantumruyPro(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      messageText: Text(
        'សូមស្វាគមន៍មកកាន់ កម្មវិធីកត់ចំណងដៃឆ្លាតវៃ',
        style: GoogleFonts.kantumruyPro(color: Colors.white),
      ),
    );
  }

  @override
  void onClose() {
    controllerUsername.dispose();
    controllerEmail.dispose();
    controllerPassword.dispose();
    super.onClose();
  }
}