import 'package:flutter/material.dart';
import 'package:toko_pakaian_cyberpunk/models/goods.dart';
import 'package:toko_pakaian_cyberpunk/screens/invoice/invoice_screen.dart';
import 'package:toko_pakaian_cyberpunk/services/api_service.dart';
import 'package:toko_pakaian_cyberpunk/models/stock.dart';
import 'package:toko_pakaian_cyberpunk/models/product.dart';
import 'package:toko_pakaian_cyberpunk/models/sale.dart';

class SubtractStock extends StatefulWidget {
  final Product? initialProduct;

  SubtractStock({this.initialProduct});

  @override
  _SubtractStockState createState() => _SubtractStockState();
}

class _SubtractStockState extends State<SubtractStock> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _qtyController = TextEditingController();
  final TextEditingController _buyerController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();
  final TextEditingController _attrController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final ApiService apiService = ApiService();

  List<Product> _products = [];
  Product? _selectedProduct;
  num _qty = 0;
  String productId = '';
  @override
  void initState() {
    super.initState();
    _fetchProducts();

    if (widget.initialProduct != null) {
      _onProductChanged(widget.initialProduct);
      productId = '${widget.initialProduct?.id}';
    }
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
      _qty = 0;
      _attrController.text = product!.attr;
      _weightController.text = product.weight.toString();
    });
  }

  Future<void> _addStock(Stock stock) async {
    try {
      await apiService.addStock(stock);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add stock: $e')),
      );
    }
  }

  Future<void> _updateProductQty(Product product) async {
    try {
      await apiService.updateProduct(product);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update product quantity: $e')),
      );
    }
  }

  Future<void> _saveSale() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedProduct != null) {
        Stock newStock = Stock(
          qty: num.parse(_qtyController.text),
          issuer: _selectedProduct!.issuer,
          attr: _selectedProduct!.attr,
          name: _selectedProduct!.name + '(-)',
          weight: _selectedProduct!.weight,
        );

        await _addStock(newStock);

        // Update product quantity
        num updatedQty = _selectedProduct!.qty - num.parse(_qtyController.text);
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

        // Add sale
        Sale sale = Sale(
          buyer: _buyerController.text,
          phone: _phoneController.text,
          date: _dateController.text,
          status: _statusController.text,
          issuer: "ente",
        );

        try {
          final ress = await apiService.addSale(sale);
          Goods goods = Goods(
              saleId: ress["id"],
              productId: '${_selectedProduct!.id}',
              qty: num.parse(_qtyController.text),
              issuer: 'ente');
          await apiService.addGoods(goods);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Penjualan berhasil ditambahkan')),
          );

          // Navigasi ke layar Invoice
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  InvoiceScreen(sale: sale, product: updateProd),
            ),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to add sale: $e')),
          );
        }
      }
    }
  }

  @override
  void dispose() {
    _qtyController.dispose();
    _buyerController.dispose();
    _phoneController.dispose();
    _dateController.dispose();
    _statusController.dispose();
    _attrController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kurangi stock',style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              if (widget.initialProduct == null ||
                  _selectedProduct != widget.initialProduct) ...[
                DropdownButtonFormField<Product>(
                  value: _selectedProduct,
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
              ],
              if (_selectedProduct != null) ...[
                TextFormField(
                  controller: _attrController,
                  readOnly: true,
                  decoration: InputDecoration(labelText: 'Attribute'),
                ),
                TextFormField(
                  controller: _weightController,
                  readOnly: true,
                  decoration: InputDecoration(labelText: 'Ukuran'),
                ),
                TextFormField(
                  controller: _qtyController,
                  decoration: InputDecoration(labelText: 'Quantity'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a quantity';
                    }
                    num requestedQty = num.tryParse(value)!;
                    num currentStockQty = _selectedProduct!.qty;

                    if (requestedQty > currentStockQty) {
                      return 'Requested stock exceeds quantity!';
                    }

                    return null; // Return null if validation succeeds
                  },
                ),
              ],
              SizedBox(height: 20),
              TextFormField(
                controller: _buyerController,
                decoration: InputDecoration(labelText: 'Pembeli'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan nama pembeli';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: 'Telepon'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan nomor telepon';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _dateController,
                decoration: InputDecoration(labelText: 'Tanggal'),
                keyboardType: TextInputType.datetime,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan tanggal';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _statusController,
                decoration: InputDecoration(labelText: 'Status'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan status';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: _saveSale,
                child: Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      'Tambahkan penjualan',
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
