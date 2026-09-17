import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'SimpleCalc',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(useMaterial3: true),
    home: const CalculatorPage(),
  );
}

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String _display = '0';
  String _expression = '';
  double? _storedValue;
  String? _operator;
  bool _startNewNumber = true;
  bool _hasError = false;

  String _format(double value) {
    if (!value.isFinite) return 'Error';
    if (value == 0) return '0';
    String result = value.toString();
    if (result.endsWith('.0')) result = result.substring(0, result.length - 2);
    if (result.length > 13) result = value.toStringAsPrecision(10);
    if (result.contains('.') && !result.contains('e')) {
      result = result
          .replaceFirst(RegExp(r'0+$'), '')
          .replaceFirst(RegExp(r'\.$'), '');
    }
    return result;
  }

  double? _calculate(double left, double right, String operation) {
    switch (operation) {
      case '+':
        return left + right;
      case '−':
        return left - right;
      case '×':
        return left * right;
      case '÷':
        return right == 0 ? null : left / right;
    }
    return null;
  }

  void _press(String key) {
    setState(() {
      if (key == 'AC') {
        _display = '0';
        _expression = '';
        _storedValue = null;
        _operator = null;
        _startNewNumber = true;
        _hasError = false;
        return;
      }
      if (_hasError) return;

      if (RegExp(r'^[0-9]$').hasMatch(key)) {
        if (_startNewNumber) {
          _display = key;
          _startNewNumber = false;
        } else if (_display.replaceAll(RegExp(r'[^0-9]'), '').length < 12) {
          _display = _display == '0' ? key : '$_display$key';
        }
        return;
      }
      if (key == '.') {
        if (_startNewNumber) {
          _display = '0.';
          _startNewNumber = false;
        } else if (!_display.contains('.')) {
          _display += '.';
        }
        return;
      }
      if (key == '⌫') {
        if (_startNewNumber) return;
        _display =
            _display.length <= 1 ||
                (_display.length == 2 && _display.startsWith('-'))
            ? '0'
            : _display.substring(0, _display.length - 1);
        return;
      }
      if (key == '±') {
        if (_display != '0') {
          _display = _display.startsWith('-')
              ? _display.substring(1)
              : '-$_display';
        }
        return;
      }
      if (key == '%') {
        _display = _format((double.tryParse(_display) ?? 0) / 100);
        return;
      }

      final current = double.tryParse(_display) ?? 0;
      if (key == '=') {
        if (_operator == null || _storedValue == null) return;
        final result = _calculate(_storedValue!, current, _operator!);
        _expression = '${_format(_storedValue!)} $_operator $_display =';
        _display = result == null ? 'Error' : _format(result);
        _hasError = result == null || _display == 'Error';
        _storedValue = null;
        _operator = null;
        _startNewNumber = true;
        return;
      }

      if (_operator != null && !_startNewNumber && _storedValue != null) {
        final result = _calculate(_storedValue!, current, _operator!);
        if (result == null) {
          _display = 'Error';
          _expression = '';
          _hasError = true;
          return;
        }
        _display = _format(result);
      }
      _storedValue = double.tryParse(_display) ?? 0;
      _operator = key;
      _expression = '${_format(_storedValue!)} $key';
      _startNewNumber = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    const background = Color(0xFF10141D);
    const panel = Color(0xFF191F2B);
    const number = Color(0xFF252D3B);
    const utility = Color(0xFF384353);
    const accent = Color(0xFF68E0BF);
    final rows = [
      ['AC', '±', '%', '÷'],
      ['7', '8', '9', '×'],
      ['4', '5', '6', '−'],
      ['1', '2', '3', '+'],
      ['⌫', '0', '.', '='],
    ];

    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Row(
                      children: [
                        Container(
                          width: 9,
                          height: 9,
                          decoration: const BoxDecoration(
                            color: accent,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'SIMPLECALC',
                          style: TextStyle(
                            color: Color(0xFFA9B5C7),
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 2.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 28,
                    ),
                    decoration: BoxDecoration(
                      color: panel,
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          _expression.isEmpty ? ' ' : _expression,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color(0xFF8390A3),
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 14),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerRight,
                          child: Text(
                            _display,
                            key: const Key('display'),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 68,
                              fontWeight: FontWeight.w500,
                              letterSpacing: -2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  for (final row in rows) ...[
                    Expanded(
                      child: Row(
                        children: [
                          for (final key in row) ...[
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(5),
                                child: Material(
                                  color: key == '='
                                      ? accent
                                      : ['÷', '×', '−', '+'].contains(key)
                                      ? const Color(0xFF244E4B)
                                      : ['AC', '±', '%', '⌫'].contains(key)
                                      ? utility
                                      : number,
                                  borderRadius: BorderRadius.circular(22),
                                  child: InkWell(
                                    key: Key('button_$key'),
                                    borderRadius: BorderRadius.circular(22),
                                    onTap: () => _press(key),
                                    child: Center(
                                      child: Text(
                                        key,
                                        style: TextStyle(
                                          color: key == '='
                                              ? background
                                              : [
                                                  '÷',
                                                  '×',
                                                  '−',
                                                  '+',
                                                ].contains(key)
                                              ? accent
                                              : Colors.white,
                                          fontSize: key == 'AC' ? 23 : 28,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
