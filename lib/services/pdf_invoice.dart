import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfInvoiceService {
  Future<pw.Document> createInvoice(Map<String, dynamic> data) async {
    final pdf = pw.Document();

    // ✅ Load logo from assets
    final Uint8List logoBytes = await rootBundle
        .load('assets/images/Logo.png')
        .then((value) => value.buffer.asUint8List());
    final logo = pw.MemoryImage(logoBytes);

    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          // ✅ Logo & Header
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Image(logo, width: 60, height: 60),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Text(
                    "Noviindus Ayurveda",
                    style: pw.TextStyle(
                      fontSize: 20,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Text(
                    "Kumarakom, Kerala - 686563",
                    style: pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
                  ),
                  pw.Text(
                    "Mob: +91 9876543210 | GST: 32ABACD9083R1ZW",
                    style: pw.TextStyle(fontSize: 9, color: PdfColors.grey600),
                  ),
                ],
              ),
            ],
          ),
          pw.SizedBox(height: 10),
          pw.Divider(),

          // ✅ Patient Details
          pw.Text(
            "Patient Details",
            style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 5),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text("Name: ${data['name']}"),
                  pw.Text("Address: ${data['address']}"),
                  pw.Text("Whatsapp: ${data['phone']}"),
                ],
              ),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [pw.Text("Booked On: ${data['date_nd_time']}")],
              ),
            ],
          ),

          pw.SizedBox(height: 20),

          // ✅ Treatment Table
          pw.Table.fromTextArray(
            headers: ["Treatment", "Price", "Male", "Female", "Total"],
            headerStyle: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.white,
            ),
            headerDecoration: pw.BoxDecoration(color: PdfColors.green700),
            data: (data['treatments'] as List).map((t) {
              return [
                t['treatment'],
                "${t['price']}",
                "${t['male']}",
                "${t['female']}",
                "${t['total']}",
              ];
            }).toList(),
          ),

          pw.SizedBox(height: 20),

          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.end,
            children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    "Total Amount: ${data['total']}",
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                  pw.Text("Discount: ${data['discount']}"),
                  pw.Text("Advance: ${data['advance']}"),
                  pw.Text(
                    "Balance: ₹${data['balance']}",
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.black,
                    ),
                  ),
                ],
              ),
            ],
          ),

          pw.SizedBox(height: 30),

          // ✅ Footer
          pw.Center(
            child: pw.Text(
              "Thank you for choosing us",
              style: pw.TextStyle(
                fontSize: 14,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.green,
              ),
            ),
          ),
          pw.Center(
            child: pw.Text(
              "Your wellbeing is our commitment...",
              style: pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
            ),
          ),
        ],
      ),
    );

    return pdf;
  }
}
