# Unit Converter (Flutter/Dart)

> MSCS533 – Software Engineering & Multiplatform App Development — **Assignment 1**

A simple Flutter app that converts values between **metric** and **imperial** systems across three categories: **Length**, **Weight**, and **Temperature**. Built with a clean GUI, pure conversion logic, and a tiny widget smoke test.

---

## ✨ Features

* Categories: **Temperature**, **Length**, **Weight**
* Mix and match metric/imperial (e.g., miles → km, kg → lb, °F → °C)
* **Swap** From/To units
* Input validation with snack‑bar feedback
* Material 3 dark theme + refined GUI layout
* Separation of concerns: UI ↔︎ conversion service
* Test: widget smoke test keyed on `ValueKey('app-title')`

---

## 🧱 Project Structure

```
lib/
  main.dart                 # App root (UnitConverterApp)
  unit_converter_gui.dart   # GUI (Cupertino segmented control, dropdowns, etc.)
  conversions.dart          # Pure, testable conversion utilities

test/
  widget_test.dart          # GUI smoke test (uses ValueKey('app-title'))

ios/Runner/Info.plist       # Include if you submit iOS artifacts
```

---

## 🚀 Getting Started

### Prerequisites

* Flutter **3.35.x**
* Dart **3.9.x**
* macOS with Xcode (for iOS) and CocoaPods

### Run on iOS Simulator

```bash
flutter pub get
open -a Simulator
flutter devices             # confirm a Simulator shows up
flutter run -d ios
```

### Run tests

```bash
flutter test
```

### Lint & format

```bash
dart format .
dart analyze
```

---

## 🧮 Conversions (reference)

**Length (base: meters)**

* 1 **in** = 0.0254 **m**
* 1 **ft** = 0.3048 **m**
* 1 **yd** = 0.9144 **m**
* 1 **mi** = 1609.344 **m**

**Weight (base: grams)**

* 1 **oz** = 28.349523125 **g**
* 1 **lb** = 453.59237 **g**

**Temperature**

* °F → °C: `(F − 32) × 5/9`
* °C → °F: `(C × 9/5) + 32`
* K ↔︎ °C: `C = K − 273.15`, `K = C + 273.15`

---

## 🧭 How to Use

1. Pick a **Category** (Temperature/Length/Weight)
2. Enter a numeric **Value**
3. Select **From** and **To** units
4. Tap **Swap** to flip units
5. Result updates instantly
