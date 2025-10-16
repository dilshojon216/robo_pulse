# 🤖 RoboPulse - Advanced Robot Control System

<div align="center">

**Real-time WebSocket orqali robot boshqaruvi va kamera stream**

[![Flutter](https://img.shields.io/badge/Flutter-3.35.6-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.0+-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![Platform](https://img.shields.io/badge/Platform-Android%20|%20iOS-green)](#)

</div>

## 📋 Umumiy ma'lumot

RoboPulse - bu zamonaviy Flutter ilovasie bo'lib, USB Serial orqali ulangan robotlarni real-time WebSocket protokoli orqali boshqarish imkonini beradi. Ilova yuqori sifatli kamera stream, signal boshqaruvi va professional UI/UX dizayni bilan jihozlangan.

## ✨ Asosiy xususiyatlar

### 🎮 Robot Boshqaruvi
- **Real-time harakat nazorati** - Yo'nalish tugmalari (Oldinga, Orqaga, Chapga, O'ngga)
- **Tezlik boshqaruvi** - 0-255 oralig'ida sozlanuvchi slider
- **Signal funksiyalari** - Ovozli signal va chiroq boshqaruvi
- **Xavfsizlik mexanizmi** - Avtomatik to'xtatish aloqa uzilganda

### 📹 Kamera Stream
- **Real-time video** - 500ms interval bilan yangilanuvchi stream
- **IPWebcam qo'llab-quvvatlash** - HTTP orqali JPEG frames
- **Xato boshqaruvi** - Connection issues uchun fallback UI

### 🔧 Sozlamalar
- **Tezkor presetlar** - Umumiy IP konfiguratsiyalar
- **Qo'lda sozlash** - Custom IP, port va API key
- **Avtomatik saqlash** - SharedPreferences orqali

### 📊 Monitoring
- **Connection status** - WebSocket, USB, Kamera holati
- **Network latency** - Real-time ping ko'rsatkichi  
- **Batafsil loglar** - Rang kodli log entries

## 🎨 Dizayn Tili

### Rang Palitra
| Rang nomi | Hex kod | Qo'llanish |
|-----------|---------|------------|
| **Primary Blue** | `#0057FF` | Asosiy urg'u, yurak urishi chizig'i |
| **White** | `#FFFFFF` | Fon, robot belgisi |
| **Dark Gray** | `#333333` | Matn, kontrast |
| **Signal Red** | `#E53935` | Xavfsizlik signallari |
| **Light Gray** | `#F4F4F4` | Qo'shimcha fonlar |

### Typography
- **Poppins** - Logo va sarlavhalar uchun
- **Roboto** - Asosiy matn va UI elementlari

## 🚀 O'rnatish va Ishga tushirish

### Talablar
- **Flutter SDK**: 3.35.6+
- **Dart**: 3.0+
- **Android**: API level 21+ (Android 5.0+)

### O'rnatish
```bash
# Repository ni clone qilish
git clone https://github.com/yourusername/robo_pulse.git
cd robo_pulse

# Dependencies ni o'rnatish
flutter pub get

# Android qurilmada ishga tushirish
flutter run

# Release build yaratish
flutter build apk --release
```

### Backend Konfiguratsiya
RoboPulse RoboBridge backend bilan ishlaydi:

```yaml
# Default sozlamalar
Robot IP: 192.168.100.208
WebSocket Port: 5050
API Key: robo-bridge-default-key-change-me
Camera Port: 8080 (IPWebcam)
```

## 📱 Foydalanish

### 1. Birinchi ulanish
1. **Sozlamalar** tabiga o'ting
2. Robot va kamera IP manzillarini kiriting
3. **Saqlash** tugmasini bosing
4. AppBar da **Ulash** tugmasini bosing

### 2. Robot boshqaruvi
- **Yo'nalish tugmalari** - Robot harakatini boshqarish
- **Tezlik slider** - Harakat tezligini sozlash (0-255)
- **STOP tugmasi** - Favqulodda to'xtatish
- **Signal tugmalari** - Ovoz va chiroq signallari

## 🔧 API Reference

### WebSocket Commands
```javascript
// Harakat buyrug'i
{
  "action": "move",
  "dir": 1,        // 1=oldinga, 2=orqaga, 3=chapga, 4=o'ngga
  "speed": 150     // 0-255
}

// To'xtatish
{
  "action": "stop",
  "mode": 0        // 0=zudlik, 1=sekin
}
```

---

**© 2025 RoboPulse - Advanced Robot Control System**

Made with ❤️ and Flutter
