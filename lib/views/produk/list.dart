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
      appBar: AppBar(
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
              return ListTile(
                title: Text(produk.nama),
                subtitle: Text("ID ${produk.id}"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
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
                      icon: Icon(Icons.delete),
                      onPressed: () => _showDeleteConfirmationDialog(produk.id),
                    ),
                  ],
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
