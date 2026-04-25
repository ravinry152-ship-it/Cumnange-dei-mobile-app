// ignore: file_names
import 'package:cumnange_dei/controller/Auth_controller/signup_controller.dart';
import 'package:cumnange_dei/views/Auth/Login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
class Signup extends StatefulWidget {
  Signup({super.key});
  final SignupController signup = Get.put(SignupController());
  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  bool isHidden = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors:[
                  Color(0xFFFF8A8A),
                  Color(0xFFFFB6B6),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight
                   )
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: EdgeInsets.all(25),
                height: MediaQuery.of(context).size.height*0.75,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(40)
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          "បង្កេីតគណនី",
                          style: GoogleFonts.kantumruyPro(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    //=============user_name==========
                       const SizedBox(height: 30),
                    buildInput("Username", "បញ្ចូលឈ្មោះ", 
                    Icons.person,
                     widget.signup.controllerUsername
                    ),
                    //==========Email=================
                    const SizedBox(height: 20),
                    buildInput("Email", "បញ្ចូលអុីម៉ែល", 
                    Icons.email,
                    widget.signup.controllerEmail
                    ),
                   //=============password============
                    const SizedBox(height: 20),
                    buildPassword(),
                    const SizedBox(height: 30),

                    buildButton(),
                    SizedBox(height: 20,),
                     Center(
                      child: GestureDetector(
                        onTap: () {
                          Get.to(Login());
                        },
                        child: Text(
                          " have an account? Login",
                          style: GoogleFonts.poppins(
                            color: const Color.fromARGB(255, 15, 32, 187),
                            fontSize: 14,
                          ),
                        ),
                      ),
                     )

                    ],
                  ),
                ),
              ),
            )
          ],
        ),
    );
  }
  Widget buildInput(String title, String hint, IconData icon, TextEditingController  controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: GoogleFonts.kantumruyPro()),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.kantumruyPro(
              fontWeight: FontWeight.bold
            ),
            prefixIcon: Icon(icon),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
      ],
    );
  }

  // Password Field
  Widget buildPassword() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Password", style: GoogleFonts.poppins()),
        const SizedBox(height: 8),
        TextField(
          controller: widget.signup.controllerPassword,
          obscureText: isHidden,
          decoration: InputDecoration(
            hintText: "បញ្ចូលពាក្យសម្ងាត់",
            hintStyle: GoogleFonts.kantumruyPro(
              fontWeight: FontWeight.bold
            ),
            prefixIcon: const Icon(Icons.lock),
            suffixIcon: IconButton(
              icon: Icon(isHidden
                  ? Icons.visibility_off
                  : Icons.visibility),
              onPressed: () {
                setState(() {
                  isHidden = !isHidden;
                });
              },
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
      ],
    );
  }

  //  Button
  Widget buildButton() {
    return SizedBox(
      width: double.infinity,
     child: Obx(() => ElevatedButton(
      // ប្រើ widget.signup ដើម្បីហៅ controller ពី class ខាងលើ
      onPressed: widget.signup.isLoading.value 
        ? null 
        : () => widget.signup.signup(), 
      
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFF8A8A),
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: widget.signup.isLoading.value
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
          : Text(
              "ចុះឈ្មោះគណនី",
              style: GoogleFonts.kantumruyPro(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
    )),
    );
  }
}
