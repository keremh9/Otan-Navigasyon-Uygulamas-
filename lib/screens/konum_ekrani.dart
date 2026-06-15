import 'package:flutter/material.dart';
import '../models/istasyon.dart';
import '../data/sqlite_helper.dart';

class MeskenBilgisi {
  final String isim;
  final double tKonum; 
  final bool sagdaMi;  

  const MeskenBilgisi({
    required this.isim,
    required this.tKonum,
    required this.sagdaMi,
  });
}

class KonumEkrani extends StatefulWidget {
  final Istasyon istasyon;
  final String otobanAdi;
  final String yakitTuru;

  const KonumEkrani({
    super.key,
    required this.istasyon,
    required this.otobanAdi,
    required this.yakitTuru,
  });

  @override
  State<KonumEkrani> createState() => _KonumEkraniState();
}

class _KonumEkraniState extends State<KonumEkrani> with SingleTickerProviderStateMixin {
  bool _navigasyonAktif = false;
  late AnimationController _arabaController;
  
  List<Istasyon> _oOtobandakiTumIstasyonlar = [];
  List<MeskenBilgisi> _otobanMeskenleri = [];
  double _enUcuzFiyat = double.infinity;
  bool _yukleniyor = true;
  double _otobanMaksimumKm = 100.0; 

