import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:tindahan_natin/features/dashboard/store.dart';
import 'package:tindahan_natin/features/lista/lista_entry.dart';

class ListaReportService {
  static Future<void> generateAndDownloadPdf({
    required Store store,
    required List<ListaEntry> entries,
  }) async {
    final pdf = pw.Document();

    final font = await PdfGoogleFonts.nunitoRegular();
    final fontBold = await PdfGoogleFonts.nunitoBold();

    final totalSales = entries.where((e) => !e.isCredit).fold(0.0, (sum, e) => sum + e.totalAmount);
    final totalCredit = entries.where((e) => e.isCredit).fold(0.0, (sum, e) => sum + e.totalAmount);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          pw.Header(
            level: 0,
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(store.name, style: pw.TextStyle(font: fontBold, fontSize: 24)),
                    pw.Text('Sales & Credit Report', style: pw.TextStyle(font: font, fontSize: 14)),
                  ],
                ),
                pw.Text(
                  DateTime.now().toString().split('.')[0],
                  style: pw.TextStyle(font: font, color: PdfColors.grey),
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 20),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
            children: [
              _buildSummaryBox('Total Transactions', entries.length.toString(), fontBold, font),
              _buildSummaryBox('Total Sales (Cash)', 'P${totalSales.toStringAsFixed(2)}', fontBold, font),
              _buildSummaryBox('Total Credit (Utang)', 'P${totalCredit.toStringAsFixed(2)}', fontBold, font),
            ],
          ),
          pw.SizedBox(height: 30),
          pw.Text('Transaction History', style: pw.TextStyle(font: fontBold, fontSize: 18)),
          pw.Divider(),
          pw.TableHelper.fromTextArray(
            headerStyle: pw.TextStyle(font: fontBold, color: PdfColors.white),
            headerDecoration: const pw.BoxDecoration(color: PdfColors.blueGrey),
            cellAlignment: pw.Alignment.centerLeft,
            headerAlignment: pw.Alignment.centerLeft,
            data: <List<String>>[
              <String>['Date', 'Customer', 'Staff', 'Type', 'Total'],
              ...entries.map((e) => [
                e.createdAt.toLocal().toString().split(' ')[0],
                e.customerName ?? 'Walk-in',
                e.staffName,
                e.isCredit ? 'Credit' : 'Cash',
                'P${e.totalAmount.toStringAsFixed(2)}',
              ]),
            ],
          ),
        ],
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: '${store.name}_Report_${DateTime.now().millisecondsSinceEpoch}.pdf',
    );
  }

  static pw.Widget _buildSummaryBox(String label, String value, pw.Font bold, pw.Font reg) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(5)),
      ),
      child: pw.Column(
        children: [
          pw.Text(label, style: pw.TextStyle(font: reg, fontSize: 10)),
          pw.Text(value, style: pw.TextStyle(font: bold, fontSize: 16)),
        ],
      ),
    );
  }
}
