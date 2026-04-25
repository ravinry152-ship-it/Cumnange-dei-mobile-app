import 'package:cumnange_dei/controller/API/api_service.dart';
import 'package:cumnange_dei/controller/system_List/system_list_controller.dart';
import 'package:cumnange_dei/model/system_list_model/system_list_model.dart';
import 'package:cumnange_dei/views/Create_system/system_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class SetupSystemController extends GetxController {
  final controllername = TextEditingController();
  final controlleruser = TextEditingController(); 
  
  var isLoading = false.obs;

  Future<void> submitData() async {
    // 1. Basic Validation
    if (controllername.text.isEmpty || controlleruser.text.isEmpty) {
      Get.snackbar("Error", "សូមបំពេញព័ត៌មានឱ្យបានគ្រប់គ្រាន់");
      return;
    }

    try {
      isLoading.value = true;
      final systemData = SystemListModel(
        user: controlleruser.text.trim(),
        name: controllername.text.trim(),
      );

      final response = await ApiService.post(
        "api/setup-system/", 
        systemData.toJson(),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        Get.to(SystemList()); // Go back to the previous screen
        Get.snackbar("ជោគជ័យ", "ទិន្នន័យត្រូវបានរក្សាទុក");
        if (Get.isRegistered<SystemListController>()) {
          Get.find<SystemListController>().fetchProducts();
        }
      } else {
        Get.snackbar("Error", "ការបញ្ជូនបរាជ័យ: ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("Error", "មានបញ្ហាអ្វីមួយ: $e");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    controllername.dispose();
    controlleruser.dispose();
    super.onClose();
  }
}