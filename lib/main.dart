import 'package:flutter/material.dart';
import 'screens/splash_ekrani.dart'; // Karşılama ekranımızı projeye dahil ettik

void main() {
  // 🛡️ Native eklentilerin ve sistem kanallarının kilitlenip uygulamanın çökmesini engelleyen kritik güvence satırı:
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OTAN',
      debugShowCheckedModeBanner: false, // Debug şeridini kapatır
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1565C0)),
        useMaterial3: true,
      ),
      home: const SplashEkrani(), // Uygulama artık doğrudan bu ekrandan başlayacak!
    );
  }
}