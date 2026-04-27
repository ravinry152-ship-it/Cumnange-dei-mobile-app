// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ImageToJson extends StatelessWidget {
  const ImageToJson({super.key});

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
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // កន្លែងសម្រាប់ចុច Upload
            GestureDetector(
              onTap: () {
                print("ប៊ូតុងត្រូវបានចុច");
              },
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
                child: Column(
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
            
            const SizedBox(height: 30),
            
            // ប៊ូតុង Submit សម្រាប់ចាប់ផ្តើម Process
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.auto_awesome, color: Colors.white),
                label: Text(
                  "ចាប់ផ្តើមបំប្លែងទិន្នន័យ",
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
          ],
        ),
      ),
    );
  }
}