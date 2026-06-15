# 🛣️ OTAN - Otoyol Tesis ve Akaryakıt Navigasyonu

OTAN (Otoyol Tesis ve Akaryakıt Navigasyonu), özellikle uzun mesafeli seyahatlerde sürücülerin akaryakıt bütçelerini optimize etmelerini sağlamak, yol üstü tesis imkanlarını listelemek ve elektrikli araç (EV) şarj rotalarını planlamak amacıyla geliştirilmiş modern bir mobil navigasyon uygulamasıdır.

---

## 📌 Çıkış Hikayesi ve Amacı

Bu proje, uzun yolculuklarda karşılaşılan gerçek bir problemden yola çıkılarak geliştirilmiştir. İstanbul - Kilis otoyol hattı başta olmak üzere, şehirler arası seyahat eden sürücülerin güzergah üzerindeki hangi tesiste en uygun fiyatlı yakıtın yer aldığını dinamik olarak görebilmesi, mola yerlerindeki sosyal imkanları inceleyebilmesi ve elektrikli araçlar için şarj istasyonu duraklarını planlayabilmesi hedeflenmiştir.

---

## 🚀 Öne Çıkan Özellikler

* **Bütçe Optimizasyonu:** Rota üzerindeki akaryakıt istasyonlarının fiyatlarını otomatik olarak kıyaslar ve en avantajlı istasyona **"EN UCUZ"** rozeti tanımlar.
* **Elektrikli Araç (EV) Rota Planlama:** Güzergahtaki geleneksel istasyonları filtreleyerek yalnızca bünyesinde aktif şarj altyapısı (Trugo, ZES, Eşarj vb.) bulunduran tesisleri listeler.
* **Detaylı Tesis Bilgisi:** İstasyonların sadece yakıt fiyatlarını değil; market, dinlenme alanları ve yeme-içme (Zurna Döner vb.) imkanlarını mikro düzeyde sunar.
* **Canlı Sürüş Simülasyonu:** Üçüncü parti harita API'larına bağımlı kalmadan, kalan mesafe ve süre bilgisini dinamik olarak geri sayan yerel bir simülasyon motoru barındırır.
* **Yerel Veri Yönetimi:** Güvenli ve hızlı bir deneyim için tüm otoyol ve tesis verilerini cihaz yerelinde SQLite ilişkisel veritabanı ile yönetir.

---

## 🛠️ Kullanılan Teknolojiler

* **Framework:** [Flutter](https://flutter.dev) (Dart)
* **Veritabanı:** SQLite (Yerel Veri Yönetimi)
* **Mimari Düzen:** Clean Architecture / Modüler Yapı

---

## 📦 Kurulum ve Çalıştırma

Projeyi yerel ortamınızda test etmek ve çalıştırmak için aşağıdaki adımları izleyebilirsiniz:

1.  **Projeyi Klonlayın:**
    ```bash
    git clone [https://github.com/keremh9/Otan-Navigasyon-Uygulamas-.git](https://github.com/keremh9/Otan-Navigasyon-Uygulamas-.git)
    cd Otan-Navigasyon-Uygulamas-
    ```

2.  **Bağımlılıkları Yükleyin:**
    ```bash
    flutter pub get
    ```

3.  **Uygulamayı Çalıştırın:**
    ```bash
    flutter run
    ```

---

## 👨‍💻 Geliştirici

* **Mehmet Kerem Hakan** - [GitHub Profili](https://github.com/keremh9)

---

## 📄 Lisans

Bu proje [MIT](LICENSE) lisansı ile korunmaktadır.
