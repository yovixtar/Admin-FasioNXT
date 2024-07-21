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
        Navigator.of(context).pop();
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.produk == null ? 'Tambah Produk' : 'Update Produk'),
      ),
      body: FutureBuilder<List<Kategori>>(
        future: _fetchKategoris(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
                child: Text('Terjadi kesalahan saat memuat data kategori.'));
          }

          var kategoris = snapshot.data ?? [];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  widget.produk == null || _selectedImage != null
                      ? _selectedImage != null
                          ? Stack(
                              children: [
                                Image.file(_selectedImage!),
                                Positioned(
                                  right: 10,
                                  bottom: 10,
                                  child: IconButton(
                                    style: IconButton.styleFrom(
                                        backgroundColor: purplePrimary,
                                        padding: EdgeInsets.all(10)),
                                    icon: Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                    ),
                                    onPressed: () => _showImagePicker(context),
                                  ),
                                ),
                              ],
                            )
                          : ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: purplePrimary,
                              ),
                              onPressed: () => _showImagePicker(context),
                              child: Text('Ambil Foto',
                                  style: TextStyle(
                                    color: Colors.white,
                                  )),
                            )
                      : Column(
                          children: [
                            Image.network(widget.produk!.gambar),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: purplePrimary,
                                    ),
                                    onPressed: () => _showImagePicker(context),
                                    child: Text('Ambil Foto',
                                        style: TextStyle(
                                          color: Colors.white,
                                        )),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                  SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    controller: _namaController,
                    decoration: InputDecoration(labelText: 'Nama Produk'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nama produk tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _deskripsiController,
                    decoration: InputDecoration(labelText: 'Deskripsi Produk'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Deskripsi produk tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _hargaController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Harga Produk'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Harga produk tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _stokController,
                    decoration: InputDecoration(labelText: 'Stok Produk'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Stok produk tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _ukuranController,
                    decoration: InputDecoration(labelText: 'Ukuran Produk'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ukuran produk tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  DropdownButtonFormField<String>(
                    value: _selectedKategoriId,
                    items: kategoris.map((kategori) {
                      return DropdownMenuItem<String>(
                        value: kategori.id,
                        child: Text(kategori.nama),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedKategoriId = value;
                      });
                    },
                    decoration: InputDecoration(labelText: 'Kategori Produk'),
                    validator: (value) {
                      if (value == null) {
                        return 'Kategori produk harus dipilih';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: purplePrimary,
                    ),
                    onPressed: _submitForm,
                    child: Text(
                      widget.produk == null ? 'Tambah Produk' : 'Update Produk',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showImagePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.camera_alt),
            title: Text('Potret Foto'),
            onTap: () {
              Navigator.pop(context);
              _pickImage(ImageSource.camera);
            },
          ),
          ListTile(
            leading: Icon(Icons.photo_library),
            title: Text('Ambil dari Galeri'),
            onTap: () {
              Navigator.pop(context);
              _pickImage(ImageSource.gallery);
            },
          ),
          ListTile(
            leading: Icon(Icons.close),
            title: Text('Batal'),
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
