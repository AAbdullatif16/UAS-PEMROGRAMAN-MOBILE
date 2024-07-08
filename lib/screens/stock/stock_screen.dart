import 'package:flutter/material.dart';
import 'package:toko_pakaian_cyberpunk/models/product.dart';
import 'package:toko_pakaian_cyberpunk/models/sale.dart';
import 'package:toko_pakaian_cyberpunk/screens/product/detail_product_screen.dart';
import 'package:toko_pakaian_cyberpunk/screens/stock/add_stock.dart';
import 'package:toko_pakaian_cyberpunk/screens/stock/subtract_stock.dart';
import 'package:toko_pakaian_cyberpunk/services/api_service.dart';

class StockScreen extends StatefulWidget {
  @override
  _StockScreenState createState() => _StockScreenState();
}

class _StockScreenState extends State<StockScreen> {
  late Future<List<Product>> futureStocks;
  late Future<List<Sale>> futureSales;
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    futureStocks = apiService.getProducts();
    futureSales = apiService.getSales();
  }

  void refreshProducts() {
    setState(() {
      futureStocks = apiService.getProducts();
    });
  }

  void onProductTap(Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailScreen(product: product),
      ),
    ).then((_) => refreshProducts());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cyberpunk Shop',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildStockOverview(
                  futureStocks,
                  Icons.shopping_bag,
                  '0',
                  Colors.blue,
                ),
                buildStockOverview(
                  futureSales,
                  Icons.shopping_cart,
                  '0',
                  Colors.blue,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildStockAction(
                  'Tambah Stok',
                  Icons.add_box_sharp,
                  Colors.green,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddStockScreen()),
                  ),
                ),
                buildStockAction(
                  'Kurangi Stok',
                  Icons.indeterminate_check_box,
                  Colors.red,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SubtractStock()),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 5),
            child: Text(
              'Stok Produk',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Product>>(
              future: futureStocks,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('Tidak ada stock'));
                } else {
                  List<Product> stocks = snapshot.data!;
                  return ListView.builder(
                    itemCount: stocks.length,
                    itemBuilder: (context, index) {
                      Product stock = stocks[index];
                      return InkWell(
                        onTap: () => onProductTap(stock),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border(
                              bottom: BorderSide(
                                color: Color.fromARGB(255, 207, 207, 207),
                                width: 1.0,
                              ),
                            ),
                          ),
                          child: ListTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      stock.name,
                                      style: const TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  '${stock.qty}',
                                  style: const TextStyle(color: Colors.black),
                                ),
                              ],
                            ),
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  'https://api.kartel.dev/products/${stock.id}/image'),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildStockOverview(
    Future<List<dynamic>> future,
    IconData icon,
    String defaultText,
    Color iconColor,
  ) {
    return InkWell(
      child: Container(
        height: 100,
        width: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: FutureBuilder<List<dynamic>>(
          future: future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return buildOverviewContent(icon, defaultText, iconColor);
            } else {
              return buildOverviewContent(
                  icon, '${snapshot.data!.length}', iconColor);
            }
          },
        ),
      ),
    );
  }

  Widget buildOverviewContent(IconData icon, String text, Color iconColor) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 50, color: iconColor),
          SizedBox(height: 4),
          Text(
            text,
            style: TextStyle(fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget buildStockAction(
    String label,
    IconData icon,
    Color iconColor,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 100,
        width: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: iconColor),
            SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
