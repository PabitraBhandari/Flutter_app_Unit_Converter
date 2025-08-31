import 'package:flutter/material.dart';
import 'conversions.dart';

/// Visual layer only: crisp UI + minimal state. Conversion math lives in
/// [ConverterService]. This separation follows best practices and makes the
/// logic easy to test in isolation.
class UnitConverterGUI extends StatefulWidget {
  const UnitConverterGUI({super.key});

  @override
  State<UnitConverterGUI> createState() => _UnitConverterGUIState();
}

class _UnitConverterGUIState extends State<UnitConverterGUI> {
  // ---- GUI State (no conversion logic) ----
  final List<String> categories = const ['Temperature', 'Length', 'Weight'];
  String category = 'Temperature';

  final Map<String, List<String>> units = const {
    'Temperature': ['Celsius (°C)', 'Fahrenheit (°F)', 'Kelvin (K)'],
    'Length': [
      'millimeter (mm)',
      'centimeter (cm)',
      'meter (m)',
      'kilometer (km)',
      'inch (in)',
      'foot (ft)',
      'yard (yd)',
      'mile (mi)',
    ],
    'Weight': ['gram (g)', 'kilogram (kg)', 'ounce (oz)', 'pound (lb)'],
  };

  // Keep a persistent controller; avoid recreating it during build.
  late final TextEditingController _inputCtl = TextEditingController(text: '1');

  String fromUnit = 'Celsius (°C)';
  String toUnit = 'Fahrenheit (°F)';

  double? _result; // latest numerical result (null when input invalid/empty)

  @override
  void initState() {
    super.initState();
    _resetUnitsFor(category);
    // Compute initial result for default 1 °C → °F.
    _recompute();
  }

  @override
  void dispose() {
    _inputCtl.dispose();
    super.dispose();
  }

  void _resetUnitsFor(String cat) {
    final list = units[cat]!;
    setState(() {
      fromUnit = list.first;
      toUnit = list.length > 1 ? list[1] : list.first;
      _result = null; // clear until recomputed
    });
  }

  void _swapUnits() {
    setState(() {
      final tmp = fromUnit;
      fromUnit = toUnit;
      toUnit = tmp;
    });
    _recompute();
  }

  void _recompute() {
    final raw = _inputCtl.text.trim();
    if (raw.isEmpty) {
      setState(() => _result = null);
      return;
    }
    final value = double.tryParse(raw);
    if (value == null) {
      // Inform user; keep previous value out of the way.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid number.')),
      );
      setState(() => _result = null);
      return;
    }

    try {
      final out = ConverterService.convert(
        category: category,
        fromUnit: fromUnit,
        toUnit: toUnit,
        value: value,
      );
      setState(() => _result = out);
    } on ArgumentError catch (e) {
      // Shouldn’t happen with the provided lists; surface just in case.
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message ?? e.toString())));
      setState(() => _result = null);
    }
  }

  String _formatResult() {
    if (_result == null) return '';
    // Show up to 8 significant digits, trim trailing zeros.
    final str = _result!.toStringAsPrecision(8);
    return str.replaceFirst(RegExp(r'\.?0+$'), '');
  }

  @override
  Widget build(BuildContext context) {
    final unitList = units[category]!;

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Unit Converter',
          key: ValueKey('app-title'),
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _Labeled(
                  label: 'Category',
                  child: _DropdownBox(
                    value: category,
                    items: categories,
                    onChanged: (v) {
                      setState(() {
                        category = v!;
                        _resetUnitsFor(category);
                      });
                    },
                  ),
                ),
                const SizedBox(height: 18),
                _Labeled(
                  label: 'Value',
                  child: _FieldContainer(
                    child: TextField(
                      controller: _inputCtl,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter value',
                        hintStyle: TextStyle(color: Colors.white54),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                      ),
                      onChanged: (_) => _recompute(),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: _Labeled(
                        label: 'From',
                        child: _DropdownBox(
                          value: fromUnit,
                          items: unitList,
                          onChanged: (v) {
                            setState(() => fromUnit = v!);
                            _recompute();
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    _SwapButton(onTap: _swapUnits),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _Labeled(
                        label: 'To',
                        child: _DropdownBox(
                          value: toUnit,
                          items: unitList,
                          onChanged: (v) {
                            setState(() => toUnit = v!);
                            _recompute();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (_result != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 24),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFF334155),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 22,
                        horizontal: 18,
                      ),
                      child: Text(
                        _formatResult(),
                        style: const TextStyle(
                          color: Colors.cyanAccent,
                          fontWeight: FontWeight.w700,
                          fontSize: 28,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ----- Reusable UI pieces (no logic) -----
class _Labeled extends StatelessWidget {
  const _Labeled({required this.label, required this.child});
  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 5),
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
        child,
      ],
    );
  }
}

class _FieldContainer extends StatelessWidget {
  const _FieldContainer({required this.child, this.borderColor});
  final Widget child;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0x33212B3B),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor ?? const Color(0x1AFFFFFF)),
      ),
      child: child,
    );
  }
}

class _DropdownBox extends StatelessWidget {
  const _DropdownBox({
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return _FieldContainer(
      borderColor: const Color(0x1AFFFFFF),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: value,
            dropdownColor: const Color(0xFF0F172A),
            borderRadius: BorderRadius.circular(12),
            iconEnabledColor: Colors.white70,
            style: const TextStyle(color: Colors.white, fontSize: 14),
            items: items
                .map(
                  (e) => DropdownMenuItem<String>(
                    value: e,
                    child: Text(e, overflow: TextOverflow.ellipsis),
                  ),
                )
                .toList(),
            onChanged: onChanged,
            isExpanded: true,
          ),
        ),
      ),
    );
  }
}

class _SwapButton extends StatelessWidget {
  const _SwapButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    const cyan = Color(0xFF22D3EE);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 48,
        decoration: BoxDecoration(
          color: cyan.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: cyan.withValues(alpha: 0.45)),
        ),
        alignment: Alignment.center,
        child: const Text(
          '⇄',
          style: TextStyle(
            color: cyan,
            fontWeight: FontWeight.w700,
            fontSize: 20,
            height: 1,
          ),
        ),
      ),
    );
  }
}
