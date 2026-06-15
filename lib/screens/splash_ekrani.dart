import 'package:flutter/material.dart';
import 'dashboard_ekrani.dart';

class SplashEkrani extends StatefulWidget {
  const SplashEkrani({super.key});

  @override
  State<SplashEkrani> createState() => _SplashEkraniState();
}

class _SplashEkraniState extends State<SplashEkrani> {
  final String _uygulamaAdi = "OTAN";
  final String _uygulamaUzunAdi = "Otoyol Tesis ve Akaryakıt Navigasyonu";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 🇹🇷 ÜST KISIM: Bakanlık Logosu Devasa Boyuta Getirildi!
              Column(
                children: [
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 85, // 🎯 55'ten 85'e çıkarıldı! Artık çok daha heybetli.
                    child: Image.asset(
                      'assets/images/uab_logo.png',
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.account_balance, color: Color(0xFF1565C0), size: 60);
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'T.C. ULAŞTIRMA VE ALTYAPI BAKANLIĞI',
                    style: TextStyle(
                      color: Color(0xFF1565C0),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Stratejik Altyapı ve Veri İzleme Desteğiyle',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),

              // 🏢 ORTA KISIM: Büyük Uygulama İsmi ve Modern İkon
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    child: const Icon(
                      Icons.add_road_rounded,
                      color: Color(0xFF1565C0),
                      size: 80,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _uygulamaAdi,
                    style: const TextStyle(
                      color: Color(0xFF1A237E),
                      fontSize: 52,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2.0,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _uygulamaUzunAdi,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.blueGrey.shade700,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              // 🏛️ LOGOLAR: KGM ve HGS Dev Boyutta
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildDevSefafLogo('assets/images/kgm_logo.png', Icons.account_balance_rounded, 'KGM'),
                  const SizedBox(width: 30), 
                  _buildDevSefafLogo('assets/images/hgs_logo.png', Icons.payment_rounded, 'HGS'),
                ],
              ),

              // 🚀 ALT KISIM: Tertemiz Çalışan Giriş Butonu
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const DashboardEkrani()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1565C0),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Sisteme Giriş Yap',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 10),
                      Icon(Icons.arrow_forward_rounded),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDevSefafLogo(String assetPath, IconData yedekIcon, String yedekYazi) {
    return SizedBox(
      width: 140, 
      height: 140,
      child: Image.asset(
        assetPath,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(yedekIcon, color: const Color(0xFF1565C0), size: 40),
              const SizedBox(height: 4),
              Text(yedekYazi, style: const TextStyle(color: Color(0xFF1565C0), fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          );
        },
      ),
    );
  }
}