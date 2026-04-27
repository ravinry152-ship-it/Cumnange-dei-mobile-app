import 'package:cumnange_dei/views/Auth/Welcom.dart';
import 'package:cumnange_dei/views/Create_system/system_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init(); 
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    String? token = box.read('access_token');

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: (token != null && token.isNotEmpty) 
          ? SystemList() 
          : WelcomeScreen(),
    );
  }
}