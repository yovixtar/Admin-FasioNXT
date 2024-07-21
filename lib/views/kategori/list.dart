import 'package:admin_fasionxt/services/ApiKategori.dart';
import 'package:admin_fasionxt/views/colors.dart';
import 'package:admin_fasionxt/views/kategori/form.dart';
import 'package:admin_fasionxt/views/layout_menu.dart';
import 'package:admin_fasionxt/views/utils/snackbar_utils.dart';
import 'package:flutter/material.dart';
import 'package:admin_fasionxt/models/kategori.dart';

class DaftarKategori extends StatefulWidget {
  @override
  _DaftarKategoriState createState() => _DaftarKategoriState();
}

class _DaftarKategoriState extends State<DaftarKategori> {
  late Future<List<Kategori>> _kategoriFuture;
  final APIKategoriService _apiService = APIKategoriService();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _kategoriFuture = _apiService.list();
  }

  void _showDeleteConfirmationDialog(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Konfirmasi Hapus'),
        content: Text('Apakah Anda yakin ingin menghapus kategori ini?'),
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
                              _kategoriFuture = _apiService.list();
                            });
                            SnackbarUtils.showSuccessSnackbar(
                                context, result['success']);
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => LayoutMenu(
                                  toPage: 0,
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
      backgroundColor: bgBlue,
      appBar: AppBar(
        backgroundColor: bgBlue,
        title: Text('Daftar Kategori'),
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<List<Kategori>>(
        future: _kategoriFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Terjadi kesalahan'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Tidak ada data kategori'));
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final kategori = snapshot.data![index];
              return Card(
                elevation: 5,
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  title: Text(
                    kategori.nama,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: purplePrimary,
                    ),
                  ),
                  subtitle: Text("ID ${kategori.id}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  FormKategori(kategori: kategori),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () =>
                            _showDeleteConfirmationDialog(kategori.id),
                      ),
                    ],
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
              builder: (context) => FormKategori(),
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
