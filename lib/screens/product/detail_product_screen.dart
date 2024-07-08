import 'package:flutter/material.dart';
import 'package:toko_pakaian_cyberpunk/models/product.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:toko_pakaian_cyberpunk/models/stock.dart';
import 'package:toko_pakaian_cyberpunk/screens/stock/subtract_stock.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  ProductDetailScreen({required this.product});

  @override
  Widget build(BuildContext context) {
    DateFormat dateFormat =
        DateFormat('d MMMM yyyy \'pukul\' HH:mm:ss', 'id_ID');
    String formattedCreatedAt = product.createdAt != null
        ? dateFormat
            .format(DateTime.fromMillisecondsSinceEpoch(product.createdAt!))
        : 'N/A';
    String formattedUpdatedAt = product.updatedAt != null
        ? dateFormat
            .format(DateTime.fromMillisecondsSinceEpoch(product.updatedAt!))
        : 'N/A';

    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Produk', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        // Adding a back button
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          // Adding a Checkout button
          IconButton(
            icon: Icon(Icons.shopping_cart, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SubtractStock(
                          initialProduct: product,
                        )),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(
                    'https://api.kartel.dev/products/${product.id}/image'),
              ),
            ),
            SizedBox(height: 20),
            Text(
              product.name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('Harga: Rp. ${product.price ?? 'N/A'}',
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Kuantitas: ${product.qty}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Atribut: ${product.attr}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Ukuran: ${product.weight}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            Text('Dibuat: $formattedCreatedAt', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text('Diperbarui: $formattedUpdatedAt',
                style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
