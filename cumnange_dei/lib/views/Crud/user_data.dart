// ignore_for_file: deprecated_member_use
import 'package:cumnange_dei/controller/Post/post_data_controller.dart';
import 'package:cumnange_dei/controller/Post/user_data_controller.dart';
import 'package:cumnange_dei/controller/detaildata/detail_user_data.dart';
import 'package:cumnange_dei/util/responsive.dart';
import 'package:cumnange_dei/views/Crud/data_to_pdf.dart';
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

  int _currentPage = 0;
  final int _rowsPerPage = 10;

  double get _totalPrice {
    return controller.filteredUserdata.fold(0.0, (sum, item) {
      return sum + (double.tryParse(item.price.toString()) ?? 0.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = Responsive.isMobile(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: Colors.white,
        title: Container(
          height: 45,
          constraints: BoxConstraints(maxWidth: Responsive.isDesktop(context) ? 400 : double.infinity),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextField(
            controller: _searchController,
            onChanged: (value) {
              setState(() {
                _currentPage = 0;
              });
              controller.searchUser(value);
            },
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
              Get.to(PostData());
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

        final filteredList = controller.filteredUserdata;
        final totalItems = filteredList.length;
        final totalPages = (totalItems / _rowsPerPage).ceil();

        final startIndex = _currentPage * _rowsPerPage;
        final endIndex = (startIndex + _rowsPerPage < totalItems)
            ? startIndex + _rowsPerPage
            : totalItems;
        final currentPageData = filteredList.sublist(
          startIndex < totalItems ? startIndex : 0,
          endIndex < totalItems ? endIndex : totalItems,
        );

        // Responsive Body content
        Widget bodyContent = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "បញ្ជីឈ្មោះភ្ញៀវ (${totalItems})",
                    style: GoogleFonts.kantumruyPro(
                      color: Colors.orange,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    dataToPdf.exportPdf(
                      data: controller.filteredUserdata,
                      total: _totalPrice,
                    );
                  },
                  icon: const Icon(Icons.picture_as_pdf, color: Colors.red),
                ),
              ],
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => controller.refreshData(),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: MediaQuery.of(context).size.width - (isMobile ? 0 : 64),
                      ),
                      child: DataTable(
                        columnSpacing: isMobile ? 30 : 60,
                        headingRowColor: WidgetStateProperty.all(Colors.orange.withOpacity(0.1)),
                        columns: [
                          DataColumn(label: _headerText("លេខរៀង")),
                          DataColumn(label: _headerText("ឈ្មោះ")),
                          DataColumn(label: _headerText("ភូមិ")),
                          DataColumn(label: _headerText("ទឹកប្រាក់")),
                          DataColumn(label: _headerText("សកម្មភាពភ្ញៀវ")),
                        ],
                        rows: currentPageData.asMap().entries.map((entry) {
                          int indexOnPage = entry.key;
                          var user = entry.value;
                          int globalIndex = startIndex + indexOnPage + 1;

                          return DataRow(cells: [
                            DataCell(Text(globalIndex.toString(), style: GoogleFonts.kantumruyPro(fontWeight: FontWeight.bold))),
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
                                      Get.to(PostData());
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
            ),

            // Pagination Controls
            if (totalPages > 1)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: Colors.grey[50],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "ទំព័រទី ${_currentPage + 1} នៃ $totalPages ($totalItems នាក់)",
                      style: GoogleFonts.kantumruyPro(color: Colors.grey[700], fontSize: 13),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.chevron_left),
                          onPressed: _currentPage > 0
                              ? () {
                                  setState(() {
                                    _currentPage--;
                                  });
                                }
                              : null,
                        ),
                        Text(
                          "${_currentPage + 1}",
                          style: GoogleFonts.kantumruyPro(fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: const Icon(Icons.chevron_right),
                          onPressed: _currentPage < totalPages - 1
                              ? () {
                                  setState(() {
                                    _currentPage++;
                                  });
                                }
                              : null,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

            // Total Price Section
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
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      "${_totalPrice.toStringAsFixed(0)} ៛",
                      style: GoogleFonts.kantumruyPro(
                        fontSize: 20, 
                        color: Colors.orange[900], 
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );

        // ប្រើប្រាស់ Responsive Widget ដើម្បីរៀប Padding តាមប្រភេទ Screen
        return Responsive(
          mobile: bodyContent,
          tablet: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: bodyContent,
            ),
          ),
          desktop: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 1200),
              padding: const EdgeInsets.all(24.0),
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: bodyContent,
              ),
            ),
          ),
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

  final dataToPdf = DataToPdfService();
}