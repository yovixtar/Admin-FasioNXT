class Kategori {
  final String id;
  final String nama;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;

  Kategori({
    required this.id,
    required this.nama,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory Kategori.fromJson(Map<String, dynamic> json) {
    return Kategori(
      id: json['id'],
      nama: json['nama'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      deletedAt: json['deleted_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
    };
  }
}
