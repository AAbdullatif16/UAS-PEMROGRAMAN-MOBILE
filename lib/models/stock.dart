// lib/models/stock.dart
// lib/screens/stock_screen.dart
import 'package:flutter/material.dart';
import 'package:toko_pakaian_cyberpunk/models/stock.dart';
import 'package:toko_pakaian_cyberpunk/services/api_service.dart';

// class StockScreen extends StatefulWidget {
//   @override
//   _StockScreenState createState() => _StockScreenState();
// }

// class _StockScreenState extends State<StockScreen> {
//   late Future<List<Stock>> futureStocks;
//   final ApiService apiService = ApiService();

//   @override
//   void initState() {
//     super.initState();
//     futureStocks = apiService.getStocks();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Stok Pakaian'),
//       ),
//       body: FutureBuilder<List<Stock>>(
//         future: futureStocks,
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             return ListView.builder(
//               itemCount: snapshot.data!.length,
//               itemBuilder: (context, index) {
//                 Stock stock = snapshot.data![index];
//                 return ListTile(
//                   title: Text(stock.name),
//                   subtitle: Text(
//                       'Qty: ${stock.qty}, Attr: ${stock.attr}, Weight: ${stock.weight}'),
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
//           // Tambahkan navigasi ke halaman tambah/edit stok
//         },
//         child: Icon(Icons.add),
//       ),
//     );
//   }
// }

class Stock {
  final String? id;
  final String? name;
  final num? qty;
  final String? attr;
  final num? weight;
  final String? issuer;
  final int? createdAt;
  final int? updatedAt;
  Stock({
    this.id,
    this.name,
    this.qty,
    this.attr,
    this.weight,
    this.issuer,
    this.createdAt,
    this.updatedAt,
  });

  factory Stock.fromJson(Map<String, dynamic> json) {
    return Stock(
      id: json['id'] as String?,
      name: json['name'],
      qty: json['qty'],
      attr: json['attr'],
      weight: json['weight'],
      issuer: json['issuer'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    final data = {
      'name': name,
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

  Stock copyWith({
    String? id,
    String? name,
    num? qty,
    String? attr,
    num? weight,
    String? issuer,
    int? createdAt,
    int? updatedAt,
  }) {
    return Stock(
      id: id ?? this.id,
      name: name ?? this.name,
      qty: qty ?? this.qty,
      attr: attr ?? this.attr,
      weight: weight ?? this.weight,
      issuer: issuer ?? this.issuer,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
