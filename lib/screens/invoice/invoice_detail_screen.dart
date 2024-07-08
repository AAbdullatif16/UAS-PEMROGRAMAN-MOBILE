import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:toko_pakaian_cyberpunk/models/product.dart';
import 'package:toko_pakaian_cyberpunk/models/sale.dart';
import 'package:toko_pakaian_cyberpunk/services/api_service.dart';

class InvoiceDetailScreen extends StatefulWidget {
  final String productId;
  final String saleId;
  final String goodsId;

  InvoiceDetailScreen(
      {required this.productId, required this.saleId, required this.goodsId});

  @override
  _InvoiceDetailScreenState createState() => _InvoiceDetailScreenState();
}

class _InvoiceDetailScreenState extends State<InvoiceDetailScreen> {
  late Future<Product> futureProduct;
  late Future<Sale> futureSale;
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    futureProduct = apiService.getProductById(widget.productId);
    futureSale = apiService.getSaleById(widget.saleId);
  }

  void _deleteInvoice() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Hapus Invoice'),
          content: Text('Apakah Anda yakin ingin menghapus invoice ini?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                try {
                  print(widget.saleId);
                  await apiService.deleteGoods(widget.goodsId);
                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   SnackBar(content: Text('Invoice berhasil dihapus')),
                  // );
                  Navigator.of(context).pop(); // Kembali ke halaman sebelumnya
                } catch (e) {
                  print(e);
                  Navigator.of(context).pop();
                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   SnackBar(content: Text('Gagal menghapus invoice: $e')),
                  // );
                }
              },
              child: Text('Hapus'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Invoice', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.delete, color: Colors.white),
            onPressed: _deleteInvoice,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder<Product>(
              future: futureProduct,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  print(snapshot);
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  Product product = snapshot.data!;
                  print(jsonEncode(product));
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(
                              'https://api.kartel.dev/products/${product.id}/image'),
                        ),
                      ),
                      Text('Produk: ${product.name}',
                          style: TextStyle(fontSize: 18)),
                      Text('Harga: Rp. ${product.price}',
                          style: TextStyle(fontSize: 18)),
                    ],
                  );
                } else {
                  return Center(child: Text('No product found'));
                }
              },
            ),
            SizedBox(height: 20),
            FutureBuilder<Sale>(
              future: futureSale,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  print(snapshot);
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  Sale sale = snapshot.data!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Pembeli: ${sale.buyer}',
                          style: TextStyle(fontSize: 18)),
                      Text('Telepon: ${sale.phone}',
                          style: TextStyle(fontSize: 18)),
                      Text('Tanggal: ${sale.date}',
                          style: TextStyle(fontSize: 18)),
                      Text('Status: ${sale.status}',
                          style: TextStyle(fontSize: 18)),
                    ],
                  );
                } else {
                  return Center(child: Text('No sale found'));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
