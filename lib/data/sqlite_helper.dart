import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/istasyon.dart';
import '../models/otoban.dart';

class SqliteHelper {
  static final SqliteHelper _instance = SqliteHelper._internal();
  factory SqliteHelper() => _instance;
  SqliteHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'otan_veritabani.db');
    return await openDatabase(
      path,
      version: 7, // 🎯 Sürüm 7 yapıldı; sen silip yükleyince bu devasa liste dolacak!
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE otobanlar(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        otobanAdi TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE istasyonlar(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        otobanId INTEGER,
        istasyonAdi TEXT,
        kmBilgisi INTEGER,
        benzinFiyati REAL,
        motorinFiyati REAL,
        lpgFiyati REAL,
        restoranlar TEXT,
        magazalar TEXT,
        sarjIstasyonlari TEXT
      )
    ''');

    await _ornekVerileriEkle(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 7) {
      await db.execute('DROP TABLE IF EXISTS istasyonlar');
      await db.execute('DROP TABLE IF EXISTS otobanlar');
      await _onCreate(db, newVersion);
    }
  }

  Future<void> _ornekVerileriEkle(Database db) async {
    // 🇹🇷 TÜRKİYE'NİN TÜM ANA OTOYOLLARI VE ÇEVREYOLLARI
    await db.insert('otobanlar', {'otobanAdi': 'O-1 İstanbul İç Çevreyolu'});
    await db.insert('otobanlar', {'otobanAdi': 'O-2 İstanbul Dış Çevreyolu (FSM)'});
    await db.insert('otobanlar', {'otobanAdi': 'O-3 Avrupa Otoyolu (İstanbul - Edirne)'});
    await db.insert('otobanlar', {'otobanAdi': 'O-4 Anadolu Otoyolu (TEM İstanbul - Ankara)'});
    await db.insert('otobanlar', {'otobanAdi': 'O-5 Gebze - Orhangazi - İzmir Otoyolu'});
    await db.insert('otobanlar', {'otobanAdi': 'O-7 Kuzey Marmara Otoyolu'});
    await db.insert('otobanlar', {'otobanAdi': 'O-21 Ankara - Niğde - Tarsus Otoyolu'});
    await db.insert('otobanlar', {'otobanAdi': 'O-32 İzmir - Çeşme Otoyolu'});
    await db.insert('otobanlar', {'otobanAdi': 'O-52 Adana - Gaziantep - Şanlıurfa Otoyolu'});

    // ==========================================
    // 🌟 O-1 İSTANBUL İÇ ÇEVREYOLU
    // ==========================================
    await db.insert('istasyonlar', {
      'otobanId': 1, 'istasyonAdi': 'Alibeyköy Dinlenme (Shell)', 'kmBilgisi': 8, 
      'benzinFiyati': 41.60, 'motorinFiyati': 43.50, 'lpgFiyati': 22.00,
      'restoranlar': 'Simit Sarayı,Burger King', 'magazalar': 'Shell Select', 'sarjIstasyonlari': 'Eşarj (60 kW AC)'
    });
    await db.insert('istasyonlar', {
      'otobanId': 1, 'istasyonAdi': 'Küçükyalı Geçiş (Opet)', 'kmBilgisi': 18, 
      'benzinFiyati': 41.10, 'motorinFiyati': 42.90, 'lpgFiyati': 21.40, // 🎯 EN UCUZ
      'restoranlar': 'Divan Cafeteria,Zurna Döner', 'magazalar': 'Ultramarket', 'sarjIstasyonlari': 'ZES Hızlı Şarj (120 kW)'
    });
    await db.insert('istasyonlar', {
      'otobanId': 1, 'istasyonAdi': 'Üsküdar Bağlantı (PO)', 'kmBilgisi': 25, 
      'benzinFiyati': 41.40, 'motorinFiyati': 43.20, 'lpgFiyati': 21.80,
      'restoranlar': 'Hatay Usulü Döner,Çorba Dünyası', 'magazalar': 'PO Market', 'sarjIstasyonlari': 'Voltrun (22 kW)'
    });

    // ==========================================
    // 🌟 O-2 İSTANBUL DIŞ ÇEVREYOLU (FSM)
    // ==========================================
    await db.insert('istasyonlar', {
      'otobanId': 2, 'istasyonAdi': 'Kavacık Entegre (Opet)', 'kmBilgisi': 12, 
      'benzinFiyati': 41.50, 'motorinFiyati': 43.40, 'lpgFiyati': 21.90,
      'restoranlar': 'Domino\'s Pizza,Starbucks', 'magazalar': 'Teknosa Cep,Ultramarket', 'sarjIstasyonlari': 'Trugo (180 kW DC)'
    });
    await db.insert('istasyonlar', {
      'otobanId': 2, 'istasyonAdi': 'Sultanbeyli Hizmet Alanı (Shell)', 'kmBilgisi': 28, 
      'benzinFiyati': 40.95, 'motorinFiyati': 42.75, 'lpgFiyati': 21.30, // 🎯 EN UCUZ
      'restoranlar': 'Kahve Dünyası,Popeyes', 'magazalar': 'Shell Select', 'sarjIstasyonlari': 'ZES (60 kW DC)'
    });
    await db.insert('istasyonlar', {
      'otobanId': 2, 'istasyonAdi': 'Ümraniye Kavşak (PO)', 'kmBilgisi': 36, 
      'benzinFiyati': 41.30, 'motorinFiyati': 43.10, 'lpgFiyati': 21.60,
      'restoranlar': 'Bereket Döner,Sbarro', 'magazalar': 'PO Market', 'sarjIstasyonlari': 'Eşarj (120 kW DC)'
    });

    // ==========================================
    // 🌟 O-3 AVRUPA OTOYOLU (İSTANBUL - EDİRNE)
    // ==========================================
    await db.insert('istasyonlar', {
      'otobanId': 3, 'istasyonAdi': 'Selimpaşa Dinlenme (Shell)', 'kmBilgisi': 45, 
      'benzinFiyati': 41.40, 'motorinFiyati': 43.30, 'lpgFiyati': 21.80,
      'restoranlar': 'McDonald\'s,Espressolab', 'magazalar': 'Shell Select,D&R Satış Noktası', 'sarjIstasyonlari': 'Trugo Ultra (300 kW)'
    });
    await db.insert('istasyonlar', {
      'otobanId': 3, 'istasyonAdi': 'Çorlu Oksijen Tesisleri (Opet)', 'kmBilgisi': 90, 
      'benzinFiyati': 40.70, 'motorinFiyati': 42.50, 'lpgFiyati': 21.10, // 🎯 EN UCUZ
      'restoranlar': 'Köfteci Yusuf,Mado', 'magazalar': 'Ultramarket,Rossmann Mini', 'sarjIstasyonlari': 'ZES (180 kW DC)'
    });
    await db.insert('istasyonlar', {
      'otobanId': 3, 'istasyonAdi': 'Babaeski Vadi (BP)', 'kmBilgisi': 155, 
      'benzinFiyati': 41.10, 'motorinFiyati': 42.90, 'lpgFiyati': 21.50,
      'restoranlar': 'Trakya Köftecisi,Gezici Çaycı', 'magazalar': 'BP Express', 'sarjIstasyonlari': 'Astor Şarj (120 kW)'
    });

    // ==========================================
    // 🌟 O-4 ANADOLU OTOYOLU (TEM İSTANBUL - ANKARA)
    // ==========================================
    await db.insert('istasyonlar', {
      'otobanId': 4, 'istasyonAdi': 'Tuzla Mehmetçik Vakfı (Opet)', 'kmBilgisi': 15, 
      'benzinFiyati': 41.60, 'motorinFiyati': 43.50, 'lpgFiyati': 22.00,
      'restoranlar': 'Saray Muhallebicisi,Burger King', 'magazalar': 'Ultramarket', 'sarjIstasyonlari': 'Eşarj (4 Soket)' 
    });
    await db.insert('istasyonlar', {
      'otobanId': 4, 'istasyonAdi': 'Sakarya Parkshop (Shell)', 'kmBilgisi': 105, 
      'benzinFiyati': 41.20, 'motorinFiyati': 43.10, 'lpgFiyati': 21.50,
      'restoranlar': 'KFC,Kahve Dünyası', 'magazalar': 'Shell Select,Yöresel Ürünler', 'sarjIstasyonlari': 'Trugo (180 kW DC)' 
    });
    await db.insert('istasyonlar', {
      'otobanId': 4, 'istasyonAdi': 'Bolu Dağı Koru Tesisleri (Shell)', 'kmBilgisi': 185, 
      'benzinFiyati': 41.40, 'motorinFiyati': 43.30, 'lpgFiyati': 21.70,
      'restoranlar': 'Bolu Mangal Evi,Gloria Jean\'s', 'magazalar': 'Levi\'s,Shell Select', 'sarjIstasyonlari': 'ZES (300 kW DC)' 
    });
    await db.insert('istasyonlar', {
      'otobanId': 4, 'istasyonAdi': 'Highway Outlet Dinlenme (PO)', 'kmBilgisi': 220, 
      'benzinFiyati': 40.50, 'motorinFiyati': 42.40, 'lpgFiyati': 21.00, // 🎯 EN UCUZ
      'restoranlar': 'Hatay Dönercisi,Usta Dönerci', 'magazalar': 'Boyner,PO Market', 'sarjIstasyonlari': 'Voltrun Şarj' 
    });

    // ==========================================
    // 🌟 O-5 GEBZE - ORHANGAZİ - İZMİR OTOYOLU
    // ==========================================
    await db.insert('istasyonlar', {
      'otobanId': 5, 'istasyonAdi': 'Oksijen 37 (Shell)', 'kmBilgisi': 37, 
      'benzinFiyati': 41.80, 'motorinFiyati': 43.70, 'lpgFiyati': 22.10,
      'restoranlar': 'Kasap Döner,Starbucks', 'magazalar': 'Mudo,Shell Select', 'sarjIstasyonlari': 'ZES & Trugo Dev Şarj Parkı' 
    });
    await db.insert('istasyonlar', {
      'otobanId': 5, 'istasyonAdi': 'Oksijen 111 Gemlik (Opet)', 'kmBilgisi': 111, 
      'benzinFiyati': 41.00, 'motorinFiyati': 42.80, 'lpgFiyati': 21.30, // 🎯 EN UCUZ
      'restoranlar': 'Köfteci Yusuf,Espressolab', 'magazalar': 'Migros Jet,Hediyelik Eşya', 'sarjIstasyonlari': 'Eşarj (60 kW AC)' 
    });
    await db.insert('istasyonlar', {
      'otobanId': 5, 'istasyonAdi': 'Oksijen 224 Susurluk (PO)', 'kmBilgisi': 224, 
      'benzinFiyati': 41.40, 'motorinFiyati': 43.25, 'lpgFiyati': 21.60,
      'restoranlar': 'Yasa Tost,Nero Cafe', 'magazalar': 'PO Market,D&R Mağazası', 'sarjIstasyonlari': 'Trugo (180 kW DC)' 
    });

    // ==========================================
    // 🌟 O-7 KUZEY MARMARA OTOYOLU
    // ==========================================
    await db.insert('istasyonlar', {
      'otobanId': 6, 'istasyonAdi': 'Fenertepe Bi Mola (Opet)', 'kmBilgisi': 45, 
      'benzinFiyati': 41.60, 'motorinFiyati': 43.50, 'lpgFiyati': 21.90,
      'restoranlar': 'HD İskender,Caribou Coffee', 'magazalar': 'Ultramarket', 'sarjIstasyonlari': 'ZES (180 kW DC)'
    });
    await db.insert('istasyonlar', {
      'otobanId': 6, 'istasyonAdi': 'Kurnaköy Bi Mola (Shell)', 'kmBilgisi': 110, 
      'benzinFiyati': 41.20, 'motorinFiyati': 43.10, 'lpgFiyati': 21.50, // 🎯 EN UCUZ
      'restoranlar': 'Subway,Tchibo', 'magazalar': 'Shell Select', 'sarjIstasyonlari': 'Eşarj (300 kW DC)'
    });
    await db.insert('istasyonlar', {
      'otobanId': 6, 'istasyonAdi': 'Sevindikli Bi Mola (BP)', 'kmBilgisi': 175, 
      'benzinFiyati': 41.80, 'motorinFiyati': 43.70, 'lpgFiyati': 22.10,
      'restoranlar': 'Pidem,Çaykur Çadırı', 'magazalar': 'BP Express', 'sarjIstasyonlari': 'Trugo (120 kW DC)'
    });

    // ==========================================
    // 🌟 O-21 ANKARA - NİĞDE - TARSUS OTOYOLU
    // ==========================================
    await db.insert('istasyonlar', {
      'otobanId': 7, 'istasyonAdi': 'Kulu Makas Tesisleri (Opet)', 'kmBilgisi': 85, 
      'benzinFiyati': 41.30, 'motorinFiyati': 43.20, 'lpgFiyati': 21.70,
      'restoranlar': 'Şefin Tavası,Simit Sarayı', 'magazalar': 'Ultramarket', 'sarjIstasyonlari': 'Trugo (180 kW DC)'
    });
    await db.insert('istasyonlar', {
      'otobanId': 7, 'istasyonAdi': 'Şereflikoçhisar Tuz Gölü (Shell)', 'kmBilgisi': 140, 
      'benzinFiyati': 40.80, 'motorinFiyati': 42.60, 'lpgFiyati': 21.15, // 🎯 EN UCUZ
      'restoranlar': 'Ankara Dönercisi,Kahve Dünyası', 'magazalar': 'Yöresel Pazar,Shell Select', 'sarjIstasyonlari': 'ZES (120 kW DC)'
    });
    await db.insert('istasyonlar', {
      'otobanId': 7, 'istasyonAdi': 'Niğde Gişeleri (BP)', 'kmBilgisi': 245, 
      'benzinFiyati': 41.50, 'motorinFiyati': 43.40, 'lpgFiyati': 21.80,
      'restoranlar': 'Sandviç İstasyonu,Cold Brew Noktası', 'magazalar': 'BP Express', 'sarjIstasyonlari': 'Eşarj (60 kW AC)' 
    });

    // ==========================================
    // 🌟 O-32 İZMİR - ÇEŞME OTOYOLU
    // ==========================================
    await db.insert('istasyonlar', {
      'otobanId': 8, 'istasyonAdi': 'Urla Karayolu Hizmet Alanı (Shell)', 'kmBilgisi': 22, 
      'benzinFiyati': 41.70, 'motorinFiyati': 43.60, 'lpgFiyati': 21.90,
      'restoranlar': 'Pizza Hut,Kumrucu Şevki', 'magazalar': 'Shell Select', 'sarjIstasyonlari': 'Trugo (180 kW DC)'
    });
    await db.insert('istasyonlar', {
      'otobanId': 8, 'istasyonAdi': 'Zeytinler Tesis Alanı (Opet)', 'kmBilgisi': 45, 
      'benzinFiyati': 40.90, 'motorinFiyati': 42.80, 'lpgFiyati': 21.20, // 🎯 EN UCUZ
      'restoranlar': 'Alaçatı Muhallebicisi,Espressolab', 'magazalar': 'Ultramarket', 'sarjIstasyonlari': 'Eşarj (120 kW DC)'
    });
    await db.insert('istasyonlar', {
      'otobanId': 8, 'istasyonAdi': 'Çeşme Otoban Çıkışı (PO)', 'kmBilgisi': 64, 
      'benzinFiyati': 41.40, 'motorinFiyati': 43.30, 'lpgFiyati': 21.60,
      'restoranlar': 'İzmir Boyoz Salonu,Filtre Kahve Dünyası', 'magazalar': 'PO Market', 'sarjIstasyonlari': 'Voltrun Ev Şarjı'
    });

    // ==========================================
    // 🌟 O-52 ADANA - GAZİANTEP - ŞANLIURFA OTOYOLU
    // ==========================================
    await db.insert('istasyonlar', {
      'otobanId': 9, 'istasyonAdi': 'Misis Tesis Alanı (Shell)', 'kmBilgisi': 30, 
      'benzinFiyati': 41.10, 'motorinFiyati': 43.00, 'lpgFiyati': 21.40,
      'restoranlar': 'Adana Kebapçısı,Künefe Salonu', 'magazalar': 'Shell Select', 'sarjIstasyonlari': 'ZES Hızlı Şarj' 
    });
    await db.insert('istasyonlar', {
      'otobanId': 9, 'istasyonAdi': 'Nurdağı Geçidi Tepesi (PO)', 'kmBilgisi': 125, 
      'benzinFiyati': 40.40, 'motorinFiyati': 42.20, 'lpgFiyati': 20.80, // 🎯 EN UCUZ
      'restoranlar': 'Zurna Döner,Çorba Dünyası', 'magazalar': 'PO Market,Yöresel Gurme Tatlar', 'sarjIstasyonlari': 'Trugo (180 kW DC)' 
    });
    await db.insert('istasyonlar', {
      'otobanId': 9, 'istasyonAdi': 'Gaziantep Batı Giriş (Opet)', 'kmBilgisi': 195, 
      'benzinFiyati': 41.30, 'motorinFiyati': 43.20, 'lpgFiyati': 21.60,
      'restoranlar': 'İmam Çağdaş Baklava,Beyran Salonu', 'magazalar': 'Ultramarket', 'sarjIstasyonlari': 'Eşarj (6 Soket)' 
    });
    await db.insert('istasyonlar', {
      'otobanId': 9, 'istasyonAdi': 'Şanlıurfa Birecik Tesisleri (BP)', 'kmBilgisi': 285, 
      'benzinFiyati': 41.50, 'motorinFiyati': 43.40, 'lpgFiyati': 21.70,
      'restoranlar': 'Urfa Ciğercisi,Mırra Kahve Evi', 'magazalar': 'BP Express', 'sarjIstasyonlari': 'ZES (120 kW DC)' 
    });
  }

  Future<List<Otoban>> getOtobanlar() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('otobanlar');
    return List.generate(maps.length, (i) => Otoban.fromMap(maps[i]));
  }

  Future<List<Istasyon>> getIstasyonlar({required int otobanId, required String yakitTuru}) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'istasyonlar',
      where: 'otobanId = ?',
      whereArgs: [otobanId],
    );
    return List.generate(maps.length, (i) => Istasyon.fromMap(maps[i]));
  }
}