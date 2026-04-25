import 'package:cumnange_dei/controller/system_List/setup_system_controller.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
class CreateSystem extends StatelessWidget {
  const CreateSystem({super.key});
  final Color primaryColor = Colors.deepOrange;
  @override
  Widget build(BuildContext context) {
  final SetupSystemController controller = Get.put(SetupSystemController());

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          "បង្កេីតប្រព័ន្ធគ្រប់គ្រងភ្ញៀវ",
          style: GoogleFonts.kantumruyPro(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold
          ),
        ) ,
        backgroundColor:primaryColor ,
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(20),
                ),
                child: Padding(
                  padding:EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       _buildHeader("បញ្ចូលព័ត៏មានដេីម្បីបង្កេីតប្រព័ន្ធគ្រប់គ្រង"),
                      const SizedBox(height: 20),
                      
                      buildInput(
                        controller.controlleruser,
                        "ឈ្មោះអ្នកប្រេីប្រាស់", "បញ្ចូលឈ្មោះ", 
                      Icons.person,
                      ),
                      const SizedBox(height: 15),
                      
                      buildInput(
                        controller.controllername,
                        "ឈ្មោះប្រព័ន្ធគ្រប់គ្រង", 
                      "បញ្ចូលឈ្មោះប្រព័ន្ធគ្រប់គ្រង",
                       Icons.book
                       ),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed:(){
                            controller.submitData();
                           
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ), 
                          label: Text(
                            "រក្សាទុក",
                            style: GoogleFonts.kantumruyPro(
                               fontSize: 18,
                               fontWeight: FontWeight.bold,
                               color: Colors.white
                            ),
                          )
                          ),
                      )
                    ],
                  ),
                   ),
              )
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
  Widget buildInput( TextEditingController con, String label, String hint, IconData icon, {bool isNumber = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.kantumruyPro(fontSize: 14, color: Colors.black87),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: con,
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