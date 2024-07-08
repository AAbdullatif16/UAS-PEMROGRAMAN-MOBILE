import 'package:flutter/material.dart';
import 'package:toko_pakaian_cyberpunk/models/sale.dart';
import 'package:toko_pakaian_cyberpunk/screens/sale/add_sale_screen.dart';
import 'package:toko_pakaian_cyberpunk/screens/sale/update_sale_screen.dart';
import 'package:toko_pakaian_cyberpunk/services/api_service.dart';

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

  void onSaleTap(Sale sale) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UpdateSaleScreen(sale: sale)),
    ).then((_) => setState(() {
          futureSales = apiService.getSales();
        }));
  }

  void onAddSale() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddSaleScreen()),
    ).then((_) => setState(() {
          futureSales = apiService.getSales();
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text('Penjualan',style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.black,
        ),
        body: FutureBuilder<List<Sale>>(
          future: futureSales,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  Sale sale = snapshot.data![index];
                  return InkWell(
                      onTap: () => onSaleTap(sale),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 4),
                        decoration: BoxDecoration(
                          color: Colors
                              .white, // Warna latar belakang diubah menjadi putih
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
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    sale.buyer,
                                    style: const TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    '${sale.phone}',
                                    style: const TextStyle(
                                        color:
                                            Color.fromARGB(255, 104, 104, 104),
                                        fontSize: 14),
                                  ),
                                ],
                              ),
                              Text(
                                '${sale.status}',
                                style: const TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ));
                },
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 20, right: 10),
          child: SizedBox(
            height: 50,
            child: FloatingActionButton.extended(
              onPressed: onAddSale,
              label: const Text(
                'Sale',
                style: TextStyle(color: Colors.white),
              ),
              icon: const Icon(Icons.add, color: Colors.white),
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
            ),
          ),
        ));
  }
}
