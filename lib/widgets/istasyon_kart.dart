import 'package:flutter/material.dart';
import '../models/istasyon.dart';

class IstasyonKart extends StatelessWidget {
  final Istasyon istasyon;
  final String yakitTuru;
  final int siraNo;
  final bool enUcuz;
  final VoidCallback onTap;

  const IstasyonKart({
    super.key,
    required this.istasyon,
    required this.yakitTuru,
    required this.siraNo,
    required this.enUcuz,
    required this.onTap,
  });

  Color get _kaynakRenk {
    switch (istasyon.istasyonAdi.toLowerCase()) {
      case 'shell':
        return const Color(0xFFDD0000);
      case 'opet':
        return const Color(0xFF0053A0);
      case 'petrol ofisi':
        return const Color(0xFFFF6600);
      case 'bp':
        return const Color(0xFF009900);
      case 'total':
        return const Color(0xFFCC0000);
      case 'aytemiz':
        return const Color(0xFF003087);
      default:
        return const Color(0xFF607D8B);
    }
  }

  @override
  Widget build(BuildContext context) {
    final fiyat = istasyon.fiyatGetir(yakitTuru);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: enUcuz ? const Color(0xFFE8F5E9) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: enUcuz ? const Color(0xFF43A047) : Colors.grey.shade200,
            width: enUcuz ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              // Sıra numarası veya taç ikonu
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: enUcuz
                      ? const Color(0xFF43A047)
                      : const Color(0xFFE3F2FD),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: enUcuz
                      ? const Icon(Icons.emoji_events, color: Colors.white, size: 20)
                      : Text(
                          '$siraNo',
                          style: const TextStyle(
                            color: Color(0xFF1565C0),
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                ),
              ),
              const SizedBox(width: 12),

              // İstasyon bilgileri
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _kaynakRenk,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          istasyon.istasyonAdi,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF212121),
                          ),
                        ),
                        if (enUcuz) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFF43A047),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text(
                              'EN UCUZ',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on,
                            size: 14, color: Colors.grey),
                        const SizedBox(width: 3),
                        Text(
                          '${istasyon.kmBilgisi}. km',
                          style: const TextStyle(
                              color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Fiyat
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '₺${fiyat.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: enUcuz
                          ? const Color(0xFF2E7D32)
                          : const Color(0xFF1565C0),
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Icon(Icons.chevron_right, color: Colors.grey, size: 18),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}