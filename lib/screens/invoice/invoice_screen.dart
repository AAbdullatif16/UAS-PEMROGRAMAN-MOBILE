import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:toko_pakaian_cyberpunk/models/product.dart';
import 'package:toko_pakaian_cyberpunk/models/sale.dart';

class InvoiceScreen extends StatelessWidget {
  final Sale sale;
  final Product product;

  InvoiceScreen({required this.sale, required this.product});

  Future<void> _printInvoice() async {
    try {
      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'Invoice Penjualan',
                  style: pw.TextStyle(
                      fontSize: 24, fontWeight: pw.FontWeight.bold),
                ),
                pw.SizedBox(height: 20),
                pw.Text('Produk: ${product.name}',
                    style: pw.TextStyle(fontSize: 18)),
                pw.Text('Harga: Rp. ${product.price}',
                    style: pw.TextStyle(fontSize: 18)),
                pw.Text('Pembeli: ${sale.buyer}',
                    style: pw.TextStyle(fontSize: 18)),
                pw.Text('Telepon: ${sale.phone}',
                    style: pw.TextStyle(fontSize: 18)),
                pw.Text('Tanggal: ${sale.date}',
                    style: pw.TextStyle(fontSize: 18)),
                pw.Text('Status: ${sale.status}',
                    style: pw.TextStyle(fontSize: 18)),
                pw.SizedBox(height: 20),
                pw.Text('Terima kasih telah berbelanja!',
                    style: pw.TextStyle(fontSize: 16)),
              ],
            );
          },
        ),
      );

      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save(),
      );
    } catch (e) {
      // Handle the exception here
      print('Error printing PDF: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Menghilangkan tombol kembali
        title: Text(
          'Invoice',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Invoice Penjualan',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text('Produk: ${product.name}', style: TextStyle(fontSize: 18)),
            Text('Harga: Rp. ${product.price}', style: TextStyle(fontSize: 18)),
            Text('Pembeli: ${sale.buyer}', style: TextStyle(fontSize: 18)),
            Text('Telepon: ${sale.phone}', style: TextStyle(fontSize: 18)),
            Text('Tanggal: ${sale.date}', style: TextStyle(fontSize: 18)),
            Text('Status: ${sale.status}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            Text('Terimakasih..!', style: TextStyle(fontSize: 16)),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.black)),
                  onPressed: () {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  child: Text(
                    'Kembali ke Home',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
