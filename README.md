# Treat 🍰✨
> Funky Foodie Feasts, Group Deals & Floor Management Application

**Treat** is a cross-platform mobile and web application built with Flutter, designed for modern foodies, squads, and restaurant kitchens. It brings together social dining, dynamic platter deals, automated smart budget matching, and real-time floor reservation management.

---

## 🚀 Key Features

### 🍴 Diner Experience
- **Explore & Promotions**: Curated trending treats, 2-for-1 platter deals, flash perks, and feast spots.
- **Smart Treat Budget Matcher**: Dynamically calculate dining budgets per person, party sizes, and tax inclusion to auto-match the best platter feast boards.
- **2-Minute Instant Hold**: Inquire and hold tables live with real-time countdown timers, interactive digital confirmation slips, and QR vouchers.
- **Community Food Bar & Social**: Live food bar chatter, honest bite reviews, social photo feeds, and squad savings leaderboards.
- **Favorites & Loved Spots**: Bookmark top dining spots, track walking distance, ratings, and instant squad deals.
- **Faithful Stitch Design**: High-fidelity UI featuring two-tier glassmorphic headers, stylized 3-line hamburger bar, and a slide-out profile drawer.

### 🍳 Kitchen Mode & Floor Management
- **PIN Keypad Portal**: Secure staff terminal login for restaurant partners.
- **Live Floor Manager**: Real-time table states (Free, Reserved, Dining, Cleaning), cross-role sync, and instant inquiry approvals or declines.
- **Cross-Role Sync**: Reactive backend state coordinating diner holds directly with kitchen floor status in real-time.

---

## 🛠️ Tech Stack
- **Framework**: Flutter (Dart)
- **State Management**: Provider (`ChangeNotifier`, `MultiProvider`)
- **Typography & Styling**: Google Fonts (Plus Jakarta Sans, DM Sans), centralized `TreatColors` design tokens.
- **Architecture**: Domain models, reactive mock backend stream controllers, screen shell routing.

---

## 🏃 Running Locally

### Prerequisites
- [Flutter SDK](https://flutter.dev/docs/get-started/install) (3.x or higher)
- Google Chrome or Edge (for web preview) or Android/iOS emulator

### Run on Web
```bash
flutter run -d web-server --web-port 8080 --web-hostname localhost
```
Open [http://localhost:8080](http://localhost:8080) in your browser.

### Run on Chrome
```bash
flutter run -d chrome
```

### Run Tests
```bash
flutter test
```

---

## 📁 Project Structure
```
lib/
├── core/
│   ├── constants/
│   └── theme/               # Colors, typography, and theme definitions
├── models/                  # Domain models (PlatterDeal, Reservation, TableInfo, DinerPersona)
├── screens/
│   ├── diner/               # Diner screens (Home, Budget, Platters, Social, Favorites, etc.)
│   ├── kitchen/             # Kitchen partner portal, dashboard & floor manager
│   └── app_shell.dart       # Responsive device frame and screen routing
├── services/                # TreatMockBackend reactive streams & simulated cross-role state
├── state/                   # Providers (BookingState, BudgetPlannerState, DinerState, KitchenPartnerState)
└── widgets/                 # Reusable UI components (TreatHeader, DinerDrawer, TreatBottomNavBar, etc.)
```

---

## 📄 License
MIT License
