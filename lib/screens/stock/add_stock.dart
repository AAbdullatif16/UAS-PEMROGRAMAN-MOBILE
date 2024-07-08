import 'package:flutter/material.dart';
import 'package:toko_pakaian_cyberpunk/services/api_service.dart';
import 'package:toko_pakaian_cyberpunk/models/stock.dart';
import 'package:toko_pakaian_cyberpunk/models/product.dart';

class AddStockScreen extends StatefulWidget {
  @override
  _AddStockScreenState createState() => _AddStockScreenState();
}

class _AddStockScreenState extends State<AddStockScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _qtyController = TextEditingController();
  final ApiService apiService = ApiService();

  List<Product> _products = [];
  Product? _selectedProduct;
  num _qty = 0;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    try {
      List<Product> products = await apiService.getProducts();
      setState(() {
        _products = products;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load products: $e')),
      );
    }
  }

  void _onProductChanged(Product? product) {
    setState(() {
      _selectedProduct = product;
      _qty = 0; // Reset qty when a new product is selected
    });
  }

  Future<void> _addStock(Stock stock) async {
    try {
      await apiService.addStock(stock);
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Stock added successfully')),
      // );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add stock: $e')),
      );
    }
  }

  Future<void> _updateProductQty(Product product) async {
    try {
      await apiService.updateProduct(product);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Stock product berhasil ditambahkan')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update product quantity: $e')),
      );
    }
  }

  @override
  void dispose() {
    _qtyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Stock',style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<Product>(
                items: _products.map((Product product) {
                  return DropdownMenuItem<Product>(
                    value: product,
                    child: Text(product.name),
                  );
                }).toList(),
                onChanged: _onProductChanged,
                decoration: InputDecoration(
                  labelText: 'Select Product',
                ),
                validator: (value) =>
                    value == null ? 'Please select a product' : null,
              ),
              if (_selectedProduct != null) ...[
                TextFormField(
                  initialValue: _selectedProduct!.attr,
                  readOnly: true,
                  decoration: InputDecoration(labelText: 'Attribute'),
                ),
                TextFormField(
                  initialValue: _selectedProduct!.weight.toString(),
                  readOnly: true,
                  decoration: InputDecoration(labelText: 'Weight'),
                ),
                TextFormField(
                  controller: _qtyController,
                  decoration: InputDecoration(labelText: 'Quantity'),
                  keyboardType: TextInputType.number,
                ),
              ],
              SizedBox(height: 20),
              GestureDetector(
                onTap: () async {
                  if (_formKey.currentState!.validate()) {
                    if (_selectedProduct != null) {
                      Stock newStock = Stock(
                        qty: num.parse(_qtyController.text),
                        issuer: _selectedProduct!.issuer,
                        attr: _selectedProduct!.attr,
                        name: _selectedProduct!.name+ '(+)',
                        weight: _selectedProduct!.weight,
                      );

                      await _addStock(newStock);
                      num updatedQty = _selectedProduct!.qty +
                          num.parse(_qtyController.text);
                      Product updateProd = Product(
                        id: _selectedProduct!.id,
                        qty: updatedQty,
                        issuer: _selectedProduct!.issuer,
                        attr: _selectedProduct!.attr,
                        name: _selectedProduct!.name,
                        weight: _selectedProduct!.weight,
                        price: _selectedProduct!.price,
                      );

                      await _updateProductQty(updateProd);

                      Navigator.pop(context);
                    }
                  }
                },
                child: Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      'Tambah stock',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
