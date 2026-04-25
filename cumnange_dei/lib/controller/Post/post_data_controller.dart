import 'package:cumnange_dei/controller/API/api_service.dart';
import 'package:cumnange_dei/controller/Post/user_data_controller.dart';
import 'package:cumnange_dei/model/Post_data/post_data_model.dart';
import 'package:cumnange_dei/views/Crud/user_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class PostuserDataController extends GetxController {
  // ── TextEditingControllers ──────────────────────────────
  final controllername    = TextEditingController();
  final controllerprice   = TextEditingController();
  final controllervillage = TextEditingController();
 int? id;
  // ── State ───────────────────────────────────────────────
  var isLoading = false.obs;
  void setInitialData(dynamic user) {
    id = user.id; 
    controllername.text = user.name ?? '';
    controllervillage.text = user.village ?? '';
    controllerprice.text = user.price.toString();
  }
  void resetFields() {
    id = null; 
    controllername.clear();
    controllerprice.clear();
    controllervillage.clear();
  }
  // ── Submit ──────────────────────────────────────────────
  Future<void> submitData() async {
    // 1. Validation
    if (!_isValid()) return;

    try {
      isLoading.value = true;

      // 2. Build model
      final postData = PostDataModel(
        name:    controllername.text.trim(),
        price:   double.tryParse(controllerprice.text.trim()) ?? 0.0, 
        village: controllervillage.text.trim(),
      );

      final response = await ApiService.post(
        "api/userdata/",
        postData.toJson(),
      );

      // 4. Handle response
      _handleResponse(response);

    } catch (e) {
      Get.snackbar(
        "Error",
        "មានបញ្ហាអ្វីមួយ: $e",
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
    } finally {
      isLoading.value = false;
    }
  }

  //=======================updatate data=============================
  Future<void> updateData() async {
  if (id == null) {
    Get.snackbar("Error", "រកមិនឃើញ ID សម្រាប់ Update ទេ");
    return;
  }

  if (!_isValid()) return;

  try {
    isLoading.value = true;

    final updatedData = PostDataModel(
      name:    controllername.text.trim(),
      price:   double.tryParse(controllerprice.text.trim()) ?? 0.0,
      village: controllervillage.text.trim(),
    );

    final response = await ApiService.put(
      endpoint: "api/detail_userdata/$id/",
      data: updatedData.toJson(),
    );

    print("Status: ${response.statusCode}");
    print("Body: ${response.body}");

    _handleResponse(response);

  } catch (e) {
    Get.snackbar(
      "Error",
      "Update បរាជ័យ: $e",
      backgroundColor: Colors.red[100],
      colorText: Colors.red[900],
    );
  } finally {
    isLoading.value = false;
  }
}


  // ── Private Helpers ─────────────────────────────────────
  bool _isValid() {
    if (controllername.text.trim().isEmpty) {
      Get.snackbar("មានបញ្ហា", "សូមបញ្ចូលឈ្មោះ");
      return false;
    }
    if (controllerprice.text.trim().isEmpty) {
      Get.snackbar("មានបញ្ហា", "សូមបញ្ចូលតម្លៃ");
      return false;
    }
    if (double.tryParse(controllerprice.text.trim()) == null) {
      Get.snackbar("មានបញ្ហា", "តម្លៃត្រូវតែជាលេខ");
      return false;
    }
    if (controllervillage.text.trim().isEmpty) {
      Get.snackbar("មានបញ្ហា", "សូមបញ្ចូលភូមិ");
      return false;
    }
    return true;
  }

  void _handleResponse(response) {
  if (response.statusCode == 200 || 
      response.statusCode == 201 || 
      response.statusCode == 204) {
    _clearFields();
    Get.snackbar(
      '',
      '',
      backgroundColor: const Color.fromARGB(255, 92, 169, 96),
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 3),
      titleText: Text(
        'ជោគជ័យ',
        style: GoogleFonts.kantumruyPro(
            color: Colors.white, fontWeight: FontWeight.bold),
      ),
      messageText: Text(
        'បានរក្សាទុកទិន្និន័យ',
        style: GoogleFonts.kantumruyPro(color: Colors.white),
      ),
    );
    Get.to(UserData());
    Get.find<UserDataController>().refreshData();
  } else {
    Get.snackbar(
      "Error",
      "ការបញ្ជូនបរាជ័យ: ${response.statusCode}\n${response.body}",
      backgroundColor: Colors.red[100],
      colorText: Colors.red[900],
    );
  }
}
  void _clearFields() {
    controllername.clear();
    controllerprice.clear();
    controllervillage.clear();
  }

  // ── Dispose ─────────────────────────────────────────────
  @override
  void onClose() {
    controllername.dispose();
    controllerprice.dispose();
    controllervillage.dispose();
    super.onClose();
  }
}