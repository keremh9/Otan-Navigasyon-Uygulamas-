import 'package:flutter/material.dart';
import '../data/sqlite_helper.dart';
import '../models/otoban.dart';
import '../models/istasyon.dart';
import 'konum_ekrani.dart';

class EvPlanlamaEkrani extends StatefulWidget {
  const EvPlanlamaEkrani({super.key});

  @override
  State<EvPlanlamaEkrani> createState() => _EvPlanlamaEkraniState();
}

class _EvPlanlamaEkraniState extends State<EvPlanlamaEkrani> {
  final SqliteHelper _sqliteHelper = SqliteHelper();
  List<Otoban> _otobanListesi = [];
  List<Istasyon> _evIstasyonlari = [];
  
  Otoban? _secilenOtoban;
  bool _yukleniyor = true;

  @override
  void initState() {
    super.initState();
    _otobanlariYukle();
  }

  // Veritabanından tüm otoyolları çeken fonksiyon
  Future<void> _otobanlariYukle() async {
    try {
      final otobanlar = await _sqliteHelper.getOtobanlar();
      setState(() {
        _otobanListesi = otobanlar;
        _yukleniyor = false;
      });
    } catch (e) {
      setState(() => _yukleniyor = false);
    }
  }

  // Seçilen otoyoldaki SADECE ELEKTRİKLİ ŞARJ NOKTASI olan istasyonları filtreleyen fonksiyon
  Future<void> _istasyonlariFiltrele(Otoban otoban) async {
    setState(() => _yukleniyor = true);
    try {
      // getIstasyonlar tüm istasyonları getiriyor, biz içinden şarjı boş olmayanları süzüyoruz
      final tumIstasyonlar = await _sqliteHelper.getIstasyonlar(otobanId: otoban.id, yakitTuru: 'benzin');
      setState(() {
        _evIstasyonlari = tumIstasyonlar.where((i) => i.sarjIstasyonlari.isNotEmpty).toList();
        _yukleniyor = false;
      });
    } catch (e) {
      setState(() => _yukleniyor = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      appBar: AppBar(
        title: const Text('EV Şarj Navigasyon Planı', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF00796B), // EV yeşili tema
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      body: _yukleniyor && _otobanListesi.isEmpty
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF00796B)))
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 🔽 Otoban Seçim Alanı
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<Otoban>(
                          hint: const Text('Şarj Rotası İçin Otoban Seçiniz', style: TextStyle(fontSize: 14)),
                          value: _secilenOtoban,
                          isExpanded: true,
                          items: _otobanListesi.map((Otoban o) {
                            return DropdownMenuItem<Otoban>(
                              value: o,
                              child: Text(o.otobanAdi, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                            );
                          }).toList(),
                          onChanged: (Otoban? yeniSecim) {
                            if (yeniSecim != null) {
                              setState(() {
                                _secilenOtoban = yeniSecim;
                              });
                              _istasyonlariFiltrele(yeniSecim);
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // 📜 İstasyon Listeleme Alanı
                  Expanded(
                    child: _yukleniyor
                        ? const Center(child: CircularProgressIndicator(color: Color(0xFF00796B)))
                        : _secilenOtoban == null
                            ? const Center(child: Text('Lütfen yukarıdan bir otoyol seçin.', style: TextStyle(color: Colors.grey)))
                            : _evIstasyonlari.isEmpty
                                ? const Center(child: Text('Bu otoyolda şarj istasyonu bulunamadı.', style: TextStyle(fontWeight: FontWeight.bold)))
                                : ListView.builder(
                                    itemCount: _evIstasyonlari.length,
                                    itemBuilder: (context, index) {
                                      final istasyon = _evIstasyonlari[index];
                                      return Card(
                                        elevation: 2,
                                        margin: const EdgeInsets.only(bottom: 12),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          side: const BorderSide(color: Color(0xFFB2DFDB), width: 1)
                                        ),
                                        child: ListTile(
                                          contentPadding: const EdgeInsets.all(16),
                                          leading: const CircleAvatar(
                                            backgroundColor: Color(0xFFE0F2F1),
                                            child: Icon(Icons.electric_bolt_rounded, color: Color(0xFF00796B)),
                                          ),
                                          title: Text(
                                            istasyon.istasyonAdi,
                                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                          ),
                                          subtitle: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const SizedBox(height: 4),
                                              Text('Otoyol KM: ${istasyon.kmBilgisi}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                                              const SizedBox(height: 6),
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFF00796B).withOpacity(0.1),
                                                  borderRadius: BorderRadius.circular(6),
                                                ),
                                                child: Text(
                                                  istasyon.sarjIstasyonlari,
                                                  style: const TextStyle(color: Color(0xFF00796B), fontWeight: FontWeight.bold, fontSize: 11),
                                                ),
                                              ),
                                            ],
                                          ),
                                          trailing: const Icon(Icons.navigation_rounded, color: Color(0xFF00796B)),
                                          onTap: () {
                                            // 🚀 DOĞRUDAN CANLI NAVİGASYON EKRANINA UÇUŞ
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) => KonumEkrani(
                                                  istasyon: istasyon,
                                                  otobanAdi: _secilenOtoban!.otobanAdi,
                                                  yakitTuru: 'Elektrik', // Konum ekranının tanıması için elektrik yolluyoruz
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                    },
                                  ),
                  ),
                ],
              ),
            ),
    );
  }
}