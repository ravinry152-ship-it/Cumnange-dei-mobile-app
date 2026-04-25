import 'dart:convert';
import 'package:cumnange_dei/controller/API/api_service.dart';
import 'package:cumnange_dei/views/Create_system/Setup_system.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get_storage/get_storage.dart';
class SignupController extends GetxController {
 final controllerUsername = TextEditingController();
  final controllerEmail = TextEditingController(); 
  final controllerPassword = TextEditingController();
  var usernameDisplay = "".obs;
  var isLoading = false.obs;

  Future<void> signup() async {
    final username = controllerUsername.text.trim();
    final email = controllerEmail.text.trim();
    final password = controllerPassword.text.trim();
    usernameDisplay.value = username;

    if (username.isEmpty || password.isEmpty) {
      _showErrorDialog('សូមបញ្ចូលព័ត៌មានឱ្យបានត្រឹមត្រូវ');
      return;
    }

    isLoading.value = true;
    try {
      Map<String, dynamic> signupData = {
        'username': username,
        'email': email,
        'password': password,
      };

      final response = await ApiService.post('api/register/', signupData);
      
      if (response.statusCode == 201) {
        // ignore: unused_local_variable
        final resBody = jsonDecode(response.body);
        // ignore: unused_local_variable
        final box = GetStorage();
        if(resBody['access'] != null){
       await box.write('access_token', resBody['access']);
       await box.write('refresh_token', resBody['refresh']);
        _showSuccessSnackbar();
        
        Get.offAll(() => CreateSystem());
         }
      } else {
        // បើ Login ខុស (ឧទាហរណ៍ Password ខុស)
        final resBody = jsonDecode(response.body);
        _showErrorDialog(resBody['error'] ?? 'ការចូលប្រើប្រាស់បរាជ័យ');
      }
    } catch (e) {
      _showErrorDialog('មិនអាចតភ្ជាប់ទៅកាន់ Server បានទេ');
      debugPrint("Login Error: $e");
    } finally {
      isLoading.value = false; // បិទ Loading ទោះបីជោគជ័យ ឬបរាជ័យ
    }
  }
   void _showErrorDialog(String message) {
    Get.defaultDialog(
      title: 'បញ្ហា!',
      titleStyle: GoogleFonts.kantumruyPro(color: Colors.red, fontWeight: FontWeight.bold),
      middleText: message,
      middleTextStyle: GoogleFonts.kantumruyPro(
        color: Colors.black,
        fontWeight: FontWeight.bold
      ),
    );
  }

  void _showSuccessSnackbar() {
    Get.snackbar(
      '',
      '',
      backgroundColor: const Color.fromARGB(255, 92, 169, 96),
      colorText: Colors.white,
      titleText: Text('ចុះឈ្មោះជោគជ័យ', 
        style: GoogleFonts.kantumruyPro(color: Colors.white, fontWeight: FontWeight.bold)),
      messageText: Text('សូមស្វាគមន៍មកកាន់ កម្មវិធីកត់ចំណងដៃឆ្លាតវៃ', 
        style: GoogleFonts.kantumruyPro(color: Colors.white)),
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