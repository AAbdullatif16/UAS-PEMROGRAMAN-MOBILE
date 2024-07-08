import 'package:flutter/material.dart';
import 'package:toko_pakaian_cyberpunk/models/stock.dart';
import 'package:toko_pakaian_cyberpunk/services/api_service.dart';

class UpdateStockScreen extends StatefulWidget {
  final Stock stock;

  UpdateStockScreen({required this.stock});

  @override
  _UpdateStockScreenState createState() => _UpdateStockScreenState();
}

class _UpdateStockScreenState extends State<UpdateStockScreen> {
  final ApiService apiService = ApiService();

  void _deleteStock() async {
    if (widget.stock.id != null) {
      try {
        await apiService.deleteStock('${widget.stock.id}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Stock deleted successfully')),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete stock: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Stock ID is null, cannot delete')),
      );
    }
  }

  Future<void> _showDeleteConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Yakin ingin menghapus history ini?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Hapus'),
              onPressed: () async {
                Navigator.of(context).pop();
                _deleteStock();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Detail history Stock',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: Icon(Icons.delete,color: Colors.white,),
            onPressed: _showDeleteConfirmationDialog,
          ),
        ],
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            ListTile(
              title: Text('Nama Produk'),
              subtitle: Text(widget.stock.name.toString()),
            ),
            ListTile(
              title: Text('Jumlah'),
              subtitle: Text(widget.stock.qty.toString()),
            ),
            ListTile(
              title: Text('Atribut'),
              subtitle: Text(widget.stock.attr.toString()),
            ),
            ListTile(
              title: Text('Ukuran'),
              subtitle: Text(widget.stock.weight.toString()),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
