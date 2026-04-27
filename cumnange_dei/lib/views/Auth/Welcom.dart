import 'package:cumnange_dei/views/Auth/Login.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Gradient Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFFF8A8A),
                  Color(0xFFFFB6B6),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          //  Illustration (Top)
          Positioned(
            top: 80,
            left: 0,
            right: 0,
            child: Image.asset(
              "assets/image/welcome.png",
              height: 200,
            ),
          ),

          //  Bottom Card
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.all(30),
              height: MediaQuery.of(context).size.height * 0.45,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(40),
                ),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    "សូមស្វាគមន៏ ",
                    style: GoogleFonts.kantumruyPro(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Subtitle
                  Text(
                    "កម្មវិធីកត់ចំណងដៃឆ្លាតវៃ និងងាយស្រួលដេីម្បីគ្រប់គ្រងទិន្និន័យ",
                    style: GoogleFonts.kantumruyPro(
                      fontSize: 20,
                      color: Colors.grey[600],
                      height: 1.5,
                    ),
                  ),

                  const Spacer(),

                  //  Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.to(Login());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF8A8A),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 5,
                      ),
                      child: Text(
                        "បន្ទាប់",
                        style: GoogleFonts.kantumruyPro(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Optional Login
                  Center(
                    child: Text(
                      "សូមធ្វេីការចុចបូតុងបន្ទាប់ដេីម្បីចុះឈ្មោះ​ឬចូលគណនី",
                      style: GoogleFonts.kantumruyPro(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}