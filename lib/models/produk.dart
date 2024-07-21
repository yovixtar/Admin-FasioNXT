class Produk {
  final String id;
  final String nama;
  final String gambar;
  final String harga;
  final String deskripsi;
  final String idKategori;
  final String stok;
  final String ukuran;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;

  Produk({
    required this.id,
    required this.nama,
    required this.gambar,
    required this.harga,
    required this.deskripsi,
    required this.idKategori,
    required this.stok,
    required this.ukuran,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory Produk.fromJson(Map<String, dynamic> json) {
    return Produk(
      id: json['id'],
      nama: json['nama'],
      gambar: json['gambar'],
      harga: json['harga'],
      deskripsi: json['deskripsi'],
      idKategori: json['id_kategori'],
      stok: json['stok'],
      ukuran: json['ukuran'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      deletedAt: json['deleted_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'gambar': gambar,
      'harga': harga,
      'deskripsi': deskripsi,
      'id_kategori': idKategori,
      'stok': stok,
      'ukuran': ukuran,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
    };
  }
}

class ProdukHome {
  final Produk produk;
  final bool isFavorit;

  ProdukHome({
    required this.produk,
    required this.isFavorit,
  });

  factory ProdukHome.fromJson(Map<String, dynamic> json) {
    return ProdukHome(
      produk: Produk.fromJson(json['produk']),
      isFavorit: json['isFavorit'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'produk': produk.toJson(),
      'isFavorit': isFavorit,
    };
  }
}
