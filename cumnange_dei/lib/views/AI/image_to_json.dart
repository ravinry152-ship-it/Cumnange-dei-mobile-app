// ignore_for_file: deprecated_member_use

import 'package:cumnange_dei/controller/AI_controller/ai_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ImageToJson extends StatelessWidget {
  ImageToJson({super.key});
  final ai = Get.put(AiController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "មុខងារបញ្ចូលទិន្នន័យស្វ័យប្រវត្ត",
          style: GoogleFonts.kantumruyPro(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.deepOrange,
        centerTitle: true,
      ),
      body: Obx(
        () => SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // កន្លែងសម្រាប់ចុច Upload
              GestureDetector(
                onTap: ai.pickImageFromGallery,
                child: Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.deepOrange.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: Colors.deepOrange.withOpacity(0.5),
                      style: BorderStyle.solid,
                      width: 2,
                    ),
                  ),
                  child: ai.selectedImageBytes.value != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(13),
                          child: Image.memory(
                            ai.selectedImageBytes.value!,
                            width: double.infinity,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.cloud_upload_outlined,
                              size: 60,
                              color: Colors.deepOrange,
                            ),
                            const SizedBox(height: 15),
                            Text(
                              "ចុចទីនេះដើម្បីបញ្ចូលរូបភាព",
                              style: GoogleFonts.kantumruyPro(
                                fontSize: 16,
                                color: Colors.deepOrange,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              "គាំទ្រ File PNG, JPG ឬ JPEG",
                              style: GoogleFonts.kantumruyPro(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                ),
              ),

              if (ai.selectedImageName.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  ai.selectedImageName.value,
                  style: GoogleFonts.kantumruyPro(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                TextButton(
                  onPressed: ai.clearImage,
                  child: Text(
                    "ដករូបភាពចេញ",
                    style: GoogleFonts.kantumruyPro(
                      fontSize: 14,
                      color: Colors.deepOrange,
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 30),

              // ប៊ូតុង Submit សម្រាប់ចាប់ផ្តើម Process
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton.icon(
                  onPressed:
                      ai.isLoading.value ? null : ai.convertImageToJson,
                  icon: ai.isLoading.value
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.auto_awesome, color: Colors.white),
                  label: Text(
                    ai.isLoading.value
                        ? "កំពុងដំណើរការ..."
                        : "ចាប់ផ្តើមបំប្លែងទិន្នន័យ",
                    style: GoogleFonts.kantumruyPro(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                ),
              ),

              if (ai.resultText.isNotEmpty) ...[
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.deepOrange.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.deepOrange.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: SelectableText(
                    ai.resultText.value,
                    style: GoogleFonts.kantumruyPro(
                      fontSize: 14,
                      color: Colors.black87,
                      height: 1.6,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
