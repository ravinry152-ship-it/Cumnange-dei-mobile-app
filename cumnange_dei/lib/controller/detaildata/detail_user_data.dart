import 'package:cumnange_dei/controller/API/api_service.dart';
import 'package:cumnange_dei/controller/Post/user_data_controller.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class DetailUserData  extends GetxController {
  final controllername    = TextEditingController();
  final controllerprice   = TextEditingController();
  final controllervillage = TextEditingController();
  var isLoading = false.obs;
  int? id;  
 final UserDataController listController = Get.find<UserDataController>();

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
  
  //======================detlete data===================
  Future<void> deleteData(int id) async {
    try {
      isLoading.value = true;
      final response = await ApiService.delete(endpoint: 'api/detail_userdata/$id/');

      if (response.statusCode == 200 || response.statusCode == 204) {
        // លុបចេញពី List ក្នុង UserDataController ភ្លាមៗដើម្បីឱ្យ UI ប្តូរតាម
        listController.userdata.removeWhere((user) => user.id == id);
        listController.userdata.refresh(); // ប្រាប់ Obx ឱ្យដឹងថា List ដូរហើយ
        listController.filteredUserdata.refresh();
        Get.snackbar("ជោគជ័យ", "បានលុបទិន្នន័យរួចរាល់", 
          backgroundColor: Colors.green[100], colorText: Colors.green[900]);
      }
    } catch (e) {
      Get.snackbar("កំហុស", "មិនអាចលុបបាន: $e", backgroundColor: Colors.red[100]);
    } finally {
      isLoading.value = false;
    }
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