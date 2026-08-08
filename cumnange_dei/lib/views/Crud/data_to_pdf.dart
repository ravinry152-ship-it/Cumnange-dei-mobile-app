import 'package:flutter/services.dart'; // ចាំបាច់សម្រាប់ rootBundle
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

class DataToPdfService {
  Future<void> exportPdf({
    required List data,
    required double total,
  }) async {
    final pdf = pw.Document();

    // ១. Load Font ខ្មែរពី Assets (ត្រូវប្រាកដថាអ្នកមានឯកសារ .ttf ក្នុង assets/fonts/)
    final fontData = await rootBundle.load("assets/fonts/Battambang/Battambang-Black.ttf");
    final khmerFont = pw.Font.ttf(fontData);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        // ២. បង្កើត Theme ដែលប្រើ Font ខ្មែរជា Default
        theme: pw.ThemeData.withFont(
          base: khmerFont,
          bold: khmerFont, // អ្នកអាចប្រើ Font មូល ឬ Bold ផ្សេងទៀតនៅទីនេះ
        ),
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Title
              pw.Text(
                "បញ្ជីឈ្មោះភ្ញៀវ",
                style: pw.TextStyle(
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),

              pw.SizedBox(height: 20),

              // Table
              pw.Table.fromTextArray(
                headers: ["#", "Name", "Village", "Price"],
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                cellStyle: const pw.TextStyle(), // វានឹងប្រើ Font ខ្មែរពី Theme ដោយស្វ័យប្រវត្តិ
                data: List.generate(data.length, (index) {
                  final user = data[index];
                  return [
                    (index + 1).toString(),
                    user.name ?? "",
                    user.village ?? "",
                    "${user.price} ៛",
                  ];
                }),
              ),

              pw.SizedBox(height: 20),

              // Total
              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Text(
                  "សរុបរួម: ${total.toStringAsFixed(0)} ៛",
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
    );
  }
}