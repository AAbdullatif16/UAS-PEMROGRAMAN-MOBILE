// lib/screens/sale_screen.dart
import 'package:flutter/material.dart';
import 'package:toko_pakaian_cyberpunk/models/sale.dart';
import 'package:toko_pakaian_cyberpunk/services/api_service.dart';

class Sale {
  final String? id;
  final String buyer;
  final String phone;
  final String date;
  final String status;
  final String? issuer;

  Sale(
      {this.id,
      required this.buyer,
      required this.phone,
      required this.date,
      required this.status,
      this.issuer
      });

  factory Sale.fromJson(Map<String, dynamic> json) {
    return Sale(
      id: json['id'],
      buyer: json['buyer'],
      phone: json['phone'],
      date: json['date'],
      status: json['status'],
      issuer: json['issuer']
    );
  }

  Map<String, dynamic> toJson() {
    final data = {
      'buyer': buyer,
      'phone': phone,
      'date': date,
      'status': status,
      'issuer': issuer,
    };

    if (id != null) {
      data['id'] = id!;
    }

    return data;
  }
}

class SaleScreen extends StatefulWidget {
  @override
  _SaleScreenState createState() => _SaleScreenState();
}

class _SaleScreenState extends State<SaleScreen> {
  late Future<List<Sale>> futureSales;
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    futureSales = apiService.getSales();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Penjualan'),
      ),
      body: FutureBuilder<List<Sale>>(
        future: futureSales,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Sale sale = snapshot.data![index];
                return ListTile(
                  title: Text(sale.buyer),
                  subtitle: Text(
                      'Telepon: ${sale.phone}, Tanggal: ${sale.date}, Status: ${sale.status}'),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Tambahkan navigasi ke halaman tambah/edit penjualan
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
