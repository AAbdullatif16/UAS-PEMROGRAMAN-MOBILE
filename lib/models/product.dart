// lib/screens/product_screen.dart
import 'package:flutter/material.dart';
import 'package:toko_pakaian_cyberpunk/models/product.dart';
import 'package:toko_pakaian_cyberpunk/services/api_service.dart';

// lib/models/product.dart
class Product {
  final String? id;
  final String name;
  final num? price;
  final num qty;
  final String attr;
  final num weight;
  final String? issuer;
  final int? createdAt;
  final int? updatedAt;

  Product({
    this.id,
    required this.name,
    this.price,
    required this.qty,
    required this.attr,
    required this.weight,
    this.issuer,
    this.createdAt,
    this.updatedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String?,
      name: json['name'] as String? ?? '',
      price: json['price'] as num?,
      qty: json['qty'] as num? ?? 0,
      attr: json['attr'] as String? ?? '',
      weight: json['weight'] as num? ?? 0,
      issuer: json['issuer'] as String?,
      createdAt: json['createdAt'] as int?,
      updatedAt: json['updatedAt'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    final data = {
      'name': name,
      'price': price,
      'qty': qty,
      'attr': attr,
      'weight': weight,
      'issuer': issuer,
    };

    if (id != null) {
      data['id'] = id!;
    }
    if (createdAt != null) {
      data['id'] = createdAt!;
    }
    if (updatedAt != null) {
      data['id'] = updatedAt!;
    }

    return data;
  }
}

// class ProductScreen extends StatefulWidget {
//   @override
//   _ProductScreenState createState() => _ProductScreenState();
// }

// class _ProductScreenState extends State<ProductScreen> {
//   late Future<List<Product>> futureProducts;
//   final ApiService apiService = ApiService();

//   @override
//   void initState() {
//     super.initState();
//     futureProducts = apiService.getProducts() as Future<List<Product>>;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Produk'),
//       ),
//       body: FutureBuilder<List<Product>>(
//         future: futureProducts,
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             return ListView.builder(
//               itemCount: snapshot.data!.length,
//               itemBuilder: (context, index) {
//                 Product product = snapshot.data![index];
//                 return ListTile(
//                   title: Text(product.name),
//                   subtitle: Text(
//                       'Harga: ${product.price}, Qty: ${product.qty}, Attr: ${product.attr}, Berat: ${product.weight}'),
//                 );
//               },
//             );
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           }
//           return Center(child: CircularProgressIndicator());
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           // Tambahkan navigasi ke halaman tambah/edit produk
//         },
//         child: Icon(Icons.add),
//       ),
//     );
//   }
// }

