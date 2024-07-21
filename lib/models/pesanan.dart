class PesananItem {
  String namaProduk;
  String gambar;
  String harga;
  String jumlah;
  String total;

  PesananItem({
    required this.namaProduk,
    required this.gambar,
    required this.harga,
    required this.jumlah,
    required this.total,
  });

  factory PesananItem.fromJson(Map<String, dynamic> json) {
    return PesananItem(
      namaProduk: json['nama_produk'] as String,
      gambar: json['gambar'] as String,
      harga: json['harga'] as String,
      jumlah: json['jumlah'] as String,
      total: json['total'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nama_produk': namaProduk,
      'gambar': gambar,
      'harga': harga,
      'jumlah': jumlah,
      'total': total,
    };
  }
}

class Pesanan {
  String namaPengguna;
  String idPesanan;
  String alamat;
  String status;
  String tanggal;
  String metodePembayaran;
  String total;
  String catatan;
  List<PesananItem> items;

  Pesanan({
    required this.namaPengguna,
    required this.idPesanan,
    required this.alamat,
    required this.status,
    required this.tanggal,
    required this.metodePembayaran,
    required this.total,
    required this.catatan,
    required this.items,
  });

  factory Pesanan.fromJson(Map<String, dynamic> json) {
    var list = json['items'] as List;
    List<PesananItem> itemsList =
        list.map((i) => PesananItem.fromJson(i)).toList();

    return Pesanan(
      namaPengguna: json['nama_pengguna'] as String,
      idPesanan: json['id_pesanan'] as String,
      alamat: json['alamat'] as String,
      status: json['status'] as String,
      tanggal: json['tanggal'] as String,
      metodePembayaran: json['metode_pembayaran'] as String,
      total: json['total'] as String,
      catatan: json['catatan'] as String,
      items: itemsList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nama_pengguna': namaPengguna,
      'id_pesanan': idPesanan,
      'alamat': alamat,
      'status': status,
      'tanggal': tanggal,
      'metode_pembayaran': metodePembayaran,
      'total': total,
      'catatan': catatan,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}
