import 'dart:convert';
import 'package:cumnange_dei/controller/API/api_service.dart';
import 'package:cumnange_dei/model/Post_data/post_data_model.dart';
import 'package:get/get.dart';

class UserDataController extends GetxController {
  //  បញ្ជីទិន្នន័យដើមពី API
  var userdata = <PostDataModel>[].obs;
  
  // បញ្ជីសម្រាប់បង្ហាញលើ UI (លទ្ធផល Search)
  var filteredUserdata = <PostDataModel>[].obs;
  
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchdata();
  }

  Future<void> fetchdata() async {
    try {
      isLoading(true);
      final response = await ApiService.get("api/userdata/"); 

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        
        // រក្សាទុកទិន្នន័យដើម
        var fetchedData = data.map((json) => PostDataModel.fromJson(json)).toList();
        userdata.assignAll(fetchedData);
        
        // កំណត់ឱ្យ Filtered list បង្ហាញទិន្នន័យទាំងអស់នៅពេលដំបូង
        filteredUserdata.assignAll(fetchedData);
      } else {
        Get.snackbar("Error", "Server error: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching data: $e");
      Get.snackbar("Connection Error", "សូមពិនិត្យមើលអ៊ីនធឺណិតរបស់អ្នក");
    } finally {
      isLoading(false);
    }
  }

  // មុខងារស្វែងរកឈ្មោះ និង ភូមិ
  void searchUser(String query) {
    if (query.isEmpty) {
      // បើគ្មានការវាយអក្សរ បង្ហាញទិន្នន័យទាំងអស់វិញ
      filteredUserdata.assignAll(userdata);
    } else {
      // ចម្រាញ់ទិន្នន័យតាម ឈ្មោះ ឬ ភូមិ
      var results = userdata.where((user) {
        final name = (user.name ?? '').toLowerCase();
        final village = (user.village ?? '').toLowerCase();
        final searchInput = query.toLowerCase();
        
        return name.contains(searchInput) || village.contains(searchInput);
      }).toList();

      filteredUserdata.assignAll(results);
    }
  }

  Future<void> refreshData() async {
    await fetchdata();
  }
}