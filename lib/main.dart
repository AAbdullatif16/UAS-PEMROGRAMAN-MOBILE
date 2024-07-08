// lib/main.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:toko_pakaian_cyberpunk/screens/invoice/list_invoice_screen.dart';
import 'package:toko_pakaian_cyberpunk/screens/stock/list_stock_screen.dart';
import 'screens/stock/stock_screen.dart';
import 'screens/product/product_screen.dart';
import 'screens/sale/sale_screen.dart';
import 'screens/checkout/checkout_screen.dart';
import 'screens/invoice/invoice_screen.dart';
import 'screens/reseller/reseller_screen.dart';
import 'package:bottom_bar_matu/bottom_bar_matu.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id', null);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Toko Pakaian Cyberpunk',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        textTheme: GoogleFonts.robotoTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: const MyHomePage(),
      routes: {
        '/stocks': (context) => StockScreen(),
        '/products': (context) => ProductScreen(),
        '/sales': (context) => SaleScreen(),
        '/checkout': (context) => CheckoutScreen(),
        // '/invoice': (context) => InvoiceScreen(),
        '/resellers': (context) => ResellerScreen(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final PageController controller = PageController();
  int _currentIndex = 0;
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomBarBubble(
        backgroundColor: const Color.fromARGB(255, 240, 240, 240),
        color: Colors.black,
        height: 60,
        items: [
          BottomBarItem(
            iconData: Icons.home,

            // label: 'Home',
          ),
          BottomBarItem(
            iconData: Icons.shopping_bag_outlined,
            // label: 'Chat',
          ),
          BottomBarItem(
            iconData: Icons.receipt,
            // label: 'Notification',
          ),
          BottomBarItem(
            iconData: Icons.history,
            // label: 'Notification',
          ),
          BottomBarItem(
            iconData: Icons.description,
            // label: 'Notification',
          ),
        ],
        onSelect: (index) {
          _currentIndex = index;
          controller.jumpToPage(_currentIndex);
          // print(_currentIndex);
        },
      ),
      body: PageView(
        controller: controller,
        physics: const NeverScrollableScrollPhysics(),
        children: <Widget>[
          Center(
            child: StockScreen(),
          ),
          Center(
            child: ProductScreen(),
          ),
          Center(
            child: SaleScreen(),
          ),
          Center(
            child: ListStockScreen(),
          ),
          Center(
            child: InvoiceListScreen(),
          ),
        ],
      ),
    );
  }
}
// class HomeScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Toko Pakaian Cyberpunk'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.pushNamed(context, '/stocks');
//               },
//               child: Text('Stocks'),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.pushNamed(context, '/products');
//               },
//               child: Text('Products'),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.pushNamed(context, '/sales');
//               },
//               child: Text('Sales'),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.pushNamed(context, '/checkout');
//               },
//               child: Text('Checkout'),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.pushNamed(context, '/invoice');
//               },
//               child: Text('Invoice'),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.pushNamed(context, '/resellers');
//               },
//               child: Text('Resellers'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
