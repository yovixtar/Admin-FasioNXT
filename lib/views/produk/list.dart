import 'package:admin_fasionxt/models/produk.dart';
import 'package:admin_fasionxt/services/ApiProduk.dart';
import 'package:admin_fasionxt/views/colors.dart';
import 'package:admin_fasionxt/views/layout_menu.dart';
import 'package:admin_fasionxt/views/produk/form.dart';
import 'package:admin_fasionxt/views/utils/snackbar_utils.dart';
import 'package:flutter/material.dart';

class DaftarProduk extends StatefulWidget {
  @override
  _DaftarProdukState createState() => _DaftarProdukState();
}

class _DaftarProdukState extends State<DaftarProduk> {
  late Future<List<Produk>> _produkFuture;
  final APIProdukService _apiService = APIProdukService();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _produkFuture = _apiService.list();
  }

  void _showProductDetail(Produk produk) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  produk.nama,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: purplePrimary,
                  ),
                ),
                SizedBox(height: 10),
                if (produk.gambar.isNotEmpty)
                  Image.network(
                    produk.gambar,
                    height: 150,
                    width: 150,
                  ),
                SizedBox(height: 10),
                Text("ID: ${produk.id}"),
                SizedBox(height: 10),
                Text(
                  "Deskripsi: ${produk.deskripsi}",
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Text(
                  "Harga: Rp " +
                      produk.harga.replaceAllMapped(
                          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                          (Match m) => '${m[1]}.'),
                ),
                SizedBox(height: 10),
                Text("Stok: ${produk.stok}"),
                SizedBox(height: 10),
                Text("Ukuran: ${produk.ukuran}"),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: purplePrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProdukFormPage(produk: produk),
                            ),
                          );
                        },
                        child: Text(
                          'Edit Produk',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Konfirmasi Hapus'),
        content: Text('Apakah Anda yakin ingin menghapus Produk ini?'),
        actions: [
          isLoading
              ? CircularProgressIndicator()
              : TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: danger,
                  ),
                  onPressed: isLoading
                      ? null
                      : () async {
                          setState(() {
                            isLoading = true;
                          });
                          var result = await _apiService.delete(id: id);
                          if (result['success'] != null) {
                            setState(() {
                              _produkFuture = _apiService.list();
                            });
                            SnackbarUtils.showSuccessSnackbar(
                                context, result['success']);
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => LayoutMenu(
                                  toPage: 1,
                                ),
                              ),
                            );
                          } else {
                            SnackbarUtils.showErrorSnackbar(
                                context, result['error']);
                          }

                          setState(() {
                            isLoading = false;
                          });
                        },
                  child: Text(
                    'Hapus',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Batal'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgLightRed,
      appBar: AppBar(
        backgroundColor: bgLightRed,
        title: Text('Daftar Produk'),
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<List<Produk>>(
        future: _produkFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Terjadi kesalahan'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Tidak ada data Produk'));
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final produk = snapshot.data![index];
              return GestureDetector(
                onTap: () => _showProductDetail(produk),
                child: Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        produk.gambar.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  produk.gambar,
                                  height: 60,
                                  width: 60,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : CircleAvatar(
                                backgroundColor: purplePrimary,
                                radius: 30,
                                child: Text(
                                  produk.nama[0].toUpperCase(),
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                produk.nama,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text("ID: ${produk.id}"),
                              Text(
                                "Harga: Rp " +
                                    produk.harga.replaceAllMapped(
                                        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                        (Match m) => '${m[1]}.'),
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.edit, color: purplePrimary),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ProdukFormPage(produk: produk),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () =>
                              _showDeleteConfirmationDialog(produk.id),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: purplePrimary,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProdukFormPage(),
            ),
          );
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
