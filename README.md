# Tonefy 🎶
### Experience Music in its Purest Form. Effortlessly.

[![Flutter](https://img.shields.io/badge/Flutter-3.22+-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-F7DF1E?style=for-the-badge)](https://opensource.org/licenses/MIT)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS-lightgrey?style=for-the-badge)](#)

**Tonefy** is a high-performance, minimalist music player crafted with precision. Designed for enthusiasts who value both aesthetics and audio fidelity, Tonefy provides a seamless bridge between your local audio library and a premium listening experience.

---

## ✨ Features

- **🚀 Native-Grade Performance**: Powered by a highly optimized audio engine for ultra-low latency playback.
- **🎨 Modern Glassmorphism UI**: A sleek, intuitive interface with smooth transitions and dynamic color palettes.
- **📁 Smart Library Indexing**: Automatically scans and organizes your local audio collection with metadata support.
- **🎛️ Immersive Player**: Features circular progress sliders, animated musical notes, and high-fidelity artwork rendering.
- **🎧 Background Services**: Full `audio_service` integration for persistent playback and lock-screen controls.
- **🌑 Dark Mode Excellence**: Meticulously designed for low-light environments with premium charcoal gradients.

---

## 📸 Screenshots

<p align="center">
  <img src="assets/Screenshot 2026-02-28 044938.png" width="22%" alt="Home Screen" />
  <img src="screenshots/player.png" width="22%" alt="Player View" />
  <img src="screenshots/playlist.png" width="22%" alt="Library" />
  <img src="screenshots/settings.png" width="22%" alt="Settings" />
</p>

---

## 🛠️ Tech Stack & Architecture

Tonefy is built using **Feature-Driven Clean Architecture**, ensuring the codebase remains scalable, testable, and maintainable.

### Core Dependencies
| Package | Category | Purpose |
| :--- | :--- | :--- |
| **just_audio** | Audio Engine | Feature-rich playback for local & network streams |
| **flutter_bloc** | State Management | Predictable state handling using the Cubit pattern |
| **on_audio_query** | Data Source | Advanced local audio querying and metadata extraction |
| **get_it** | Dependency Injection | Centralized service locator for decoupled components |
| **hive** | Persistence | Blazing fast local storage for favorites and settings |
| **dartz** | Utils | Functional programming patterns for error handling |

### Project Organization
```text
lib/
├── core/             # App-wide themes, constants, and network configs
├── common/           # Shared UI components and global helper functions
├── data/             # Repository implementations and data sources (Hive/SQL)
├── domain/           # Pure business logic: Entities and Use Case definitions
├── presentation/     # UI Layer: Screens, Widgets, and Cubit logic
│   ├── home/         # Dashboard and Library management
│   └── song_player/  # Immersive playback experience
└── service_locator/  # Dependency registration and setup
```

---

## 🚀 Getting Started

### Prerequisites
- **Flutter SDK**: `^3.10.8` or higher
- **Android**: API Level 21+ (Lollipop)
- **iOS**: 11.0+
- **Editor**: VS Code (Recommended) or Android Studio

### Installation

1. **Clone the Project**
   ```bash
   git clone https://github.com/Omar-Einstein7/Tonefy.git
   cd Tonefy
   ```

2. **Install Dependencies**
   ```bash
   flutter pub get
   ```

3. **Run Code Generation**
   (Required for Hive adapters and dependency injection)
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. **Launch the App**
   ```bash
   flutter run
   ```

---

## 🤝 Contributing

Contributions are what make the open-source community such an amazing place to learn, inspire, and create.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📄 License

Distributed under the **MIT License**. See [LICENSE](LICENSE) for more information.

---

## ✉️ Contact

**Omar Ahmed** - omar.ahmed.dev2004@gmail.com

Project Link: [https://github.com/Omar-Einstein7/Tonefy](https://github.com/Omar-Einstein7/Tonefy)

---
<p align="center">Made with ❤️ for Music Lovers</p>
