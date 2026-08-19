import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:streak_battle/core/theme/theme.dart';

class BattleCodeInput extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onCompleted;

  const BattleCodeInput({
    super.key,
    required this.onChanged,
    required this.onCompleted,
  });

  @override
  State<BattleCodeInput> createState() => _BattleCodeInputState();
}

class _BattleCodeInputState extends State<BattleCodeInput> {
  final int length = 6;
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(length, (_) => TextEditingController());
    _focusNodes = List.generate(length, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _emitCurrentValue() {
    final value = _controllers.map((c) => c.text).join();
    widget.onChanged(value);
    if (value.length == length) {
      widget.onCompleted(value);
    }
  }

  void _handleChange(int index, String value) {
    if (value.length > 1) {
      final pasted = value.toUpperCase().replaceAll(RegExp(r'[^A-Z0-9]'), '');
      for (int i = 0; i < length; i++) {
        _controllers[i].text = i < pasted.length ? pasted[i] : '';
      }
      final nextEmpty = pasted.length < length ? pasted.length : length - 1;
      FocusScope.of(context).requestFocus(_focusNodes[nextEmpty]);
      _emitCurrentValue();
      return;
    }

    if (value.isNotEmpty && index < length - 1) {
      FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
    } else if (value.isEmpty && index > 0) {
      FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
    }
    _emitCurrentValue();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(length, (index) {
        return SizedBox(
          width: 44,
          height: 52,
          child: TextField(
            controller: _controllers[index],
            focusNode: _focusNodes[index],
            textAlign: TextAlign.center,
            maxLength: length,
            keyboardType: TextInputType.text,
            textCapitalization: TextCapitalization.characters,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
            ],
            style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold),
            decoration: InputDecoration(
              counterText: '',
              filled: true,
              fillColor: AppColors.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.primary),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.primary),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.primary, width: 2),
              ),
            ),
            onChanged: (value) => _handleChange(index, value),
          ),
        );
      }),
    );
  }
}