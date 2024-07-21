import 'dart:convert';
import 'dart:io';
import 'package:admin_fasionxt/config.dart';
import 'package:admin_fasionxt/models/produk.dart';
import 'package:http/http.dart' as http;

class APIProdukService {
  String baseUrl = Config.baseUrl;

  Future<List<Produk>> list() async {
    var response = await http.get(
      Uri.parse("$baseUrl/produk"),
    );
    var responseData = jsonDecode(response.body);
    if (responseData['code'] == 200) {
      var data = responseData['data'] as List;
      List<Produk> produks =
          data.map((produk) => Produk.fromJson(produk)).toList();
      return produks;
    } else {
      return [];
    }
  }

  Future<Map<String, dynamic>> createProduk({
    required String nama,
    required String deskripsi,
    required String harga,
    required String idKategori,
    required String stok,
    required String ukuran,
    required File gambar,
  }) async {
    var urlAddProduk = Uri.parse("$baseUrl/produk/create");

    var request = http.MultipartRequest('POST', urlAddProduk)
      ..fields['nama'] = nama
      ..fields['deskripsi'] = deskripsi
      ..fields['harga'] = harga
      ..fields['id_kategori'] = idKategori
      ..fields['stok'] = stok
      ..fields['ukuran'] = ukuran
      ..files.add(await http.MultipartFile.fromPath('gambar', gambar.path));

    var response = await request.send();

    if (response.statusCode == 201) {
      var responseBody = await http.Response.fromStream(response);
      var responseData = jsonDecode(responseBody.body);
      return {'success': responseData['message']};
    } else {
      var responseBody = await http.Response.fromStream(response);
      var responseData = jsonDecode(responseBody.body);
      return {
        'error': responseData['message'] ??
            "Terjadi kendala, mohon tunggu sebentar lagi !"
      };
    }
  }

  Future<Map<String, dynamic>> updateProduk({
    required String id,
    required String nama,
    required String deskripsi,
    required String harga,
    required String idKategori,
    required String stok,
    required String ukuran,
    File? gambar,
  }) async {
    var urlUpdateMenu = Uri.parse("$baseUrl/produk/update");

    var request = http.MultipartRequest('POST', urlUpdateMenu)
      ..fields['id'] = id
      ..fields['nama'] = nama
      ..fields['deskripsi'] = deskripsi
      ..fields['harga'] = harga
      ..fields['id_kategori'] = idKategori
      ..fields['stok'] = stok
      ..fields['ukuran'] = ukuran;

    if (gambar != null) {
      request.files
          .add(await http.MultipartFile.fromPath('gambar', gambar.path));
    }

    var response = await request.send();

    if (response.statusCode == 200) {
      var responseBody = await http.Response.fromStream(response);
      var responseData = jsonDecode(responseBody.body);
      return {'success': responseData['message']};
    } else {
      var responseBody = await http.Response.fromStream(response);
      var responseData = jsonDecode(responseBody.body);
      return {
        'error': responseData['message'] ??
            "Terjadi kendala, mohon tunggu sebentar lagi !"
      };
    }
  }

  Future<Map<String, dynamic>> delete({String? id}) async {
    var response = await http.delete(
      Uri.parse("$baseUrl/produk/$id"),
    );
    var responseData = jsonDecode(response.body);
    if (responseData['code'] == 200) {
      return {'success': "${responseData['message']}"};
    } else {
      return {'error': "Terjadi kendala, mohon tunggu sebentar lagi !"};
    }
  }
}
