import 'package:flutter/material.dart';
import '../models/istasyon.dart';
import 'konum_ekrani.dart';

class DetayEkrani extends StatelessWidget {
  final Istasyon istasyon;
  final String otobanAdi;
  final String yakitTuru;

  const DetayEkrani({
    super.key,
    required this.istasyon,
    required this.otobanAdi,
    required this.yakitTuru,
  });

  // Dakikayı saat ve dakikaya kusursuz çeviren orijinal fonksiyonun
  String _sureyiFormatla(int toplamDakika) {
    if (toplamDakika < 60) {
      return '$toplamDakika dk';
    }
    final int saat = toplamDakika ~/ 60;
    final int kalanDakika = toplamDakika % 60;
    
    if (kalanDakika == 0) {
      return '$saat saat';
    }
    return '$saat saat $kalanDakika dk';
  }

  // Dinamik çizgi boyu hesaplayan orijinal algoritman
  double _cizgiBoyuHesapla(int km) {
    double boy = km * 0.5; 
    if (boy < 60) return 60;
    if (boy > 160) return 160; 
    return boy;
  }

  @override
  Widget build(BuildContext context) {
    final double fiyat = istasyon.fiyatGetir(yakitTuru);
    final int hesaplananDakika = ((istasyon.kmBilgisi * 60) / 90).round() + 10; 
    final String formatliSure = _sureyiFormatla(hesaplananDakika);

    // YENİ VERİLERİMİZİ BURADA LİSTEYE ÇEVİRİYORUZ
    List<String> restoranListesi = istasyon.restoranlar.isNotEmpty ? istasyon.restoranlar.split(',') : [];
    List<String> magazaListesi = istasyon.magazalar.isNotEmpty ? istasyon.magazalar.split(',') : [];
    List<String> sarjListesi = istasyon.sarjIstasyonlari.isNotEmpty ? istasyon.sarjIstasyonlari.split(',') : [];

    String meskenBilgisi = 'Otoyol Kenarı Dinlenme Tesisleri ve Yerleşkeler';
    
    try {
      final dinamikIstasyon = istasyon as dynamic;
      if (dinamikIstasyon.cevreDetayi != null) {
        meskenBilgisi = dinamikIstasyon.cevreDetayi;
      }
    } catch (_) {
      final yol = otobanAdi.toLowerCase();
      if (yol.contains('o-21')) {
        meskenBilgisi = 'Toros Dağları Geçişi, Akçatekir Yayla Evleri Sapağı ve Vadi Yapısı';
      } else if (yol.contains('o-4')) {
        meskenBilgisi = 'Bolu Dağı Tüneli Çıkışı, Ormanlık Arazi ve Dağ Tesisleri Şeridi';
      } else if (yol.contains('o-5')) {
        meskenBilgisi = 'Osmangazi Köprüsü Çıkışı, Bursa Zeytinlikleri ve Lojistik Depolar Girişi';
      } else if (yol.contains('o-1') || yol.contains('çevre')) {
        meskenBilgisi = 'Metropol İş Merkezleri, Plaza Alanları ve Sanayi Sitesi Kavşağı';
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          'Navigasyon ve İstasyon Detayı', 
          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)
        ),
        backgroundColor: const Color(0xFF1565C0),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Üst Bilgi Kartı
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              otobanAdi,
                              style: TextStyle(color: Colors.blue.shade800, fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '${istasyon.istasyonAdi} Tesisleri',
                              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
                            ),
                            const Divider(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('${yakitTuru.toUpperCase()} Fiyatı:', style: const TextStyle(fontSize: 15, color: Colors.black54)),
                                Text(
                                  '₺${fiyat.toStringAsFixed(2)}',
                                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // OTOYOLUN ÇEVRESİNDEKİ MESKENLER BÖLÜMÜ
                    Card(
                      elevation: 1,
                      color: Colors.amber.shade50,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.amber.shade200)),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            Icon(Icons.maps_home_work, color: Colors.amber.shade900, size: 24),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Otoyol Çevresi Mesken Yapısı', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black54)),
                                  const SizedBox(height: 2),
                                  Text(meskenBilgisi, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black87)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // 🎯 YENİ: ELEKTRİKLİ ŞARJ, RESTORAN VE MAĞAZALAR BURAYA GELDİ
                    if (sarjListesi.isNotEmpty)
                      _buildTesisBolumu(baslik: 'Elektrikli Araç Şarj Noktaları', ikon: Icons.electric_car_rounded, renk: const Color(0xFF00838F), liste: sarjListesi),
                    if (restoranListesi.isNotEmpty)
                      _buildTesisBolumu(baslik: 'Yeme & İçme Alanları', ikon: Icons.restaurant_rounded, renk: Colors.orange.shade700, liste: restoranListesi),
                    if (magazaListesi.isNotEmpty)
                      _buildTesisBolumu(baslik: 'Alışveriş & Mağazalar', ikon: Icons.storefront_rounded, renk: Colors.blue.shade700, liste: magazaListesi),

                    const SizedBox(height: 15),
                    const Text('YOLCULUK SİMÜLASYONU', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black45, letterSpacing: 1.2)),
                    const SizedBox(height: 15),

                    // DİNAMİK NAVİGASYON ŞERİDİ
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            const CircleAvatar(
                              backgroundColor: Colors.blue,
                              radius: 16,
                              child: Icon(Icons.navigation, color: Colors.white, size: 16),
                            ),
                            Container(
                              width: 4,
                              height: _cizgiBoyuHesapla(istasyon.kmBilgisi),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [Colors.blue, Colors.orange.shade400],
                                ),
                              ),
                            ),
                            CircleAvatar(
                              backgroundColor: Colors.orange.shade700,
                              radius: 16,
                              child: const Icon(Icons.local_gas_station, color: Colors.white, size: 16),
                            ),
                          ],
                        ),
                        
                        const SizedBox(width: 20),
                        
                        Expanded(
                          child: SizedBox(
                            height: _cizgiBoyuHesapla(istasyon.kmBilgisi) + 64,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Mevcut Konumunuz', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87)),
                                    Text('Otoyol başlangıç noktası', style: TextStyle(color: Colors.grey, fontSize: 12)),
                                  ],
                                ),
                                
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: Colors.grey.shade300)
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.access_time, size: 16, color: Colors.blueGrey),
                                        const SizedBox(width: 6),
                                        Text(
                                          '${istasyon.kmBilgisi} KM ($formatliSure)',
                                          style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.blueGrey, fontSize: 13),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('${istasyon.istasyonAdi} İstasyonu', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87)),
                                    Text('Hedeflenen yakıt ikmal noktası (${istasyon.kmBilgisi}. km)', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // SIFIR TAŞMA GARANTİLİ ALT BUTON PANELİ
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -4))
                ],
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1A73E8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        elevation: 2,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => KonumEkrani(
                              istasyon: istasyon,
                              otobanAdi: otobanAdi,
                              yakitTuru: yakitTuru,
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.map_outlined, color: Colors.white),
                      label: const Text(
                        'Canlı Navigasyon Haritasını Aç',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: OutlinedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back, color: Color(0xFF1565C0)),
                      label: const Text(
                        'İstasyon Listesine Geri Dön',
                        style: TextStyle(fontSize: 14, color: Color(0xFF1565C0), fontWeight: FontWeight.w600),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF1565C0)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🎯 YENİ: Dinamik kategorileri şık etiketlerle oluşturan fonksiyon
  Widget _buildTesisBolumu({required String baslik, required IconData ikon, required Color renk, required List<String> liste}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(ikon, color: renk, size: 20),
              const SizedBox(width: 8),
              Text(baslik, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.blueGrey.shade800)),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 10,
            children: liste.map((item) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: renk.withOpacity(0.08),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: renk.withOpacity(0.3)),
              ),
              child: Text(item, style: TextStyle(color: renk, fontWeight: FontWeight.bold, fontSize: 12)),
            )).toList(),
          ),
        ],
      ),
    );
  }
}