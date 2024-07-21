import 'package:admin_fasionxt/models/pesanan.dart';
import 'package:admin_fasionxt/services/ApiPesanan.dart';
import 'package:admin_fasionxt/views/colors.dart';
import 'package:admin_fasionxt/views/pesanan/item.dart';
import 'package:flutter/material.dart';

class OrderListPage extends StatefulWidget {
  final int toTab;

  OrderListPage({super.key, this.toTab = 0});

  @override
  _OrderListPageState createState() => _OrderListPageState();
}

class _OrderListPageState extends State<OrderListPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: widget.toTab,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgBlue,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: bgBlue,
        title: Text('Order List'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Dikemas'),
            Tab(text: 'Dikirim'),
            Tab(text: 'Selesai'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          OrderItemList(status: 'Dikemas'),
          OrderItemList(status: 'Dikirim'),
          OrderItemList(status: 'Selesai'),
        ],
      ),
    );
  }
}

class OrderItemList extends StatefulWidget {
  final String status;

  OrderItemList({super.key, required this.status});

  @override
  _OrderItemListState createState() => _OrderItemListState();
}

class _OrderItemListState extends State<OrderItemList> {
  late Future<List<Pesanan>> _dataPesanan;

  Future<List<Pesanan>> fetchPesanan() async {
    List<Pesanan> dataPesanan = await APIPesananService().getAllPesanan();
    return dataPesanan;
  }

  @override
  void initState() {
    super.initState();
    _dataPesanan = fetchPesanan();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Pesanan>>(
      future: _dataPesanan,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Pesanan> filteredPesanan = snapshot.data!
              .where((pesanan) =>
                  pesanan.status.toLowerCase() == widget.status.toLowerCase())
              .toList();

          if (filteredPesanan.isEmpty) {
            return Center(
                child:
                    Text('Tidak ada pesanan dengan status ${widget.status}.'));
          }

          return ListView(
            children: filteredPesanan.map((pesanan) {
              return OrderItemCard(
                pesanan: pesanan,
              );
            }).toList(),
          );
        } else if (snapshot.hasError) {
          return Center(
              child: Text('Error fetching orders: ${snapshot.error}'));
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