  @override
  void initState() {
    super.initState();
    _meskenleriDinamikOlustur();
    _tumIstasyonlariYukle();

    _arabaController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 25), 
    );

    _arabaController.addListener(() {
      setState(() {});
    });
  }

  String _logoYolunuGetir(String istasyonAdi) {
    final name = istasyonAdi.toLowerCase();

    if (name.contains('opet')) {
      return 'assets/images/opet_logo.png';
    } else if (name.contains('shell')) {
      return 'assets/images/shell_logo.png';
    } else if (name.contains('petrol') || name.contains('po') || name.contains('ofisi') || name.contains('yol-bak')) {
      return 'assets/images/po_logo.png';
    } else if (name.contains('total') || name.contains('aytemiz')) {
      return 'assets/images/total_logo.png';
    }
    return 'assets/images/po_logo.png'; 
  }

  void _meskenleriDinamikOlustur() {
    final String yolAdi = widget.otobanAdi.toLowerCase();
    
    if (yolAdi.contains('o-54') || yolAdi.contains('gaziantep')) {
      _otobanMeskenleri = [
        const MeskenBilgisi(isim: 'Şehitkamil', tKonum: 0.20, sagdaMi: false),
        const MeskenBilgisi(isim: 'Gaziantep OSB', tKonum: 0.45, sagdaMi: true),
        const MeskenBilgisi(isim: 'Şahinbey', tKonum: 0.65, sagdaMi: false),
        const MeskenBilgisi(isim: 'Nizip Çıkışı', tKonum: 0.85, sagdaMi: true),
      ];
    } else if (yolAdi.contains('o-33') || yolAdi.contains('menemen') || yolAdi.contains('aliağa')) {
      _otobanMeskenleri = [
        const MeskenBilgisi(isim: 'Çiğli', tKonum: 0.18, sagdaMi: true),
        const MeskenBilgisi(isim: 'Menemen Merkez', tKonum: 0.40, sagdaMi: false),
        const MeskenBilgisi(isim: 'Hatundere', tKonum: 0.68, sagdaMi: true),
        const MeskenBilgisi(isim: 'Aliağa OSB', tKonum: 0.88, sagdaMi: false),
      ];
    } else if (yolAdi.contains('o-30') || yolAdi.contains('izmir')) {
      _otobanMeskenleri = [
        const MeskenBilgisi(isim: 'Bayraklı Tünelleri', tKonum: 0.25, sagdaMi: false),
        const MeskenBilgisi(isim: 'Bornova', tKonum: 0.50, sagdaMi: true),
        const MeskenBilgisi(isim: 'Buca', tKonum: 0.75, sagdaMi: false),
      ];
    } else if (yolAdi.contains('o-4') || yolAdi.contains('anadolu')) {
      _otobanMeskenleri = [
        const MeskenBilgisi(isim: 'Gebze', tKonum: 0.15, sagdaMi: true),
        const MeskenBilgisi(isim: 'İzmit Batı', tKonum: 0.42, sagdaMi: false),
        const MeskenBilgisi(isim: 'Sapanca', tKonum: 0.65, sagdaMi: true),
        const MeskenBilgisi(isim: 'Bolu Dağı Tüneli', tKonum: 0.88, sagdaMi: false),
      ];
    } else if (yolAdi.contains('o-21') || yolAdi.contains('tarsus') || yolAdi.contains('ankara')) {
      _otobanMeskenleri = [
        const MeskenBilgisi(isim: 'Tarsus Doğu', tKonum: 0.20, sagdaMi: true),
        const MeskenBilgisi(isim: 'Pozantı Geçidi', tKonum: 0.50, sagdaMi: false),
        const MeskenBilgisi(isim: 'Gölbaşı', tKonum: 0.85, sagdaMi: true),
      ];
    } else {
      _otobanMeskenleri = [
        const MeskenBilgisi(isim: 'Merkez İlçe', tKonum: 0.30, sagdaMi: true),
        const MeskenBilgisi(isim: 'Sanayi Bölgesi', tKonum: 0.70, sagdaMi: false),
      ];
    }
  }

  Future<void> _tumIstasyonlariYukle() async {
    final liste = await SqliteHelper().getIstasyonlar(
      otobanId: widget.istasyon.otobanId,
      yakitTuru: widget.yakitTuru,
    );

    liste.sort((a, b) => a.kmBilgisi.compareTo(b.kmBilgisi));

    double ucuz = double.infinity;
    double maxKm = 10.0;
    for (var ist in liste) {
      double f = ist.fiyatGetir(widget.yakitTuru);
      if (f < ucuz) ucuz = f;
      if (ist.kmBilgisi > maxKm) maxKm = ist.kmBilgisi.toDouble();
    }

    setState(() {
      _oOtobandakiTumIstasyonlar = liste;
      _enUcuzFiyat = ucuz;
      // 🛠️ MANTIK HATASI ÇÖZÜMÜ: Otoyolun bitiş km'si tam olarak en uzak istasyonun km'sine sabitlendi!
      _otobanMaksimumKm = maxKm; 
      _yukleniyor = false;
    });
  }

  @override
  void dispose() {
    _arabaController.dispose();
    super.dispose();
  }

  Offset _getDinamikOtobanViraji(double t, Size size) {
    double w = size.width;
    double h = size.height;

    Offset p0 = Offset(w * 0.5, h * 0.88);
    Offset p1; 
    Offset p2; 
    Offset p3 = Offset(w * 0.5, h * 0.08);

    final String yolAdi = widget.otobanAdi.toLowerCase();

    if (yolAdi.contains('o-33') || yolAdi.contains('menemen') || yolAdi.contains('aliağa')) {
      p1 = Offset(w * 1.2, h * 0.65); 
      p2 = Offset(w * -0.2, h * 0.35); 
    } else if (yolAdi.contains('o-54') || yolAdi.contains('gaziantep')) {
      p1 = Offset(w * 1.3, h * 0.7);
      p2 = Offset(w * -0.3, h * 0.3);
    } else if (yolAdi.contains('o-30') || yolAdi.contains('izmir')) {
      p1 = Offset(w * -0.1, h * 0.65);
      p2 = Offset(w * 0.1, h * 0.3);
    } else if (yolAdi.contains('o-4') || yolAdi.contains('anadolu')) {
      p1 = Offset(w * 0.15, h * 0.65);
      p2 = Offset(w * 0.85, h * 0.35);
    } else {
      p1 = Offset(w * 0.2, h * 0.65);
      p2 = Offset(w * 0.8, h * 0.35);
    }

    double u = 1 - t;
    double tt = t * t;
    double uu = u * u;
    double uuu = uu * u;
    double ttt = tt * t;

    double x = uuu * p0.dx + 3 * uu * t * p1.dx + 3 * u * tt * p2.dx + ttt * p3.dx;
    double y = uuu * p0.dy + 3 * uu * t * p1.dy + 3 * u * tt * p2.dy + ttt * p3.dy;

    return Offset(x, y);
  }

  String _sureFormatla(int toplamDakika) {
    if (toplamDakika < 60) return '$toplamDakika dk';
    int saat = toplamDakika ~/ 60;
    int dakika = toplamDakika % 60;
    return dakika == 0 ? '$saat saat' : '$saat saat $dakika dk';
  }

  @override
  Widget build(BuildContext context) {
    if (_yukleniyor) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    double animasyonDegeri = _arabaController.value; 
    
    // Toplam mesafe hedef istasyonun kilometresidir
    int toplamMesafe = widget.istasyon.kmBilgisi;
    
    // Araba ilerleme t yüzdesi hesabı
    double hedefIstasyonT = widget.istasyon.kmBilgisi / _otobanMaksimumKm;
    if (hedefIstasyonT > 1.0) hedefIstasyonT = 1.0;
    double arabaT = animasyonDegeri * hedefIstasyonT;

    // Kalan mesafe ve süre hesabı
    int kalanMesafe = (toplamMesafe * (1.0 - animasyonDegeri)).round();
    if (kalanMesafe < 0) kalanMesafe = 0;
    if (!_navigasyonAktif && animasyonDegeri == 0) kalanMesafe = toplamMesafe;

    int hesaplananDakika = ((kalanMesafe * 60) / 90).round() + 10;
    int saat = hesaplananDakika ~/ 60;
    int dakika = hesaplananDakika % 60;

    return Scaffold(
      backgroundColor: const Color(0xFFF1F3F4),
      appBar: AppBar(
        title: const Text('Canlı Navigasyon Haritası', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16)),
        backgroundColor: const Color(0xFF1A73E8),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          Size haritaBoyutu = Size(constraints.maxWidth, constraints.maxHeight - 165);
          Offset arabaKonum = _getDinamikOtobanViraji(arabaT, haritaBoyutu);
          Offset yolBitisNoktasi = _getDinamikOtobanViraji(1.0, haritaBoyutu);

          return Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                color: Colors.white,
                child: Row(
                  children: [
                    const Icon(Icons.alt_route, color: Color(0xFF1A73E8), size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        widget.otobanAdi,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Hedef: ${widget.istasyon.istasyonAdi}', 
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 11, color: Colors.black54),
                        textAlign: TextAlign.end,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: InteractiveViewer(
                  maxScale: 3.0,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: CustomPaint(
                          painter: VirajliHaritaPainter(
                            haritaBoyutu: haritaBoyutu,
                            ilerlemeT: arabaT,
                            yolFonksiyonu: _getDinamikOtobanViraji,
                          ),
                        ),
                      ),

                      Positioned(
                        left: haritaBoyutu.width * 0.5 - 90,
                        top: haritaBoyutu.height * 0.85 + 5,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                          decoration: BoxDecoration(color: Colors.blueGrey.shade800, borderRadius: BorderRadius.circular(4)),
                          child: const Text('OTOBAN GİRİŞİ', style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                        ),
                      ),

                      Positioned(
                        left: yolBitisNoktasi.dx - 80,
                        top: yolBitisNoktasi.dy - 10,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                          decoration: BoxDecoration(color: Colors.red.shade900, borderRadius: BorderRadius.circular(4)),
                          child: const Text('OTOBAN SONU', style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                        ),
                      ),

                      // YOL KENARINDAKİ MESKENLER
                      ..._otobanMeskenleri.map((mesken) {
                        Offset yolNoktasi = _getDinamikOtobanViraji(mesken.tKonum, haritaBoyutu);
                        double xKonum = mesken.sagdaMi ? (yolNoktasi.dx + 45) : (yolNoktasi.dx - 110);
                        double yKonum = yolNoktasi.dy - 10;

                        return Positioned(
                          left: xKonum,
                          top: yKonum,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (!mesken.sagdaMi) ...[
                                Text(
                                  mesken.isim,
                                  style: TextStyle(color: Colors.grey.shade600, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                                ),
                                const SizedBox(width: 4),
                                Icon(Icons.circle, size: 5, color: Colors.grey.shade400),
                              ],
                              if (mesken.sagdaMi) ...[
                                Icon(Icons.circle, size: 5, color: Colors.grey.shade400),
                                const SizedBox(width: 4),
                                Text(
                                  mesken.isim,
                                  style: TextStyle(color: Colors.grey.shade600, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                                ),
                              ],
                            ],
                          ),
                        );
                      }),
                      
                      // 🌟 ORANLARI TAM VE MATEMATİKSEL SIRALI LİSTELENEN İSTASYON KATMANI
                      ..._oOtobandakiTumIstasyonlar.map((ist) {
                        final double f = ist.fiyatGetir(widget.yakitTuru);
                        final bool ucuzMu = (f == _enUcuzFiyat);

                        // 🛠️ MANTIK HATASI ÇÖZÜMÜ: İstasyonların t konumu artık yol sınırına tam oranlanıyor
                        double istasyonT = ist.kmBilgisi / _otobanMaksimumKm;
                        
                        // Giriş ve çıkış tabelalarıyla çakışmaması için küçük bir güvenlik payı
                        if (istasyonT > 0.95) istasyonT = 0.94;
                        if (istasyonT < 0.05) istasyonT = 0.06;

                        Offset yolNokta = _getDinamikOtobanViraji(istasyonT, haritaBoyutu);
                        Offset istasyonPini = Offset(yolNokta.dx + 18, yolNokta.dy - 25);

                        return Positioned(
                          left: istasyonPini.dx,
                          top: istasyonPini.dy,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                                decoration: BoxDecoration(
                                  color: ucuzMu ? const Color(0xFF2E7D32) : const Color(0xFF212121),
                                  borderRadius: BorderRadius.circular(4),
                                  boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2)],
                                ),
                                child: Text(
                                  '${ist.istasyonAdi}\n₺${f.toStringAsFixed(2)} - ${ist.kmBilgisi}. Km',
                                  style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(height: 6),
                              
                              SizedBox(
                                width: 28,
                                height: 28,
                                child: Image.asset(
                                  _logoYolunuGetir(ist.istasyonAdi),
                                  fit: BoxFit.contain,
                                  color: const Color(0xFFF4F3F0), 
                                  colorBlendMode: BlendMode.modulate, 
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(Icons.local_gas_station, color: ucuzMu ? Colors.green : Colors.red, size: 20);
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                      
                      Positioned(
                        left: arabaKonum.dx - 13,
                        top: arabaKonum.dy - 13,
                        child: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle, 
                            boxShadow: [BoxShadow(color: Colors.black38, blurRadius: 4, offset: Offset(0, 2))]
                          ),
                          child: const Icon(
                            Icons.directions_car_filled, 
                            color: Color(0xFF1A73E8), 
                            size: 26,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10, offset: const Offset(0, -3))],
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(18), topRight: Radius.circular(18)),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              const Text('KALAN MESAFE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black45)),
                              const SizedBox(height: 4),
                              Text('$kalanMesafe km', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                            ],
                          ),
                          Container(width: 1, height: 30, color: Colors.grey.shade200),
                          Column(
                            children: [
                              const Text('SÜRE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black45)),
                              const SizedBox(height: 4),
                              Text(
                                _navigasyonAktif && kalanMesafe <= 0 ? 'Varıldı' : _sureFormatla(hesaplananDakika),
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A73E8)),
                              ),
                            ],
                          ),
                          Container(width: 1, height: 30, color: Colors.grey.shade200),
                          Column(
                            children: [
                              const Text('HIZ', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black45)),
                              const SizedBox(height: 4),
                              Text(_navigasyonAktif && kalanMesafe > 0 ? '110 km/h' : '0 km/h', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              _navigasyonAktif = !_navigasyonAktif;
                              if (_navigasyonAktif) {
                                _arabaController.forward(from: 0.0);
                              } else {
                                _arabaController.reset();
                              }
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _navigasyonAktif ? Colors.red.shade700 : const Color(0xFF1A73E8),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: 1,
                          ),
                          icon: Icon(_navigasyonAktif ? Icons.navigation_outlined : Icons.navigation, color: Colors.white, size: 18),
                          label: Text(
                            _navigasyonAktif ? 'Navigasyonu Durdur' : 'Navigasyonu Başlat',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class VirajliHaritaPainter extends CustomPainter {
  final Size haritaBoyutu;
  final double ilerlemeT;
  final Offset Function(double t, Size size) yolFonksiyonu;

  VirajliHaritaPainter({
    required this.haritaBoyutu,
    required this.ilerlemeT,
    required this.yolFonksiyonu,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), Paint()..color = const Color(0xFFF4F3F0));

    Path otoyolPatikasi = Path();
    Offset ilkNokta = yolFonksiyonu(0.0, size);
    otoyolPatikasi.moveTo(ilkNokta.dx, ilkNokta.dy);

    for (double i = 0.005; i <= 1.0; i += 0.005) {
      Offset n = yolFonksiyonu(i, size);
      otoyolPatikasi.lineTo(n.dx, n.dy);
    }

    canvas.drawPath(otoyolPatikasi, Paint()..color = const Color(0xFFCFD8DC)..strokeWidth = 26.0..style = PaintingStyle.stroke..strokeCap = StrokeCap.round);
    canvas.drawPath(otoyolPatikasi, Paint()..color = Colors.white..strokeWidth = 22.0..style = PaintingStyle.stroke..strokeCap = StrokeCap.round);
    canvas.drawPath(otoyolPatikasi, Paint()..color = Colors.grey.shade400..strokeWidth = 1.8..style = PaintingStyle.stroke);

    if (ilerlemeT > 0.0) {
      Path maviRota = Path();
      maviRota.moveTo(ilkNokta.dx, ilkNokta.dy);

      for (double i = 0.005; i <= ilerlemeT; i += 0.005) {
        Offset n = yolFonksiyonu(i, size);
        maviRota.lineTo(n.dx, n.dy);
      }

      canvas.drawPath(maviRota, Paint()..color = const Color(0xFF1A73E8)..strokeWidth = 22.0..style = PaintingStyle.stroke..strokeCap = StrokeCap.round);
      canvas.drawPath(maviRota, Paint()..color = const Color(0xFF66A3FF)..strokeWidth = 10.0..style = PaintingStyle.stroke..strokeCap = StrokeCap.round);
    }
  }

  @override
  bool shouldRepaint(covariant VirajliHaritaPainter oldDelegate) {
    return oldDelegate.ilerlemeT != ilerlemeT;
  }
}