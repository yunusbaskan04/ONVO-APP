import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:onvo/utils/models/category.dart';
import 'package:onvo/utils/models/models.dart';
import 'package:onvo/utils/models/product.dart';

class API {
  Future<List<Category>> fetchCategories() async {
    final response = await http.get(
      Uri.parse('http://192.168.1.150/onvo/getCategories.php'),
    );

    if (response.statusCode == 200) {
      final body = utf8.decode(response.bodyBytes);
      final Map<String, dynamic> jsonData = json.decode(body);
      final List<dynamic> categoryList = jsonData["data"];
      return categoryList.map((item) => Category.fromJson(item)).toList();
    } else {
      throw Exception('Veri alınamadı');
    }
  }

  Future<List<Models>> fetchModels(int id) async {
    final response = await http.get(
      Uri.parse("http://192.168.1.150/onvo/categorieToModels.php?id=$id"),
    );

    if (response.statusCode == 200) {
      final body = utf8.decode(response.bodyBytes);
      final Map<String, dynamic> jsonData = json.decode(body);
      final List<dynamic> modelsList = jsonData["data"];
      return modelsList.map((item) => Models.fromJson(item)).toList();
    } else {
      throw Exception("Veri alınamadı");
    }
  }

  Future<List<Product>> fetchProductFromModelId(int id) async {
    final response = await http.get(
      Uri.parse("http://192.168.1.150/onvo/modelToName.php?id=$id"),
    );

    if (response.statusCode == 200) {
      final body = utf8.decode(response.bodyBytes);
      final Map<String, dynamic> jsonData = json.decode(body);
      final List<dynamic> productList = jsonData["data"];
      return productList.map((item) => Product.fromJson(item)).toList();
    } else {
      throw Exception("Veri alınamadı");
    }
  }

  Future<List<Product>> fetchProductNameFromCategoryId(int id) async {
    final response = await http.get(
      Uri.parse("http://192.168.1.150/onvo/categoryToName.php?id=$id"),
    );

    if (response.statusCode == 200) {
      final body = utf8.decode(response.bodyBytes);
      final Map<String, dynamic> jsonData = json.decode(body);
      final List<dynamic> productList = jsonData["data"];
      return productList.map((e) => Product.fromJson(e)).toList();
    } else {
      throw Exception("Veri alınamdı");
    }
  }

  Future<List<Product>> fetchProduct(int id) async {
    final response = await http.get(
      Uri.parse("http://192.168.1.150/onvo/products.php?id=$id"),
    );

    if (response.statusCode == 200) {
      final body = utf8.decode(response.bodyBytes);
      final Map<String, dynamic> jsonData = json.decode(body);
      final List<dynamic> productList = jsonData["data"];
      return productList.map((e) => Product.fromJson(e)).toList();
    } else {
      throw Exception("Veri alınamdı");
    }
  }
}
