// import 'dart:io';
// import 'package:cumnange_dei/model/Post_data/post_data_model.dart';
// import 'package:flutter/services.dart';
// import 'package:intl/intl.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// // ── Service ──────────────────────────────────────────────────────────────────
// class PdfService {
//   get OpenFile => null;
//   Future<pw.Font> _loadKhmerFont() async {
//     final fontData = await rootBundle.load('assets/fonts/NotoSansKhmer-Regular.ttf');
//     return pw.Font.ttf(fontData);
//   }

//   /// Generates a PDF for [data] and saves it to the device's Documents folder.
//   /// Returns the saved [File].
//   Future<File> dataPdf(List<PostDataModel> data) async {
//     final khmerFont = await _loadKhmerFont();

//     // ── Text styles ──────────────────────────────────────────────────────────
//     final titleStyle = pw.TextStyle(
//       font: khmerFont,
//       fontSize: 18,
//       fontWeight: pw.FontWeight.bold,
//       color: PdfColor.fromHex('#E6A817'), // orange – matches the UI
//     );

//     final headerStyle = pw.TextStyle(
//       font: khmerFont,
//       fontSize: 11,
//       fontWeight: pw.FontWeight.bold,
//       color: PdfColor.fromHex('#E6A817'),
//     );

//     final cellStyle = pw.TextStyle(
//       font: khmerFont,
//       fontSize: 11,
//       color: PdfColors.black,
//     );

//     final amountStyle = pw.TextStyle(
//       font: khmerFont,
//       fontSize: 11,
//       color: PdfColor.fromHex('#2ECC71'), // green amounts – matches the UI
//     );

//     // ── Column headers (Khmer) ───────────────────────────────────────────────
//     const headers = ['លេខរៀង', 'ឈ្មោះ', 'គូមិ', 'រំជ្រាក់'];

//     // ── Build rows ───────────────────────────────────────────────────────────
//     final numberFmt = NumberFormat('#,##0.0');

//     List<pw.TableRow> buildRows() {
//       final rows = <pw.TableRow>[];

//       // Header row
//       rows.add(
//         pw.TableRow(
//           decoration: const pw.BoxDecoration(
//             color: PdfColor.fromInt(0xFFFFF3E0), // light orange tint
//           ),
//           children: headers.map((h) {
//             return pw.Padding(
//               padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 6),
//               child: pw.Text(h, style: headerStyle),
//             );
//           }).toList(),
//         ),
//       );

//       // Data rows
//       for (int i = 0; i < data.length; i++) {
//         final item = data[i];
//         final isEven = i % 2 == 0;

//         rows.add(
//           pw.TableRow(
//             decoration: pw.BoxDecoration(
//               color: isEven ? PdfColors.white : PdfColor.fromHex('#FAFAFA'),
//             ),
//             children: [
//               _cell('${item.id}', cellStyle),
//               _cell(item.name!, cellStyle),
//               _cell(item.village!, cellStyle),
//               _cell('${numberFmt.format(item.price)} \$', amountStyle),
//             ],
//           ),
//         );
//       }

//       return rows;
//     }

//     // ── Build PDF document ───────────────────────────────────────────────────
//     final pdf = pw.Document();

//     pdf.addPage(
//       pw.MultiPage(
//         pageFormat: PdfPageFormat.a4,
//         margin: const pw.EdgeInsets.all(24),
//         build: (context) => [
//           // Title
//           pw.Text('បញ្ជីឈ្មោះឡៅ', style: titleStyle),
//           pw.SizedBox(height: 12),

//           // Table
//           pw.Table(
//             border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
//             columnWidths: {
//               0: const pw.FixedColumnWidth(50),   
//               1: const pw.FlexColumnWidth(3),    
//               2: const pw.FlexColumnWidth(2),   
//               3: const pw.FlexColumnWidth(2.5),   
//             },
//             children: buildRows(),
//           ),

//           pw.SizedBox(height: 16),

//           // Footer – total
//           pw.Align(
//             alignment: pw.Alignment.centerRight,
//             child: pw.Text(
//               'សរុប: ${numberFmt.format(data.fold(0.0, (s, e) => s + e.price!))} \$',
//               style: pw.TextStyle(
//                 font: khmerFont,
//                 fontSize: 12,
//                 fontWeight: pw.FontWeight.bold,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );

//     // ── Save to file ─────────────────────────────────────────────────────────
//     final dir = await getApplicationDocumentsDirectory();
//     final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
//     final file = File('${dir.path}/loan_list_$timestamp.pdf');
//     await file.writeAsBytes(await pdf.save());

//     return file;
//   }

//   // ── Helper ───────────────────────────────────────────────────────────────
//   pw.Widget _cell(String text, pw.TextStyle style) {
//     return pw.Padding(
//       padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 6),
//       child: pw.Text(text, style: style),
//     );
//   }

//   /// Convenience method: generate and immediately open the PDF.
//   Future<void> exportAndOpen(List<PostDataModel> data) async {
//     final file = await dataPdf(data);
//     await OpenFile.open(file.path);
//   }
// }