import 'package:admin_fasionxt/models/pesanan.dart';
import 'package:admin_fasionxt/views/colors.dart';
import 'package:admin_fasionxt/views/pesanan/detail.dart';
import 'package:admin_fasionxt/views/pesanan/erecipt.dart';
import 'package:admin_fasionxt/views/utils/format_utils.dart';
import 'package:flutter/material.dart';

class OrderItemCard extends StatefulWidget {
  final Pesanan pesanan;

  OrderItemCard({super.key, required this.pesanan});

  @override
  _OrderItemCardState createState() => _OrderItemCardState();
}

class _OrderItemCardState extends State<OrderItemCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pesanan #${widget.pesanan.idPesanan}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
                '${widget.pesanan.items.length} Produk - Rp ' +
                    widget.pesanan.total.replaceAllMapped(
                        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                        (Match m) => '${m[1]}.'),
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16),
                SizedBox(width: 4),
                Text(FormatUtils.formatTanggal(widget.pesanan.tanggal)),
                Spacer(),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    backgroundColor: purplePrimary,
                  ),
                  onPressed: () {
                    // Navigate to detail page
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            (widget.pesanan.status.toLowerCase() != "selesai")
                                ? OrderDetailPage(pesanan: widget.pesanan)
                                : EReceiptPage(
                                    pesanan: widget.pesanan,
                                  ),
                      ),
                    );
                  },
                  child: Text(
                    'View Details',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
