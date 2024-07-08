import 'package:flutter/material.dart';
import 'package:toko_pakaian_cyberpunk/models/product.dart';
import 'package:toko_pakaian_cyberpunk/screens/product/add_product_screen.dart';
import 'package:toko_pakaian_cyberpunk/screens/product/update_product_screen.dart';
import 'package:toko_pakaian_cyberpunk/services/api_service.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class ProductScreen extends StatefulWidget {
  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  Future<List<Product>>? futureProducts;
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('id_ID', null).then((_) {
      setState(() {
        futureProducts = apiService.getProducts();
      });
    });
  }

  void onProductTap(Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateProductScreen(
          product: product,
        ),
      ),
    ).then((_) => refreshProducts());
  }

  void onAddProduct() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddProductScreen()),
    ).then((_) => refreshProducts());
  }

  void refreshProducts() {
    setState(() {
      futureProducts = apiService.getProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Daftar Produk',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      body: FutureBuilder<List<Product>>(
        future: futureProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                DateFormat dateFormat =
                    DateFormat('d MMMM yyyy \'pukul\' HH:mm:ss', 'id_ID');
                Product product = snapshot.data![index];
                DateTime createdAtDateTime =
                    DateTime.fromMillisecondsSinceEpoch(
                        int.parse('${product.createdAt}'));
                DateTime updatedAtDateTime =
                    DateTime.fromMillisecondsSinceEpoch(
                        int.parse('${product.updatedAt}'));
                String formattedCreatedAt =
                    dateFormat.format(createdAtDateTime);
                String formattedUpdatedAt =
                    dateFormat.format(updatedAtDateTime);
                return InkWell(
                  onTap: () => onProductTap(product),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 1,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    child: ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.name,
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            'Dibuat $formattedCreatedAt',
                            style: TextStyle(fontSize: 12),
                          ),
                          Text(
                            'Diperbarui $formattedUpdatedAt',
                            style: TextStyle(fontSize: 12),
                          ),
                          Text(
                            'Rp. ${product.price}',
                            style: const TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                            'https://api.kartel.dev/products/${product.id}/image'),
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(child: Text('No products found'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: onAddProduct,
        label: const Text(
          'Tambah Produk',
          style: TextStyle(color: Colors.white),
        ),
        icon: const Icon(Icons.add, color: Colors.white),
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40),
        ),
      ),
    );
  }
}
