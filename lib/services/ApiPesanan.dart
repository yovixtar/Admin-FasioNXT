import 'dart:convert';

import 'package:admin_fasionxt/config.dart';
import 'package:admin_fasionxt/models/pesanan.dart';
import 'package:http/http.dart' as http;

class APIPesananService {
  String baseUrl = Config.baseUrl;

  Future<List<Pesanan>> getAllPesanan() async {
    var response = await http.get(
      Uri.parse("$baseUrl/pesanan"),
    );
    var responseData = jsonDecode(response.body);
    print(responseData);
    if (responseData['code'] == 200) {
      var data = responseData['data'] as List;
      List<Pesanan> pesanans =
          data.map((pesanan) => Pesanan.fromJson(pesanan)).toList();
      return pesanans;
    } else {
      return [];
    }
  }

  Future<Map<String, dynamic>> kirimPesanan({
    required String id_pesanan,
  }) async {
    try {
      var response = await http.post(
        Uri.parse("$baseUrl/pesanan/kirim"),
        body: {'id_pesanan': id_pesanan},
      );

      var responseData = jsonDecode(response.body);
      if (responseData['code'] == 200) {
        return {'success': "${responseData['message']}"};
      } else {
        return {'error': "Terjadi kendala, mohon tunggu sebentar lagi !"};
      }
    } catch (e) {
      return {'error': "Terjadi kesalahan: $e"};
    }
  }

  Future<Map<String, dynamic>> selesaiPesanan({
    required String id_pesanan,
  }) async {
    try {
      var response = await http.post(
        Uri.parse("$baseUrl/pesanan/selesai"),
        body: {'id_pesanan': id_pesanan},
      );

      var responseData = jsonDecode(response.body);
      if (responseData['code'] == 200) {
        return {'success': "${responseData['message']}"};
      } else {
        return {'error': "Terjadi kendala, mohon tunggu sebentar lagi !"};
      }
    } catch (e) {
      return {'error': "Terjadi kesalahan: $e"};
    }
  }
}
