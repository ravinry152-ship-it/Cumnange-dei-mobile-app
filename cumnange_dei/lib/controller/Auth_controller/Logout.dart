import 'package:cumnange_dei/views/Auth/Login.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class Logout extends GetxController{
  //===============Logout====================
  static Future<void> logout() async {
  final box = GetStorage();
  box.remove('access_token');
  box.remove('refresh_token');
  box.remove('user_data'); // បើមានរក្សាទុកព័ត៌មាន User
  await box.erase();
  Get.offAll(Login()); // ឬ WelcomeScreen 
}
}