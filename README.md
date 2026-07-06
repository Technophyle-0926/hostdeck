# 🚀 HostDeck

<div align="center">
  <h3>Manage and monitor multiple AppHost accounts seamlessly with HostDeck</h3>
</div>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" />
  <img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white" />
  <img src="https://img.shields.io/badge/GetX-FF3333?style=for-the-badge" />
  <img src="https://img.shields.io/badge/Isar-Database-blue?style=for-the-badge" />
</p>

## ✨ Features

- **Multi-Account Management:** Seamlessly add, manage, and switch between multiple AppHost accounts.
- **Build Monitoring:** Track and aggregate builds across your linked accounts.
- **Secure Storage:** Uses `flutter_secure_storage` and `Isar` to ensure your account credentials and local data are safe and performant.
- **Modern UI:** Built with Flutter, featuring a beautiful and responsive dashboard and dark/light theme support.
- **Clean Architecture:** Structured cleanly for maintainability and scalability, leveraging `GetX` for state management.

## 🛠️ Tech Stack

- **Framework:** [Flutter](https://flutter.dev/)
- **State Management & Routing:** [GetX](https://pub.dev/packages/get)
- **Local Database:** [Isar Database](https://isar.dev/)
- **Networking:** [Dio](https://pub.dev/packages/dio)
- **Secure Storage:** [Flutter Secure Storage](https://pub.dev/packages/flutter_secure_storage)

## 📂 Project Structure

- `lib/core/` - Core components, themes, and utilities.
- `lib/data/` - Data layer (Models, local database via Isar, remote API clients).
- `lib/domain/` - Domain layer (Repositories, abstract definitions).
- `lib/presentation/` - UI layer (Screens, Widgets, Controllers/State).
- `lib/routes/` - App navigation routes.

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (v3.41.7 or newer)
- Dart SDK (3.11.5 or newer)
- Android Studio / VS Code (with Flutter extensions)

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/Technophyle-0926/hostdeck.git
   ```
2. Navigate to the project directory:
   ```bash
   cd hostdeck
   ```
3. Get the dependencies:
   ```bash
   flutter pub get
   ```
4. Run the code generator for Isar:
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```
5. Run the app:
   ```bash
   flutter run
   ```

## 📜 License

Copyright © 2026 Meet Vishavadia. All rights reserved.
