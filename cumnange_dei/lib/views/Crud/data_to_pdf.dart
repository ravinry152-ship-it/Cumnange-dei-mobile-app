// ignore_for_file: deprecated_member_use
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';

class DataToPdfService {
  Future<void> exportPdf({
    required List data,
    required double total,
  }) async {
    const int itemsPerPage = 30;
    final totalPages = (data.length / itemsPerPage).ceil();

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async {
        final htmlPages = <String>[];

        for (int page = 0; page < totalPages; page++) {
          final start = page * itemsPerPage;
          final end = (start + itemsPerPage).clamp(0, data.length);
          final pageData = data.sublist(start, end);

          htmlPages.add(_buildHtmlPage(
            pageData: pageData,
            pageNumber: page + 1,
            totalPages: totalPages,
            total: total,
            startIndex: start,
          ));
        }

        // បញ្ចូលគ្នារាល់ទំព័រ
        final fullHtml = '''
        <!DOCTYPE html>
        <html>
        <head>
          <meta charset="UTF-8">
          <style>
            @import url('https://fonts.googleapis.com/css2?family=Noto+Sans+Khmer:wght@400;700&display=swap');
            body {
              font-family: 'Noto Sans Khmer', sans-serif;
              margin: 0;
              padding: 0;
            }
            .page {
              page-break-after: always;
              padding: 24px;
            }
            .page:last-child {
              page-break-after: auto;
            }
            h2 {
              text-align: center;
              margin-bottom: 16px;
              font-size: 20px;
            }
            table {
              width: 100%;
              border-collapse: collapse;
              margin-bottom: 16px;
            }
            th, td {
              border: 1px solid #444;
              padding: 8px 10px;
              font-size: 13px;
            }
            th {
              background-color: #e0e0e0;
              font-weight: bold;
            }
            .footer {
              display: flex;
              justify-content: space-between;
              margin-top: 20px;
              font-size: 13px;
            }
            .total {
              font-weight: bold;
              font-size: 15px;
            }
          </style>
        </head>
        <body>
          ${htmlPages.join('\n')}
        </body>
        </html>
        ''';

        return await Printing.convertHtml(
          format: format,
          html: fullHtml,
        );
      },
    );
  }

  String _buildHtmlPage({
    required List pageData,
    required int pageNumber,
    required int totalPages,
    required double total,
    required int startIndex,
  }) {
    final rows = pageData.asMap().entries.map((entry) {
      final index = startIndex + entry.key + 1;
      final user = entry.value;

      return '''
        <tr>
          <td style="text-align:center;">$index</td>
          <td>${user.name ?? ''}</td>
          <td>${user.village ?? ''}</td>
          <td style="text-align:right;">${user.price} ៛</td>
        </tr>
      ''';
    }).join();

    return '''
    <div class="page">
      <h2>បញ្ជីឈ្មោះភ្ញៀវ</h2>

      <table>
        <thead>
          <tr>
            <th>ល.រ</th>
            <th>ឈ្មោះ</th>
            <th>ភូមិ</th>
            <th>តម្លៃ</th>
          </tr>
        </thead>
        <tbody>
          $rows
        </tbody>
      </table>

      <div class="footer">
        <div>ទំព័រ $pageNumber / $totalPages</div>
        <div class="total">សរុបរួម: ${total.toStringAsFixed(0)} ៛</div>
      </div>
    </div>
    ''';
  }
}