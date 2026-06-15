class Istasyon {
  final int? id;
  final int otobanId;
  final String istasyonAdi;
  final int kmBilgisi;
  final double benzinFiyati;
  final double motorinFiyati;
  final double lpgFiyati;
  final String restoranlar; 
  final String magazalar;   
  final String sarjIstasyonlari;

  Istasyon({
    this.id,
    required this.otobanId,
    required this.istasyonAdi,
    required this.kmBilgisi,
    required this.benzinFiyati,
    required this.motorinFiyati,
    required this.lpgFiyati,
    this.restoranlar = "",
    this.magazalar = "",
    this.sarjIstasyonlari = "",
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'otobanId': otobanId,
      'istasyonAdi': istasyonAdi,
      'kmBilgisi': kmBilgisi,
      'benzinFiyati': benzinFiyati,
      'motorinFiyati': motorinFiyati,
      'lpgFiyati': lpgFiyati,
      'restoranlar': restoranlar,
      'magazalar': magazalar,
      'sarjIstasyonlari': sarjIstasyonlari,
    };
  }

  factory Istasyon.fromMap(Map<String, dynamic> map) {
    return Istasyon(
      id: map['id'],
      otobanId: map['otobanId'],
      istasyonAdi: map['istasyonAdi'],
      kmBilgisi: map['kmBilgisi'],
      // 🎯 HATA ÇÖZÜMÜ: SQLite'tan gelen veri int olsa bile zorla double'a çeviriyoruz
      benzinFiyati: (map['benzinFiyati'] ?? 0).toDouble(),
      motorinFiyati: (map['motorinFiyati'] ?? 0).toDouble(),
      lpgFiyati: (map['lpgFiyati'] ?? 0).toDouble(),
      restoranlar: map['restoranlar'] ?? "",
      magazalar: map['magazalar'] ?? "",
      sarjIstasyonlari: map['sarjIstasyonlari'] ?? "",
    );
  }

  // 🎯 HATA ÇÖZÜMÜ: Büyük/küçük harf duyarlılığını kaldırdık, artık fiyatlar sıfır dönmeyecek!
  double fiyatGetir(String yakitTuru) {
    final tur = yakitTuru.trim().toLowerCase();
    if (tur == 'benzin') return benzinFiyati;
    if (tur == 'motorin') return motorinFiyati;
    if (tur == 'lpg') return lpgFiyati;
    return 0.0;
  }
}