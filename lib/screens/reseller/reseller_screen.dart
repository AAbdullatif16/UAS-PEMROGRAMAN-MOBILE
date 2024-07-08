// lib/screens/reseller_screen.dart
import 'package:flutter/material.dart';
import 'package:toko_pakaian_cyberpunk/models/reseller.dart';
import 'package:toko_pakaian_cyberpunk/services/api_service.dart';

class ResellerScreen extends StatefulWidget {
  @override
  _ResellerScreenState createState() => _ResellerScreenState();
}

class _ResellerScreenState extends State<ResellerScreen> {
  late Future<List<Reseller>> _resellers;

  @override
  void initState() {
    super.initState();
    _resellers = ApiService().getResellers();
  }

  void _refreshResellers() {
    setState(() {
      _resellers = ApiService().getResellers();
    });
  }

  void _addReseller() {
    showDialog(
      context: context,
      builder: (context) {
        final nameController = TextEditingController();
        final contactController = TextEditingController();

        return AlertDialog(
          title: Text('Add Reseller'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: contactController,
                decoration: InputDecoration(labelText: 'Contact'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final reseller = Reseller(
                  id: '',
                  name: nameController.text,
                  contact: contactController.text,
                );
                await ApiService().createReseller(reseller);
                _refreshResellers();
                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _editReseller(Reseller reseller) {
    showDialog(
      context: context,
      builder: (context) {
        final nameController = TextEditingController(text: reseller.name);
        final contactController = TextEditingController(text: reseller.contact);

        return AlertDialog(
          title: Text('Edit Reseller'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: contactController,
                decoration: InputDecoration(labelText: 'Contact'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final updatedReseller = Reseller(
                  id: reseller.id,
                  name: nameController.text,
                  contact: contactController.text,
                );
                await ApiService().updateReseller(reseller.id, updatedReseller);
                _refreshResellers();
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _deleteReseller(String id) async {
    await ApiService().deleteReseller(id);
    _refreshResellers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Reseller'),
      ),
      body: FutureBuilder<List<Reseller>>(
        future: _resellers,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Tidak ada reseller yang ditemukan.'));
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              Reseller reseller = snapshot.data![index];
              return ListTile(
                title: Text(reseller.name),
                subtitle: Text('Contact: ${reseller.contact}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () => _editReseller(reseller),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _deleteReseller(reseller.id),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addReseller,
        child: Icon(Icons.add),
      ),
    );
  }
}
