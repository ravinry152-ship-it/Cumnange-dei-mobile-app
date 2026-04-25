import 'dart:convert';
import 'package:cumnange_dei/controller/API/api_service.dart';
import 'package:cumnange_dei/model/system_list_model/system_list_model.dart';
import 'package:get/get.dart';


class SystemListController  extends GetxController{
   var learningList = <SystemListModel>[].obs;
  var isLoading = true.obs;
//onInit() ដេីម្បីពេលUserចូលទៅScrenn វានឹងបង្ហាញdataភ្លាមដោយមិនចាំបាច់Refresh ដោយដៃ
  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      isLoading(true); // Start loading
      final response = await ApiService.get("api/setup-system/");
      
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
            
        learningList.assignAll(
          data.map((json) => SystemListModel.fromJson(json)).toList()
        );
      } else {
        Get.snackbar("Error", "Server error: ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("Connection Error", "សូមពិនិត្យមើលអ៊ីនធឺណិតរបស់អ្នក");
    } finally {
      // 4. Stop loading regardless of success or failure
      isLoading(false);
    }
  }

  // 5. Add a refresh method for pull-to-refresh UI
  Future<void> refreshData() async {
    await fetchProducts();
  }
}