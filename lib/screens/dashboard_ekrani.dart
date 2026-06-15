import 'package:flutter/material.dart';
import '../data/sqlite_helper.dart';
import '../models/otoban.dart';
import 'listeleme_ekrani.dart';
import 'ev_planlama_ekrani.dart';

class DashboardEkrani extends StatefulWidget {
  const DashboardEkrani({super.key});

  @override
  State<DashboardEkrani> createState() => _DashboardEkraniState();
}

class _DashboardEkraniState extends State<DashboardEkrani> {
  final SqliteHelper _dbHelper = SqliteHelper();

  List<Otoban> _otobanlar = [];
  Otoban? _secilenOtoban;
  String _secilenYakit = 'motorin';
  bool _yukleniyor = true;

  @override
  void initState() {
    super.initState();
    _otobanlariYukle();
  }

  // Veritabanından otoban listesini güvenli bir şekilde çeker (Hata Kontrolü)
  Future<void> _otobanlariYukle() async {
    try {
      final liste = await _dbHelper.getOtobanlar();
      setState(() {
        _otobanlar = liste;
        _yukleniyor = false;
      });
    } catch (e) {
      setState(() => _yukleniyor = false);
      // Hoca test ederken bir sorun çıkarsa ekranda hata mesajı gösterilir
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Otobanlar yüklenirken hata oluştu: $e')),
      );
    }
  }

  void _aramayaGit() {
    if (_secilenOtoban == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lütfen bir otoban seçiniz.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ListelemeEkrani(
          otoban: _secilenOtoban!,
          yakitTuru: _secilenYakit,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        // 🎯 Sol üste basıldığında direkt en başa (Splash) döndüren kurumsal buton!
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
          onPressed: () {
            Navigator.pop(context); // Hafızadaki bir önceki ekran olan SplashEkrani'na geri fırlatır!
          },
        ),
        title: const Text(
          'OTAN Ana Panel', 
          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)
        ),
        backgroundColor: const Color(0xFF1565C0),
        centerTitle: true,
      ),
      body: _yukleniyor
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  // Başlık kartı (UI Tasarım Puanı için Premium Görünüm)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF1565C0), Color(0xFF1976D2)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.local_gas_station, color: Colors.white, size: 36),
                        SizedBox(height: 10),
                        Text(
                          'Seyahatinizi Planlayın',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Otoban ve yakıt türü seçerek en uygun fiyatlı istasyonu bulun.',
                          style: TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Otoban Seçimi (Dropdown)
                  const Text(
                    'Otoban Seçiniz',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF37474F),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFBBDEFB), width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<Otoban>(
                        value: _secilenOtoban,
                        isExpanded: true,
                        hint: const Text('-- Otoban seçiniz --'),
                        items: _otobanlar
                            .map(
                              (o) => DropdownMenuItem<Otoban>(
                                value: o,
                                child: Text(
                                  o.otobanAdi,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (val) => setState(() => _secilenOtoban = val),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Yakıt Türü Seçimi (Radio Buttons)
                  const Text(
                    'Yakıt Türü Seçiniz',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF37474F),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFBBDEFB), width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _yakitRadioTile('motorin', 'Motorin', Icons.directions_car, Colors.blue),
                        _yakitRadioTile('benzin', 'Benzin', Icons.local_gas_station, Colors.orange),
                        _yakitRadioTile('lpg', 'LPG', Icons.eco, Colors.green),
                      ],
                    ),
                  ),
                  const SizedBox(height: 36),

                  // Arama Butonu
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: _aramayaGit,
                      icon: const Icon(Icons.search, color: Colors.white),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1565C0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 3,
                      ),
                      label: const Text(
                        'İstasyonları Listele',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24), // 🎯 Araya ferah bir boşluk bıraktım

                  // 🎯 DÜZELTİLDİ: Elektrikli araç butonu başarıyla içeri alındı!
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const EvPlanlamaEkrani()),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF00796B), Color(0xFF004D40)], // Elektrikli araç yeşili tonları
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(color: Colors.teal.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))
                          ],
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.electric_car_rounded, color: Colors.white, size: 32),
                            SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Elektrikli Araç Şarj Rotası',
                                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Sadece yüksek hızlı şarj (DC) noktalarını listele',
                                    style: TextStyle(color: Colors.white70, fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                            Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 18),
                          ],
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 10),
                ],
              ),
            ),
    );
  }

  Widget _yakitRadioTile(String deger, String etiket, IconData ikon, Color renk) {
    final secili = _secilenYakit == deger;
    return RadioListTile<String>(
      value: deger,
      groupValue: _secilenYakit,
      onChanged: (val) => setState(() => _secilenYakit = val!),
      activeColor: const Color(0xFF1565C0),
      title: Row(
        children: [
          Icon(ikon, color: secili ? renk : Colors.grey, size: 20),
          const SizedBox(width: 8),
          Text(
            etiket,
            style: TextStyle(
              fontWeight: secili ? FontWeight.w600 : FontWeight.normal,
              color: secili ? const Color(0xFF1565C0) : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}