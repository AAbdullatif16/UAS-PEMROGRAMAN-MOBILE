import 'package:flutter/material.dart';
import 'package:toko_pakaian_cyberpunk/models/stock.dart';
import 'package:toko_pakaian_cyberpunk/screens/stock/update_stock_screen.dart';
import 'package:toko_pakaian_cyberpunk/services/api_service.dart';

class ListStockScreen extends StatefulWidget {
  @override
  _ListStockScreenState createState() => _ListStockScreenState();
}

class _ListStockScreenState extends State<ListStockScreen> {
  late Future<List<Stock>> futureStocks;
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    futureStocks = apiService.getStocks();
  }

  Future<void> refreshStocks() async {
    setState(() {
      futureStocks = apiService.getStocks();
    });
  }

  void onStockTap(Stock stock) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateStockScreen(stock: stock),
      ),
    ).then((_) => refreshStocks());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History stock', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: refreshStocks,
          ),
        ],
      ),
      body: FutureBuilder<List<Stock>>(
        future: futureStocks,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No stocks available'));
          } else {
            List<Stock> stocks = snapshot.data!;
            return ListView.builder(
              itemCount: stocks.length,
              itemBuilder: (context, index) {
                Stock stock = stocks[index];
                bool isDecrement = stock.name?.contains('(-)') ?? false;
                bool isIncrement = stock.name?.contains('(+)') ?? false;

                Color qtyColor = Colors.black;
                String qtyText = '${stock.qty}';
                String stockName = stock.name ?? '';

                if (isDecrement) {
                  qtyColor = Colors.red;
                  qtyText = '- ${stock.qty}';
                  stockName = stock.name?.replaceAll('(-)', '') ?? '';
                } else if (isIncrement) {
                  qtyColor = Colors.green;
                  qtyText = '+ ${stock.qty}';
                  stockName = stock.name?.replaceAll('(+)', '') ?? '';
                }

                Stock updatedStock = stock.copyWith(name: stockName);

                return InkWell(
                  onTap: () => onStockTap(updatedStock),
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
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                stockName,
                                style: const TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                '${stock.attr}',
                                style: const TextStyle(
                                    color: Color.fromARGB(255, 104, 104, 104),
                                    fontSize: 14),
                              ),
                            ],
                          ),
                          Text(
                            qtyText,
                            style: TextStyle(color: qtyColor),
                          ),
                        ],
                      ),
                    ),
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
