import 'package:flutter/material.dart';
import 'package:toko_pakaian_cyberpunk/models/sale.dart';
import 'package:toko_pakaian_cyberpunk/services/api_service.dart';

class UpdateSaleScreen extends StatefulWidget {
  final Sale sale;

  UpdateSaleScreen({required this.sale});

  @override
  _UpdateSaleScreenState createState() => _UpdateSaleScreenState();
}

class _UpdateSaleScreenState extends State<UpdateSaleScreen> {
  final _formKey = GlobalKey<FormState>();
  final ApiService apiService = ApiService();
  late TextEditingController _buyerController;
  late TextEditingController _phoneController;
  late TextEditingController _dateController;
  late TextEditingController _statusController;

  @override
  void initState() {
    super.initState();
    _buyerController = TextEditingController(text: widget.sale.buyer);
    _phoneController = TextEditingController(text: widget.sale.phone);
    _dateController = TextEditingController(text: widget.sale.date);
    _statusController = TextEditingController(text: widget.sale.status);
  }

  Future<void> _updateSale() async {
    if (_formKey.currentState!.validate()) {
      Sale updatedSale = Sale(
          id: widget.sale.id,
          buyer: _buyerController.text,
          phone: _phoneController.text,
          date: _dateController.text,
          status: _statusController.text,
          issuer: "ente");
      // print(updatedSale.id);
      try {
        await apiService.updateSale(updatedSale);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sale updated successfully')),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update sale: $e')),
        );
      }
    }
  }

  Future<void> _deleteSale() async {
    try {
      await apiService.deleteSale('${widget.sale.id}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sale deleted successfully')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete sale: $e')),
      );
    }
  }

  Future<void> _showDeleteConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible:
          false, // Prevents closing the dialog by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Yakin ingin menghapus penjualan ini?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop(); // Closes the dialog
              },
            ),
            TextButton(
              child: Text('Hapus'),
              onPressed: () async {
                Navigator.of(context).pop(); // Closes the dialog
                await _deleteSale(); // Calls the delete function
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
        title: Text('Perbarui Penjualan',style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: _showDeleteConfirmationDialog,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
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
                onTap: _updateSale,
                child: Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Text(
                      'Update sale',
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
