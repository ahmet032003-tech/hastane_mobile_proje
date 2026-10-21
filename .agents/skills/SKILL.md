```markdown
---
name: hospital-automation-scaffolder
description: MedAuto uygulaması için hasta ve doktor portallarını, 4 adımlı randevu alma akışını, reçete/ilaç takip sistemini, radyoloji/tahlil görüntüleme ekranlarını ve ValueNotifier state mimarisini üreten teknik şartnamedir.
---

# Hastane Otomasyonu Ekran ve Modül Şartnamesi

Bu yetenek, projenin hem hasta hem de doktor ayağındaki tüm akışların Feature-First mimarisine ve koyu tema standartlarına uygun olarak üretilmesini sağlar.

---

## 1. Hasta Modülleri

### 1.1. Hasta Giriş Ekranı (`features/patient_auth`)
- **Alanlar:** T.C. Kimlik No (11 hane), Şifre (gizle/göster ikonu), Giriş Yap butonu.
- **Şifre Altı Bölümü:** "Hesabınız yok mu? Kayıt Ol" ve "S.S.S." bağlantıları.
- **Kural:** Geçersiz veya kayıtsız girişte hata gösterilir ve kullanıcı kayıt ekranına yönlendirilir.

### 1.2. Hasta Ana Sayfası (`features/patient_home`)
- **Üst Bölüm:** Hasta profil resmi, ad-soyad, son hastane ziyareti tarihi, son muayene eden doktor ve branş bilgisi.
- **Kişisel Sağlık Verileri:** Boy, kilo, hesaplanan BMI ve aktif kullanılan ilaç sayısı kutucukları.
- **Aktif Hastalıklar:** Hastanın sahip olduğu kronik/aktif tanılar yatay chip etiketleri olarak listelenir.
- **Alt Navigasyon:** 4 sekme (Randevu Al, İlaçlar/Reçeteler, Radyoloji/Tahliller, Profil).

### 1.3. Hasta Profil Sayfası (`features/patient_profile`)
- **İçerik:** Büyük hasta profil resmi, ad-soyad, T.C. kimlik numarası.
- **Kişisel Bilgiler Listesi:** Doğum tarihi, cinsiyet, kan grubu, telefon, e-posta ve ikametgah bilgisi satırları.

### 1.4. Randevu Alma Akışı (`features/appointment_booking`)
4 adımlı sıralı seçim sihirbazı:
1. **Hastane Seçimi:** Arama ve mesafe bilgili hastane listesi.
2. **Bölüm Seçimi:** Seçilen hastaneye ait poliklinikler.
3. **Doktor Seçimi:** İlgili branştaki hekimler (fotoğraf, unvan, değerlendirme puanı).
4. **Tarih & Saat Seçimi:** Gün seçici ve sabah/öğle saat slotları (dolu saatler pasif).
- **Onay Modalı:** Seçimlerin özeti ve "Randevuyu Onayla" butonu.

### 1.5. İlaçlar ve Reçeteler (`features/medications`)
- **Sıralama:** Varsayılan olarak en yakın/en yeni tarihten en eski tarihe doğru listelenir.
- **Filtreler:** En uzaktan en yakına sıralama seçeneği, hastalık/tanı bazlı filtre chipleri, ilaç arama alanı.
- **İlaç Detay Kartı (Tıklandığında):** İlacı yazan hekim, yazılma gerekçesi (hastalık), son kullanım tarihi ve kullanım talimatı (aç/tok, dozaj sıklığı).

### 1.6. Radyoloji ve Tahliller (`features/medical_tests`)
- **Sıralama & Filtreleme:** İlaçlar ile aynı filtreleme mantığı (en yeni -> en eski, tahlil/radyoloji kategori ayrımı, arama).
- **Detay Kartı (Tıklandığında):** İstemde bulunan hekim, istem gerekçesi/amacı, radyoloji görseli (zoom/tam ekran desteği) veya laboratuvar değer tablosu (referans aralıklarıyla), uzman/hekim açık klinik yorumu.

---

## 2. Doktor Modülleri

### 2.1. Doktor Giriş Ekranı (`features/doctor_auth`)
- **Alanlar:** T.C. / Diploma Tescil No, Kurum Kodu, Şifre.
- **Bağlantılar:** "Şifremi Unuttum" ve "Kurumsal Bilgi İşlem / S.S.S.".

### 2.2. Doktor Dashboard & Poliklinik Masası (`features/doctor_dashboard`)
- **Üst Bölüm:** Hekim görseli, unvan, ad-soyad, poliklinik adı ve muayene durumu anahtarı (Açık/Mola).
- **Operasyon Metrikleri:** Günlük toplam randevu, tamamlanan muayene, bekleyen hasta sayısı.
- **Sıradaki Hasta:** Kapıdaki hastanın adı, saati, şikayeti ve "Muayeneyi Başlat" butonu.

### 2.3. Doktor Alt Menüsü
1. **Randevu Listesi:** Günlük saatlik hasta akışı.
2. **E-Reçete Masası:** İlaç yazma ve dozaj belirleme.
3. **İstem Merkezi:** Tetkik istemi oluşturma ve sonuç raporlama/yorumlama.
4. **Doktor Profili:** Çalışma takvimi ve slot yönetimi.