// ignore_for_file: deprecated_member_use
import 'package:cumnange_dei/controller/system_List/system_list_controller.dart';
import 'package:cumnange_dei/views/AI/image_to_json.dart';
import 'package:cumnange_dei/views/Auth/Login.dart';
import 'package:cumnange_dei/views/Crud/user_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SystemList extends StatelessWidget {
   SystemList({super.key});
  final SystemListController controller = Get.put(SystemListController());
  final Color primaryColor = Colors.deepOrange;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Colors.grey[100] ,
      appBar: AppBar(
        title: Text(
          "បញ្ជីប្រព័ន្ធគ្រប់គ្រងភ្ញៀវ",
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
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            SizedBox(height: 10,),
            Card(
              child: Material(
                borderRadius: BorderRadius.circular(10),
                elevation: 4,
                child: ListTile( shape: RoundedRectangleBorder(
               borderRadius: BorderRadius.circular(20),
            
          ),
          tileColor: Colors.white,
           leading: CircleAvatar(
            backgroundColor: Colors.deepOrange.withOpacity(0.1),
            child: Icon(Icons.settings),
          ),
          title: Text(
            "ចាកចេញពីគណនី",
            style: GoogleFonts.kantumruyPro(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            ),
            onTap: (){
              Get.defaultDialog(
                title: "ចាកចេញពីគណនី",
               titleStyle: GoogleFonts.kantumruyPro(
              fontWeight: FontWeight.bold
           ),
            middleText: "តើអ្នកពិតជាចង់ចាកចេញពីគណនីមែនទេ?",
            middleTextStyle: GoogleFonts.kantumruyPro(fontWeight: FontWeight.bold),
            confirm: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black12
              ),
              onPressed: (){
                Get.to(Login());
              },
                child: Text(
                  "ចាកចេញ",
                  style: GoogleFonts.kantumruyPro(
                    fontWeight: FontWeight.bold,
                    color: Colors.red
                  ),

                ) 
              ),
              cancel: ElevatedButton(
                onPressed:() {
                  Get.back();
                }, 
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black12 
                ),
                child:Text(
                  "បោះបង់",
                  style: GoogleFonts.kantumruyPro(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                    )
                    
                 ),
              ),
              );
            },
          ),
              ),
            ),
            SizedBox(height: 10,),
            Card(
              child: Material(
                borderRadius: BorderRadius.circular(10),
                elevation: 4,
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  tileColor: Colors.white,
            leading: CircleAvatar(
            backgroundColor: Colors.deepOrange.withOpacity(0.1),
            child: Icon(Icons.person),
          ),
          title: Text(
            "ជំនួយការពិសេស",
            style: GoogleFonts.kantumruyPro(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            ),
            onTap: (){
              Get.to(ImageToJson());
            },
                ),
              ),
            ),
            SizedBox(height: 10,),
            Expanded(
              child: Obx((){
                if(controller.isLoading.value){
                  return Center(child: CircularProgressIndicator(),);
                }
                if (controller.learningList.isEmpty) {
               return Center(
                 child: Text(
                 "មិនមានទិន្នន័យឡើយ",
                   style: GoogleFonts.kantumruyPro(),
                 ),
               );
             }
             return RefreshIndicator(
              onRefresh:controller.refreshData,
              child:ListView.builder(
                itemCount: controller.learningList.length,
                itemBuilder:(context,index ){
                  final item = controller.learningList[index];
                  return buildCard(
                   icon: Icons.book,
                  title: item.name, 
                 subtitle: "អ្នកប្រើប្រាស់: ${item.user}", 
               );
                }
                 ) , 
              );
              }),
              ),
              
          ],
        ),
        ),

    );
  }
  Widget buildCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: Material(
        borderRadius: BorderRadius.circular(20),
        elevation: 4,
        child: ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          tileColor: Colors.white,
          leading: CircleAvatar(
            backgroundColor: Colors.deepOrange.withOpacity(0.1),
            child: Icon(icon, color: Colors.deepOrange),
          ),
          title: Text(
            title,
            style: GoogleFonts.kantumruyPro(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: GoogleFonts.kantumruyPro(
              color: Colors.grey[600],
            ),
          ),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            Get.to(() => UserData());
          },
        ),
      ),
    );
  }
}