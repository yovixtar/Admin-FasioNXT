import 'package:admin_fasionxt/services/ApiKategori.dart';
import 'package:admin_fasionxt/views/colors.dart';
import 'package:admin_fasionxt/views/layout_menu.dart';
import 'package:admin_fasionxt/views/utils/snackbar_utils.dart';
import 'package:flutter/material.dart';
import 'package:admin_fasionxt/models/kategori.dart';

class FormKategori extends StatefulWidget {
  final Kategori? kategori;

  FormKategori({this.kategori});

  @override
  _FormKategoriState createState() => _FormKategoriState();
}

class _FormKategoriState extends State<FormKategori> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final APIKategoriService _apiService = APIKategoriService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.kategori != null) {
      _namaController.text = widget.kategori!.nama;
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isLoading = true;
    });
    Map<String, dynamic> result;
    if (widget.kategori == null) {
      result = await _apiService.create(nama: _namaController.text);
    } else {
      result = await _apiService.update(
          id: widget.kategori!.id, nama: _namaController.text);
    }
    if (result['success'] != null) {
      Navigator.pop(context);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => LayoutMenu(
            toPage: 0,
          ),
        ),
      );
      SnackbarUtils.showSuccessSnackbar(context, result['success']);
    } else {
      SnackbarUtils.showErrorSnackbar(context, result['error']);
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgBlue,
      appBar: AppBar(
        backgroundColor: bgBlue,
        title: Text(
            widget.kategori == null ? 'Tambah Kategori' : 'Update Kategori'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _namaController,
                decoration: InputDecoration(
                  labelText: 'Nama Kategori',
                  labelStyle: TextStyle(
                    color: purplePrimary,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: purplePrimary,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama kategori tidak boleh kosong';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: purplePrimary,
                        padding:
                            EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _submit,
                      child: Text(
                        widget.kategori == null
                            ? 'Tambah Kategori'
                            : 'Update Kategori',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
