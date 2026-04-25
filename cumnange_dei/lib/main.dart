import 'package:cumnange_dei/views/Auth/Welcom.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
void main(){
  runApp(MyAPP());
}

class MyAPP extends StatelessWidget {
  const MyAPP({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: WelcomeScreen(),
    );
    
  }
}