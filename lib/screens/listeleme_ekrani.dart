import 'package:flutter/material.dart';
import '../data/sqlite_helper.dart';
import '../models/otoban.dart';
import '../models/istasyon.dart';
import 'detay_ekrani.dart';

class ListelemeEkrani extends StatefulWidget {
  final Otoban otoban;
  final String yakitTuru;

  const ListelemeEkrani({
    super.key,
    required this.otoban,
    required this.yakitTuru,
  });

  @override
  State<ListelemeEkrani> createState() => _ListelemeEkraniState();
}

class _ListelemeEkraniState extends State<ListelemeEkrani> {
  final SqliteHelper _dbHelper = SqliteHelper();
  List<Istasyon> _istasyonlar = [];
  bool _yukleniyor = true;
  double _enUcuzFiyat = double.infinity;

  @override
  void initState() {
    super.initState();
    _istasyonlariYukle();
  }

  Future<void> _istasyonlariYukle() async {
    final liste = await _dbHelper.getIstasyonlar(
      otobanId: widget.otoban.id!,
      yakitTuru: widget.yakitTuru,
    );

    double enUcuz = double.infinity;
    for (var istasyon in liste) {
      double f = istasyon.fiyatGetir(widget.yakitTuru);
      if (f < enUcuz) {
        enUcuz = f;
      }
    }

    setState(() {
      _istasyonlar = liste;
      _enUcuzFiyat = enUcuz;
      _yukleniyor = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Text(
          widget.otoban.otobanAdi, 
          style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)
        ),
        backgroundColor: const Color(0xFF1565C0),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _yukleniyor
          ? const Center(child: CircularProgressIndicator())
          : _istasyonlar.isEmpty
              ? const Center(child: Text('Bu otoyolda istasyon kaydı bulunamadı.'))
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  itemCount: _istasyonlar.length,
                  itemBuilder: (ctx, index) {
                    final istasyon = _istasyonlar[index];
                    final fiyat = istasyon.fiyatGetir(widget.yakitTuru);
                    final bool enUcuzMu = (fiyat == _enUcuzFiyat);

                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      elevation: enUcuzMu ? 3 : 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: enUcuzMu ? Colors.green.shade400 : Colors.red.shade200,
                          width: enUcuzMu ? 2.0 : 1.0,
                        ),
                      ),
                      child: Material(
                        color: enUcuzMu ? const Color(0xFFE8F5E9) : const Color(0xFFFFEBEE),
                        borderRadius: BorderRadius.circular(12),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          leading: CircleAvatar(
                            backgroundColor: enUcuzMu ? Colors.green.shade700 : Colors.red.shade700,
                            child: Icon(enUcuzMu ? Icons.star : Icons.local_gas_station, color: Colors.white, size: 18),
                          ),
                          title: Row(
                            children: [
                              // Expanded sayesinde isim ne kadar uzun olursa olsun fiyatı sıkıştırmaz ve taşma yapmaz!
                              Expanded(
                                child: Text(
                                  istasyon.istasyonAdi, 
                                  style: TextStyle(
                                    fontWeight: widget.yakitTuru == '' ? FontWeight.normal : FontWeight.bold, 
                                    fontSize: 13, 
                                    color: Colors.black87
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (enUcuzMu)
                                Container(
                                  margin: const EdgeInsets.only(left: 4, right: 4),
                                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                  decoration: BoxDecoration(color: Colors.green.shade700, borderRadius: BorderRadius.circular(4)),
                                  child: const Text('EN UCUZ', style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                                ),
                            ],
                          ),
                          subtitle: Text('${istasyon.kmBilgisi}. Kilometre', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                          trailing: Text(
                            '₺${fiyat.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold, 
                              color: enUcuzMu ? Colors.green.shade800 : Colors.red.shade800, 
                              fontSize: 14
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DetayEkrani(
                                  istasyon: istasyon,
                                  otobanAdi: widget.otoban.otobanAdi,
                                  yakitTuru: widget.yakitTuru,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}