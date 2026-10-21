# MedAuto Hastane Otomasyonu Proje Şartnamesi ve Kuralları

Bu belge, MedAuto hastane otomasyon sisteminin mimari, kodlama ve tasarım kurallarını belirler.

---

## 1. Mimari Prensipler (Feature-First)

Proje, özellik odaklı modüler (Feature-First) bir klasör yapısını benimser. Her özellik kendi içinde bağımsız ve test edilebilir olmalıdır:

```
lib/
├── core/
│   ├── theme/          # Koyu tema renkleri, tipografi, component temaları
│   ├── constants/      # Sabit değerler, etiketler ve konfigürasyon
│   └── utils/          # Yardımcı doğrulama ve formatlama fonksiyonları
├── features/
│   └── [feature_name]/ # Özellik modülü (örn: patient_auth, patient_home)
│       ├── models/     # Durum ve veri modelleri (State / DTO)
│       ├── controllers/# ValueNotifier tabanlı iş mantığı ve durum yöneticileri
│       ├── widgets/    # Modüle özel yeniden kullanılabilir UI bileşenleri
│       └── views/      # Ekran sayfaları (ValueListenableBuilder dinleyicileri)
└── main.dart           # Uygulama başlangıcı ve tema konfigürasyonu
```

---

## 2. Durum Yönetimi (State Management) Standartları

- Harici ağır durum yönetimi kütüphaneleri yerine Flutter'ın yerel ve reaktif **`ValueNotifier<T>`** ve **`ValueListenableBuilder<T>`** mimarisi kullanılır.
- State sınıfları `immutable` (değişmez) olmalı, tüm alanlar `final` tanımlanmalı ve `copyWith` metodu barındırmalıdır.
- Controller sınıfları `ValueNotifier<TState>` sınıfından kalıtım almalı (`extends ValueNotifier<TState>`), durum güncellemelerini `value = value.copyWith(...)` şeklinde yapmalıdır.
- Controller'lar dispose edilebilir olmalı ve bellek sızıntısına (memory leak) yol açmamalıdır.
- View katmanı yalnızca reaktif dinleme ve kullanıcı etkileşimini iletme görevini üstlenmelidir.

---

## 3. Tasarım ve Koyu Tema (Dark Mode) Standartları

Uygulama modern, lüks ve göz yormayan bir sağlık teknolojisi koyu temasına (Medical Dark Aesthetic) sahip olmalıdır:

- **Arka Plan:** Koyu Grafit / Gece Mavisi (`#0A0F1D`, `#0F172A`)
- **Kart ve Yüzeyler:** Koyu Arduvaz (`#1E293B`, `#162032`)
- **Vurgu / Birincil Renk:** Medikal Camgöbeği / Canlı Turkuaz (`#0EA5E9`, `#06B6D4`, `#14B8A6`)
- **Metin Renkleri:** 
  - Birincil: `#F8FAFC`
  - İkincil: `#94A3B8`
  - İpucu / Placeholder: `#64748B`
- **Hata ve Durum Renkleri:** 
  - Hata / Uyarı: `#EF4444`, `#F87171`
  - Başarı: `#10B981`
- **Görsel Standartlar:**
  - Yuvarlatılmış köşeler (`BorderRadius.circular(12)` - `BorderRadius.circular(16)`)
  - Hafif kenarlıklar (`border: Border.all(color: Color(0xFF334155))`)
  - Yumuşak mikroyansımalar, gölgeler ve geçişler.

---

## 4. `patient_auth` Modülü Kuralları

1. **Giriş Alanları:**
   - **T.C. Kimlik No:** Yalnızca rakam girilebilir, tam 11 hane olmalıdır, 11 haneden az veya fazla giriş kabul edilmez.
   - **Şifre:** En az 6 karakter olmalıdır. Gizle/Göster (eye / eye_off) butonu ile görünürlüğü değiştirilebilir.
2. **Şifre Altı Bağlantıları:**
   - "Hesabınız yok mu? Kayıt Ol" ve "S.S.S." bağlantı butonları yer almalıdır.
3. **Doğrulama ve Hata Yönetimi:**
   - Geçersiz T.C. (11 hane olmayan) veya boş şifre durumunda kullanıcıya bilgilendirici hata mesajı gösterilir.
   - Tanımsız/kayıtsız kullanıcı giriş denemesinde hata mesajı verilir ve `shouldRedirectToRegister` bayrağı aktif edilerek kullanıcı kayıt olmaya teşvik edilir/yönlendirilir.
4. **Kod Kalitesi:**
   - `flutter analyze` ile 0 hata (warning/error/lint free) sağlanmalıdır.
