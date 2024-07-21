import 'dart:io';
import 'package:admin_fasionxt/models/kategori.dart';
import 'package:admin_fasionxt/models/produk.dart';
import 'package:admin_fasionxt/services/ApiKategori.dart';
import 'package:admin_fasionxt/services/ApiProduk.dart';
import 'package:admin_fasionxt/views/colors.dart';
import 'package:admin_fasionxt/views/layout_menu.dart';
import 'package:admin_fasionxt/views/utils/snackbar_utils.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProdukFormPage extends StatefulWidget {
  final Produk? produk;

  const ProdukFormPage({Key? key, this.produk}) : super(key: key);

  @override
  _ProdukFormPageState createState() => _ProdukFormPageState();
}

class _ProdukFormPageState extends State<ProdukFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _deskripsiController = TextEditingController();
  final _hargaController = TextEditingController();
  final _stokController = TextEditingController();
  final _ukuranController = TextEditingController();
  String? _selectedKategoriId;
  File? _selectedImage = null;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (widget.produk != null) {
      _namaController.text = widget.produk!.nama;
      _deskripsiController.text = widget.produk!.deskripsi;
      _hargaController.text = widget.produk!.harga;
      _stokController.text = widget.produk!.stok;
      _ukuranController.text = widget.produk!.ukuran;
      _selectedKategoriId = widget.produk!.idKategori;
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<List<Kategori>> _fetchKategoris() async {
    var apiService = APIKategoriService();
    return await apiService.list();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (widget.produk == null && _selectedImage == null) {
        SnackbarUtils.showErrorSnackbar(
            context, 'Gambar produk harus dipilih.');
        return;
      }

      var apiProdukService = APIProdukService();
      var result;

      if (widget.produk == null) {
        result = await apiProdukService.createProduk(
          nama: _namaController.text,
          deskripsi: _deskripsiController.text,
          harga: _hargaController.text,
          idKategori: _selectedKategoriId!,
          stok: _stokController.text,
          ukuran: _ukuranController.text,
          gambar: _selectedImage!,
        );
      } else {
        result = await apiProdukService.updateProduk(
          id: widget.produk!.id,
          nama: _namaController.text,
          deskripsi: _deskripsiController.text,
          harga: _hargaController.text,
          idKategori: _selectedKategoriId!,
          stok: _stokController.text,
          ukuran: _ukuranController.text,
          gambar: _selectedImage,
        );
      }

      if (result['success'] != null) {
        SnackbarUtils.showSuccessSnackbar(context, result['success']);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => LayoutMenu(
              toPage: 1,
            ),
          ),
        );
      } else {
        SnackbarUtils.showErrorSnackbar(context, result['error']);
      }
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _deskripsiController.dispose();
    _hargaController.dispose();
    _stokController.dispose();
    _ukuranController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgLightRed,
      appBar: AppBar(
        backgroundColor: bgLightRed,
        title: Text(widget.produk == null ? 'Tambah Produk' : 'Edit Produk'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _namaController,
                decoration: InputDecoration(
                  labelText: 'Nama Produk',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Nama Produk harus diisi';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _deskripsiController,
                decoration: InputDecoration(
                  labelText: 'Deskripsi Produk',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Deskripsi Produk harus diisi';
                  }
                  return null;
                },
                maxLines: 3,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _hargaController,
                decoration: InputDecoration(
                  labelText: 'Harga Produk',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Harga Produk harus diisi';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _stokController,
                decoration: InputDecoration(
                  labelText: 'Stok Produk',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Stok Produk harus diisi';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _ukuranController,
                decoration: InputDecoration(
                  labelText: 'Ukuran Produk',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Ukuran Produk harus diisi';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              FutureBuilder<List<Kategori>>(
                future: _fetchKategoris(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Terjadi kesalahan');
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Text('Tidak ada kategori tersedia');
                  }
                  return DropdownButtonFormField<String>(
                    value: _selectedKategoriId,
                    decoration: InputDecoration(
                      labelText: 'Kategori',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: snapshot.data!
                        .map(
                          (kategori) => DropdownMenuItem<String>(
                            value: kategori.id,
                            child: Text(kategori.nama),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedKategoriId = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Kategori harus dipilih';
                      }
                      return null;
                    },
                  );
                },
              ),
              SizedBox(height: 10),
              Text(
                'Gambar Produk',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 10),
              _selectedImage != null
                  ? Image.file(
                      _selectedImage!,
                      height: 150,
                      width: 150,
                    )
                  : widget.produk != null && widget.produk!.gambar.isNotEmpty
                      ? Image.network(
                          widget.produk!.gambar,
                          height: 150,
                          width: 150,
                        )
                      : Container(
                          height: 150,
                          width: 150,
                          color: Colors.grey[300],
                          child: Icon(Icons.image, size: 50),
                        ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: purplePrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () => _pickImage(ImageSource.gallery),
                    icon: Icon(
                      Icons.image,
                      color: Colors.white,
                    ),
                    label: Text(
                      'Dari Galeri',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: purplePrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () => _pickImage(ImageSource.camera),
                    icon: Icon(
                      Icons.camera,
                      color: Colors.white,
                    ),
                    label: Text(
                      'Dari Kamera',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: purplePrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: _submitForm,
                child: Text(
                  'Simpan',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
