import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  final int length = 8;
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(length, (_) => TextEditingController());
    _focusNodes = List.generate(length, (_) => FocusNode());

    for (int i = 0; i < length; i++) {
      _focusNodes[i].addListener(() {
        if (_focusNodes[i].hasFocus) {
          _controllers[i].selection = TextSelection(
            baseOffset: 0,
            extentOffset: _controllers[i].text.length,
          );
        }
      });
    }
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
      final pasted = value.toUpperCase().replaceAll(RegExp(r'[^A-Z0-9\-]'), '');
      for (int i = 0; i < length; i++) {
        _controllers[i].text = i < pasted.length ? pasted[i] : '';
      }
      final nextEmpty = pasted.length < length ? pasted.length : length - 1;
      FocusScope.of(context).requestFocus(_focusNodes[nextEmpty]);
      _emitCurrentValue();
      return;
    }

    if (value.isEmpty) {
      _controllers[index].text = '';
      if (index > 0) {
        FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
      }
      _emitCurrentValue();
      return;
    }

    if (value.isNotEmpty) {

      final newChar = value.characters.last.toUpperCase();
      _controllers[index].value = TextEditingValue(
        text: newChar,
        selection: TextSelection.collapsed(offset: 1),
      );

      if (index < length - 1) {
        FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
      }
      _emitCurrentValue();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(length, (index) {
        return Container(
          width: 38,
          height: 52,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onTertiary,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: const Color(0xFF532389),
              width: 1.5,
            ),
          ),
          child: RawKeyboardListener(
            focusNode: FocusNode(),
            onKey: (event) {
              if (event is RawKeyDownEvent &&
                  event.logicalKey == LogicalKeyboardKey.backspace) {
                if (_controllers[index].text.isEmpty && index > 0) {
                  _controllers[index - 1].clear();
                  FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
                  _emitCurrentValue();
                }
              }
            },
            child: TextField(
              controller: _controllers[index],
              focusNode: _focusNodes[index],
              textAlign: TextAlign.center,
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.characters,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\-]')),
              ],
              style: Theme.of(context).textTheme.headlineMedium,
              decoration: const InputDecoration(
                counterText: '',
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              onChanged: (value) => _handleChange(index, value),
            ),
          ),
        );
      }),
    );
  }
}