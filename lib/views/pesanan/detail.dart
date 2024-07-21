import 'package:admin_fasionxt/models/pesanan.dart';
import 'package:admin_fasionxt/services/ApiPesanan.dart';
import 'package:admin_fasionxt/views/colors.dart';
import 'package:admin_fasionxt/views/layout_menu.dart';
import 'package:admin_fasionxt/views/pesanan/list.dart';
import 'package:admin_fasionxt/views/utils/format_utils.dart';
import 'package:admin_fasionxt/views/utils/snackbar_utils.dart';
import 'package:flutter/material.dart';

class OrderDetailPage extends StatefulWidget {
  final Pesanan pesanan;

  OrderDetailPage({required this.pesanan});
  @override
  _OrderDetailPageState createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  bool isLoading = false;

  handleKirimPesanan() async {
    setState(() {
      isLoading = true;
    });
    final result = await APIPesananService().kirimPesanan(
      id_pesanan: widget.pesanan.idPesanan,
    );
    if (result.containsKey('success')) {
      SnackbarUtils.showSuccessSnackbar(context, result['success']);
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => LayoutMenu(
            toPage: 2,
          ),
        ),
      );
    } else {
      setState(() {
        SnackbarUtils.showErrorSnackbar(context, result['error']);
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  handleSelesaiPesanan() async {
    setState(() {
      isLoading = true;
    });
    final result = await APIPesananService().selesaiPesanan(
      id_pesanan: widget.pesanan.idPesanan,
    );
    if (result.containsKey('success')) {
      SnackbarUtils.showSuccessSnackbar(context, result['success']);
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => LayoutMenu(
            toPage: 2,
          ),
        ),
      );
    } else {
      setState(() {
        SnackbarUtils.showErrorSnackbar(context, result['error']);
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgBlue,
      appBar: AppBar(
        backgroundColor: bgBlue,
        title: Text('Detail Pesanan'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pesanan #${widget.pesanan.idPesanan}',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(
                  '${widget.pesanan.items.length} item - Rp ' +
                      widget.pesanan.total.replaceAllMapped(
                          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                          (Match m) => '${m[1]}.'),
                  style: TextStyle(fontSize: 20)),
              SizedBox(height: 16),
              Divider(),
              ListTile(
                leading: Icon(Icons.local_shipping),
                title: widget.pesanan.status.toLowerCase() == 'dikemas'
                    ? Text('Status: Packing, Menunggu dikirim')
                    : Text('Status: Dikirim, Dalam perjalanan'),
                subtitle: ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: purplePrimary),
                  onPressed: () {
                    isLoading
                        ? null
                        : (widget.pesanan.status.toLowerCase() == 'dikemas')
                            ? handleKirimPesanan()
                            : handleSelesaiPesanan();
                  },
                  child: (isLoading)
                      ? CircularProgressIndicator()
                      : Text(
                          (widget.pesanan.status.toLowerCase() == 'dikemas')
                              ? 'Kirim Pesanan'
                              : 'Selesaikan Pesanan',
                          style: TextStyle(color: Colors.white),
                        ),
                ),
              ),
              Divider(),
              Text(
                'Catatan Transaksi:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                widget.pesanan.catatan,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 16),
              Text('Informasi Kustomer:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Table(
                columnWidths: {
                  0: FlexColumnWidth(2),
                  1: FlexColumnWidth(3),
                },
                children: [
                  _buildTableRow('Nama:', widget.pesanan.namaPengguna),
                  _buildTableRow('Alamat:', widget.pesanan.alamat),
                  _buildTableRow('Tanggal:',
                      FormatUtils.formatTimestamp(widget.pesanan.tanggal)),
                  _buildTableRow('Metode Pembayaran:',
                      widget.pesanan.metodePembayaran.toUpperCase()),
                ],
              ),
              SizedBox(height: 16),
              Text('Informasi Produk:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              ...widget.pesanan.items.map((produk) {
                return _buildProductCard(produk.namaProduk, produk.gambar,
                    produk.jumlah, produk.harga);
              }),
              SizedBox(height: 16),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text(
                      'Rp ' +
                          widget.pesanan.total.replaceAllMapped(
                              RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                              (Match m) => '${m[1]}.'),
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  TableRow _buildTableRow(String label, String value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            label,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            value,
            style: TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildProductCard(
      String name, String imagePath, String quantity, String price) {
    return Card(
      color: bgGrey,
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Image.network(
              imagePath,
              height: 50,
              width: 50,
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '$quantity x Rp ${price.toString()}',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            Text(
              'Rp ' +
                  (int.parse(quantity) * int.parse(price))
                      .toString()
                      .replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                          (Match m) => '${m[1]}.'),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
