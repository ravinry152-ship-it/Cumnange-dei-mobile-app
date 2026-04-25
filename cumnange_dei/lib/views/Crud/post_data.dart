import 'package:cumnange_dei/controller/Post/post_data_controller.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

class PostData extends StatelessWidget {
  PostData({super.key});

  final PostuserDataController controller = Get.find<PostuserDataController>();
  final Color primaryColor = Colors.deepOrange;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          "បញ្ចូលទិន្នន័យភ្ញៀវ",
          style: GoogleFonts.kantumruyPro(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: primaryColor,
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader("ព័ត៌មានទូទៅ"),
                      const SizedBox(height: 20),

                      buildInput(
                        controller.controllername,
                        "ឈ្មោះភ្ញៀវ", "បញ្ចូលឈ្មោះភ្ញៀវ",
                        Icons.person,
                      ),
                      const SizedBox(height: 15),

                      buildInput(
                        controller.controllervillage,
                        "អាសយដ្ឋាន", "បញ្ចូលឈ្មោះភូមិ",
                        Icons.home,
                      ),
                      const SizedBox(height: 15),

                      buildInput(
                        controller.controllerprice,
                        "ទឹកប្រាក់", "បញ្ចូលចំនួនទឹកប្រាក់",
                        Icons.price_change,
                        isNumber: true,
                      ),

                      const SizedBox(height: 30),

                      SizedBox(
                        width: double.infinity,
                        child: Obx(() => ElevatedButton.icon(
                          onPressed:(){
                          if (controller.isLoading.value) return;
                          if (controller.id != null) {
                           controller.updateData();
                         } else {
                           controller.submitData();
                         }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          icon: controller.isLoading.value
                              ? const SizedBox(
                                  width: 20, height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white, strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.save, color: Colors.white),
                          label: Text(
                            controller.isLoading.value
                                ? "កំពុងរក្សាទុក..."
                                : "រក្សាទុកទិន្នន័យ",
                            style: GoogleFonts.kantumruyPro(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        )),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.kantumruyPro(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.grey[700],
      ),
    );
  }

  Widget buildInput(
    TextEditingController post,
    String label,
    String hint,
    IconData icon, {
    bool isNumber = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.kantumruyPro(fontSize: 14, color: Colors.black87),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: post,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.kantumruyPro(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.grey,
            ),
            prefixIcon: Icon(icon, color: Colors.deepOrange),
            filled: true,
            fillColor: Colors.grey[50],
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: Colors.deepOrange, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}