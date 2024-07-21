import 'dart:convert';

import 'package:admin_fasionxt/config.dart';
import 'package:admin_fasionxt/models/kategori.dart';
import 'package:http/http.dart' as http;

class APIKategoriService {
  String baseUrl = Config.baseUrl;

  Future<List<Kategori>> list() async {
    var response = await http.get(
      Uri.parse("$baseUrl/kategori"),
    );
    var responseData = jsonDecode(response.body);
    if (responseData['code'] == 200) {
      var data = responseData['data'] as List;
      List<Kategori> kategories =
          data.map((kategori) => Kategori.fromJson(kategori)).toList();
      return kategories;
    } else {
      return [];
    }
  }

  Future<Map<String, dynamic>> create({String? nama}) async {
    var response = await http.post(
      Uri.parse("$baseUrl/kategori/create"),
      body: {
        'nama': nama,
      },
    );
    var responseData = jsonDecode(response.body);
    if (responseData['code'] == 201) {
      return {'success': "${responseData['message']}"};
    } else {
      return {'error': "Terjadi kendala, mohon tunggu sebentar lagi !"};
    }
  }

  Future<Map<String, dynamic>> update({String? id, String? nama}) async {
    var response = await http.post(
      Uri.parse("$baseUrl/kategori/update"),
      body: {
        'id': id,
        'nama': nama,
      },
    );
    var responseData = jsonDecode(response.body);
    if (responseData['code'] == 200) {
      return {'success': "${responseData['message']}"};
    } else {
      return {'error': "Terjadi kendala, mohon tunggu sebentar lagi !"};
    }
  }

  Future<Map<String, dynamic>> delete({String? id}) async {
    var response = await http.delete(
      Uri.parse("$baseUrl/kategori/$id"),
    );
    var responseData = jsonDecode(response.body);
    print(responseData);
    if (responseData['code'] == 200) {
      return {'success': "${responseData['message']}"};
    } else {
      return {'error': "Terjadi kendala, mohon tunggu sebentar lagi !"};
    }
  }
}
