import 'package:flutter/material.dart';
import 'package:toko_pakaian_cyberpunk/models/goods.dart';
import 'package:toko_pakaian_cyberpunk/screens/invoice/invoice_detail_screen.dart';
import 'package:toko_pakaian_cyberpunk/services/api_service.dart';

class InvoiceListScreen extends StatefulWidget {
  @override
  _InvoiceListScreenState createState() => _InvoiceListScreenState();
}

class _InvoiceListScreenState extends State<InvoiceListScreen> {
  late Future<List<Goods>> futureGoods;
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    futureGoods = apiService.getGoods();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Invoice', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      body: FutureBuilder<List<Goods>>(
        future: futureGoods,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Tidak ada invoice tersedia'));
          } else {
            List<Goods> goodsList = snapshot.data!;
            return ListView.builder(
              itemCount: goodsList.length,
              itemBuilder: (context, index) {
                Goods goods = goodsList[index];
                return Container(
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
                    title: Text(
                      'Invoice ID: ${goods.saleId}',
                      style: TextStyle(fontSize: 12),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Product ID: ${goods.productId}',
                          style: TextStyle(fontSize: 12),
                        ),
                        Text('Quantity: ${goods.qty}'),
                      ],
                    ),
                    isThreeLine: true,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => InvoiceDetailScreen(
                            productId: goods.productId,
                            saleId: goods.saleId,
                            goodsId: '${goods.id}',
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
