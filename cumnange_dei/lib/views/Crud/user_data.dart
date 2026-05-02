// ignore_for_file: deprecated_member_use
import 'package:cumnange_dei/controller/Post/post_data_controller.dart';
import 'package:cumnange_dei/controller/Post/user_data_controller.dart';
import 'package:cumnange_dei/controller/detaildata/detail_user_data.dart';
import 'package:cumnange_dei/views/Crud/post_data.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

class UserData extends StatefulWidget {
  const UserData({super.key});

  @override
  State<UserData> createState() => _UserDataState();
}

class _UserDataState extends State<UserData> {
  final TextEditingController _searchController = TextEditingController();
  final UserDataController controller = Get.put(UserDataController());
  final PostuserDataController postcontroller = Get.put(PostuserDataController());
  final DetailUserData c = Get.put(DetailUserData());

  double get _totalPrice {
    return controller.filteredUserdata.fold(0.0, (sum, item) {
      return sum + (double.tryParse(item.price.toString()) ?? 0.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: Colors.white,
        title: Container(
          height: 45,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextField(
            controller: _searchController,
            onChanged: (value) => controller.searchUser(value),
            decoration: InputDecoration(
              hintText: "ស្វែងរកឈ្មោះភ្ញៀវ...",
              hintStyle: GoogleFonts.kantumruyPro(fontSize: 15, color: Colors.grey),
              prefixIcon: const Icon(Icons.search, color: Colors.orange),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              postcontroller.resetFields();
              Get.to( PostData());
            },
            icon: const Icon(Icons.add_circle, color: Colors.orange, size: 30),
          ),
          const SizedBox(width: 5),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: Colors.orange));
        }

        if (controller.userdata.isEmpty) {
          return const Center(child: Text("មិនមានទិន្នន័យឡើយ"));
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "បញ្ជីឈ្មោះភ្ញៀវ",
                style: GoogleFonts.kantumruyPro(
                  color: Colors.orange,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => controller.refreshData(),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columnSpacing: 40,
                      headingRowColor: WidgetStateProperty.all(Colors.orange.withOpacity(0.1)),
                      columns: [
                        DataColumn(label: _headerText("លេខរៀង")),
                        DataColumn(label: _headerText("ឈ្មោះ")),
                        DataColumn(label: _headerText("ភូមិ")),
                        DataColumn(label: _headerText("ទឹកប្រាក់")),
                        DataColumn(label: _headerText("សកម្មភាពភ្ញៀវ")),
                      ],
                      rows: controller.filteredUserdata.asMap().entries.map((entry) {
                        int index = entry.key;
                        var user = entry.value;
                        return DataRow(cells: [
                          DataCell(Text((index + 1).toString(), style: GoogleFonts.kantumruyPro(fontWeight: FontWeight.bold))),
                          DataCell(Text(user.name ?? '', style: GoogleFonts.kantumruyPro(fontWeight: FontWeight.bold))),
                          DataCell(Text(user.village ?? '', style: GoogleFonts.kantumruyPro(fontWeight: FontWeight.bold))),
                          DataCell(Text(
                            "${user.price} ៛",
                            style: GoogleFonts.kantumruyPro(color: Colors.green, fontWeight: FontWeight.bold),
                          )),
                          DataCell(
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    postcontroller.setInitialData(user);
                                    Get.to( PostData());
                                  },
                                  icon: const Icon(Icons.edit, color: Colors.blue, size: 20),
                                ),
                                IconButton(
                                  onPressed: () => _deleteUser(user),
                                  icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                                ),
                              ],
                            ),
                          ),
                        ]);
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),
            
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Colors.grey[300]!, width: 0.5)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    offset: const Offset(0, -2),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: SafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "ទឹកប្រាក់សរុប:",
                      style: GoogleFonts.kantumruyPro(
                        fontSize: 16, 
                        fontWeight: FontWeight.bold,
                        color: Colors.black87
                      ),
                    ),
                    Text(
                      "${_totalPrice.toStringAsFixed(0)} ៛",
                      style: GoogleFonts.kantumruyPro(
                        fontSize: 20, 
                        color: Colors.orange[900], 
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  void _deleteUser(dynamic user) {
    Get.defaultDialog(
      title: "បញ្ជាក់ការលុប",
      titleStyle: GoogleFonts.kantumruyPro(fontWeight: FontWeight.bold),
      middleText: "តើអ្នកពិតជាចង់លុបទិន្នន័យរបស់ ${user.name} មែនទេ?",
      middleTextStyle: GoogleFonts.kantumruyPro(),
      textConfirm: "លុប",
      textCancel: "បោះបង់",
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () {
        Get.back();
        c.deleteData(user.id);
      },
    );
  }

  Widget _headerText(String label) {
    return Text(
      label,
      style: GoogleFonts.kantumruyPro(
        fontWeight: FontWeight.bold,
        color: Colors.orange[800],
      ),
    );
  }
}