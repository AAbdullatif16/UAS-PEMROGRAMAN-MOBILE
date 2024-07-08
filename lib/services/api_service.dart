// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:toko_pakaian_cyberpunk/models/image.dart';
import 'package:toko_pakaian_cyberpunk/models/reseller.dart';
import 'package:toko_pakaian_cyberpunk/models/stock.dart';
import 'package:toko_pakaian_cyberpunk/models/product.dart';
import 'package:toko_pakaian_cyberpunk/models/sale.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

import '../models/goods.dart';

class ApiService {
  static const String baseUrl = 'https://api.kartel.dev';

  // Reseller methods
  Future<List<Reseller>> getResellers() async {
    final response = await http.get(Uri.parse('$baseUrl/resellers'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      print(
          jsonResponse.map((reseller) => Reseller.fromJson(reseller)).toList());
      return jsonResponse
          .map((reseller) => Reseller.fromJson(reseller))
          .toList();
    } else {
      throw Exception('Failed to load resellers');
    }
  }

  Future<Reseller> createReseller(Reseller reseller) async {
    final response = await http.post(
      Uri.parse('$baseUrl/resellers'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(reseller.toJson()),
    );

    if (response.statusCode == 201) {
      return Reseller.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create reseller');
    }
  }

  Future<Reseller> updateReseller(String id, Reseller reseller) async {
    final response = await http.put(
      Uri.parse('$baseUrl/resellers/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(reseller.toJson()),
    );

    if (response.statusCode == 200) {
      return Reseller.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update reseller');
    }
  }

  Future<void> deleteReseller(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/resellers/$id'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete reseller');
    }
  }

  Future<List<Product>> getProducts() async {
    final response = await http.get(Uri.parse('$baseUrl/products'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      List<Product> product =
          jsonResponse.map((product) => Product.fromJson(product)).toList();

      List<Product> filterProduct =
          product.where((product) => product.issuer == 'ente').toList();
      return filterProduct;
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<Product> getProductById(String productId) async {
    final response = await http.get(Uri.parse('$baseUrl/products/$productId'));

    print(response.body);
    if (response.statusCode == 200) {
      return Product.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load product');
    }
  }

  Future<String> addProduct(Product product) async {
    final response = await http.post(
      Uri.parse('$baseUrl/products'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(product.toJson()),
    );
    print(response.statusCode);
    print(jsonEncode(product.toJson()));
    if (response.statusCode == 201) {
      // Jika respons sukses (status code 201 Created), ambil ID produk dari respons
      final jsonResponse = jsonDecode(response.body);
      final productId = jsonResponse['id'];
      print(productId);
      return productId.toString();
    } else {
      throw Exception('Failed to add product');
    }
  }

  Future<void> updateProduct(Product product) async {
    final response = await http.put(
      Uri.parse('$baseUrl/products/${product.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(product.toJson()),
    );
    print('ini udate produc qty');
    print(response.statusCode);
    print(response.body);
    if (response.statusCode != 200) {
      throw Exception('Failed to update product');
    }
  }

  Future<void> updateProductQty(String productId, num newQty) async {
    final response = await http.put(
      Uri.parse('$baseUrl/products/$productId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'qty': newQty}),
    );

    if (response.statusCode == 200) {
      print('Product qty updated successfully');
    } else {
      throw Exception('Failed to update product qty');
    }
  }

  Future<void> uploadProductImage(String productId, String imagePath) async {
    final mimeTypeData = lookupMimeType(imagePath);
    if (mimeTypeData == null) {
      throw Exception('Invalid file type');
    }

    final List<String> mimeTypeParts = mimeTypeData.split('/');
    if (mimeTypeParts.length != 2) {
      throw Exception('Invalid MIME type');
    }

    final imageUploadRequest = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/products/$productId/image'),
    );

    final file = await http.MultipartFile.fromPath(
      'image',
      imagePath,
      contentType: MediaType(mimeTypeParts[0], mimeTypeParts[1]),
    );
    imageUploadRequest.files.add(file);

    try {
      final streamedResponse = await imageUploadRequest.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode != 201) {
        throw Exception('Failed to upload image: ${response.body}');
      }

      // Handle response data if needed
      print('Upload successful! Server response: ${response.body}');
    } catch (e) {
      throw Exception('Error uploading image: $e');
    }
  }

  Future<ImageModel> getProductImage(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/products/$id/image'));

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      ImageModel productImage = ImageModel.fromJson(jsonResponse);

      return productImage;
    } else {
      throw Exception('Failed to load product image');
    }
  }

  Future<void> deleteProduct(String id) async {
    final response = await http.delete(
      Uri.parse('${baseUrl}/products/${id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode != 204) {
      throw Exception('Failed to delete product');
    }
  }

  Future<List<Stock>> getStocks() async {
    final response = await http.get(Uri.parse('$baseUrl/stocks'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      List<Stock> stocks =
          jsonResponse.map((stock) => Stock.fromJson(stock)).toList();

      List<Stock> filterStock =
          stocks.where((stock) => stock.issuer == 'ente').toList();
      return filterStock;
    } else {
      throw Exception('Failed to load stocks');
    }
  }

  Future<Stock> getStock(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/stocks/$id'));

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      Stock stock = Stock.fromJson(jsonResponse);
      return stock;
    } else {
      throw Exception('Failed to load stock');
    }
  }

  Future<void> addStock(Stock stock) async {
    final response = await http.post(
      Uri.parse('$baseUrl/stocks'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(stock.toJson()),
    );
    print('ieu tambah stock');
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 201) {
      print('Stock added successfully');
    } else {
      throw Exception('Failed to add stock');
    }
  }

  Future<void> updateStock(Stock stock) async {
    Map<String, dynamic> stockWithoutId = stock.toJson();
    stockWithoutId.remove('id');
    final response = await http.put(
      Uri.parse('${baseUrl}/stocks/${stock.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(stockWithoutId),
    );

    if (response.statusCode == 200) {
      print('Stock updated successfully');
    } else {
      throw Exception('Failed to update stock');
    }
  }

  Future<void> deleteStock(String id) async {
    final response = await http.delete(
      Uri.parse('${baseUrl}/stocks/${id}'),
    );
    print(response.statusCode);
    if (response.statusCode == 204) {
      print('Stock deleted successfully');
    } else {
      throw Exception('Failed to delete stock');
    }
  }

  Future<List<Sale>> getSales() async {
    final response = await http.get(Uri.parse('$baseUrl/sales'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      List<Sale> sale =
          jsonResponse.map((sale) => Sale.fromJson(sale)).toList();

      List<Sale> filterSale =
          sale.where((sale) => sale.issuer == 'ente').toList();
      return filterSale;
    } else {
      throw Exception('Failed to load sales');
    }
  }

  Future<Sale> getSaleById(String saleId) async {
    final response = await http.get(Uri.parse('$baseUrl/sales/$saleId'));

    if (response.statusCode == 200) {
      return Sale.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load sale');
    }
  }

  Future<Map<String, dynamic>> addSale(Sale sale) async {
    final response = await http.post(
      Uri.parse('$baseUrl/sales'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(sale.toJson()),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to add sale');
    }
  }

  Future<void> updateSale(Sale sale) async {
    Map<String, dynamic> stockWithoutId = sale.toJson();
    stockWithoutId.remove('id');
    final response = await http.put(
      Uri.parse('${baseUrl}/sales/${sale.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(stockWithoutId),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update sale');
    }
  }

  Future<void> deleteSale(String id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/sales/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete sale');
    }
  }

  Future<Map<String, dynamic>> addGoods(Goods goods) async {
    final response = await http.post(
      Uri.parse('$baseUrl/goods'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(goods.toJson()),
    );
    print(response.statusCode);
    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to add goods');
    }
  }

  Future<List<Goods>> getGoods() async {
    final response = await http.get(Uri.parse('$baseUrl/goods'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      List<Goods> goods =
          jsonResponse.map((stock) => Goods.fromJson(stock)).toList();
      List<Goods> filterSale =
          goods.where((good) => good.issuer == 'ente').toList();
      return filterSale;
    } else {
      throw Exception('Failed to load goods');
    }
  }

  Future<void> deleteGoods(String id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/goods/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    print(response.statusCode);
    if (response.statusCode != 204) {
      throw Exception('Failed to delete sale');
    }
  }
}
