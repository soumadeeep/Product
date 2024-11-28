import 'dart:convert';

import 'package:product/data/models/product_model.dart';
import 'package:http/http.dart' as http;

class ProductRepository {
  final String apiUrl = "https://api.escuelajs.co/api/v1/products";
  //fetch the product from the API
  Future<List<Product>> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data
            .map((productJson) => Product.fromJson(productJson))
            .toList();
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }
}
