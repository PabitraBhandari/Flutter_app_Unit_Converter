/// Conversion utilities kept pure and testable.
/// The GUI passes category/unit labels as strings, so this service accepts
/// those labels directly to keep wiring simple.
library;

class ConverterService {
  /// Convets [value] from [fromUnit] to [toUnit] within [category].
  /// Throws [ArgumentError] for unsupported units.

  static double convert({
    required String category,
    required String fromUnit,
    required String toUnit,
    required double value,
  }) {
    if (fromUnit == toUnit) return value; // no -op

    switch (category) {
      case 'Length':
        final meters = _lengthToMeters(value, fromUnit);
        return _metersToLength(meters, toUnit);
      case 'Weight':
        final grams = _weightToGrams(value, fromUnit);
        return _gramsToWeight(grams, toUnit);
      case 'Temperature':
        return _temperatureConvert(value, fromUnit, toUnit);
      default:
        throw ArgumentError('Unsupported category: $category');
    }
  }

  // ---------------- Length (base: meters) ----------------
  static double _lengthToMeters(double v, String unit) {
    switch (unit) {
      case 'millimeter (mm)':
        return v / 1000.0;
      case 'centimeter (cm)':
        return v / 100.0;
      case 'meter (m)':
        return v;
      case 'kilometer (km)':
        return v * 1000.0;
      case 'inch (in)':
        return v * 0.0254;
      case 'foot (ft)':
        return v * 0.3048;
      case 'yard (yd)':
        return v * 0.9144;
      case 'mile (mi)':
        return v * 1609.344;
      default:
        throw ArgumentError('Unsupported length unit: $unit');
    }
  }

  static double _metersToLength(double m, String unit) {
    switch (unit) {
      case 'millimeter (mm)':
        return m * 1000.0;
      case 'centimeter (cm)':
        return m * 100.0;
      case 'meter (m)':
        return m;
      case 'kilometer (km)':
        return m / 1000.0;
      case 'inch (in)':
        return m / 0.0254;
      case 'foot (ft)':
        return m / 0.3048;
      case 'yard (yd)':
        return m / 0.9144;
      case 'mile (mi)':
        return m / 1609.344;
      default:
        throw ArgumentError('Unsupported length unit: $unit');
    }
  }

  // ---------------- Weight (base: grams) ----------------
  static double _weightToGrams(double v, String unit) {
    switch (unit) {
      case 'gram (g)':
        return v;
      case 'kilogram (kg)':
        return v * 1000.0;
      case 'ounce (oz)':
        return v * 28.349523125; // exact per international avoirdupois
      case 'pound (lb)':
        return v * 453.59237;
      default:
        throw ArgumentError('Unsupported weight unit: $unit');
    }
  }

  static double _gramsToWeight(double g, String unit) {
    switch (unit) {
      case 'gram (g)':
        return g;
      case 'kilogram (kg)':
        return g / 1000.0;
      case 'ounce (oz)':
        return g / 28.349523125;
      case 'pound (lb)':
        return g / 453.59237;
      default:
        throw ArgumentError('Unsupported weight unit: $unit');
    }
  }

  // ---------------- Temperature (direct formulas) ----------------
  static double _temperatureConvert(double v, String from, String to) {
    // normalize to Celsius first
    final celsius = switch (from) {
      'Celsius (°C)' => v,
      'Fahrenheit (°F)' => (v - 32.0) * 5.0 / 9.0,
      'Kelvin (K)' => v - 273.15,
      _ => throw ArgumentError('Unsupported temperature unit: $from'),
    };

    // convert Celsius to target
    return switch (to) {
      'Celsius (°C)' => celsius,
      'Fahrenheit (°F)' => (celsius * 9.0 / 5.0) + 32.0,
      'Kelvin (K)' => celsius + 273.15,
      _ => throw ArgumentError('Unsupported temperature unit: $to'),
    };
  }
}
