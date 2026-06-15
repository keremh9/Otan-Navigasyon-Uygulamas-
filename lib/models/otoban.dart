class Otoban {
  final int id;
  // 🎯 HATA ÇÖZÜMÜ: Arayüzün aradığı isim olan 'otobanAdi' olarak güncelledik
  final String otobanAdi; 

  Otoban({
    required this.id,
    required this.otobanAdi,
  });

  factory Otoban.fromMap(Map<String, dynamic> map) {
    return Otoban(
      id: map['id'] ?? 0,
      // Veritabanından gelen veriyi güvenle eşleştiriyoruz
      otobanAdi: map['otobanAdi'] ?? map['ad'] ?? 'Bilinmeyen Otoyol',
    );
  }
}