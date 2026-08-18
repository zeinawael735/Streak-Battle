import 'package:flutter/material.dart';

import 'custom_button.dart';

class Step2RulesWidget extends StatefulWidget {
  final VoidCallback onNext;
  final TextEditingController goalController;
  final DateTime? startDate;
  final int durationDays;
  final bool isReminderOn;
  final TimeOfDay reminderTime;
  final bool isInviteOnly;

  final ValueChanged<DateTime?> onStartDateChanged;
  final ValueChanged<int> onDurationChanged;
  final ValueChanged<bool> onReminderStatusChanged;
  final ValueChanged<TimeOfDay> onReminderTimeChanged;
  final ValueChanged<bool> onInviteOnlyChanged;

  const Step2RulesWidget({
    super.key,
    required this.onNext,
    required this.goalController,
    required this.startDate,
    required this.durationDays,
    required this.isReminderOn,
    required this.reminderTime,
    required this.isInviteOnly,
    required this.onStartDateChanged,
    required this.onDurationChanged,
    required this.onReminderStatusChanged,
    required this.onReminderTimeChanged,
    required this.onInviteOnlyChanged,
  });

  static const List<int> durations = [7, 14, 21, 30];

  @override
  State<Step2RulesWidget> createState() => _Step2RulesWidgetState();
}

class _Step2RulesWidgetState extends State<Step2RulesWidget> {
  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF6B11A1),
              onPrimary: Colors.white,
              surface: Color(0xFF160E21),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      widget.onStartDateChanged(picked);
    }
  }

  Future<void> _selectReminderTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: widget.reminderTime,
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF6B11A1),
              surface: Color(0xFF160E21),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      widget.onReminderTimeChanged(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Set the rules',
            style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            'Fair, simple rules keep everyone focused.',
            style: TextStyle(color: Colors.grey.shade400, fontSize: 13),
          ),
          const SizedBox(height: 24),
          const Text('START DATE', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          InkWell(
            onTap: () => _selectStartDate(context),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF160E21),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade800),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_month, color: Color(0xFF6B11A1)),
                  const SizedBox(width: 12),
                  Text(
                    widget.startDate == null
                        ? 'Select start date'
                        : '${widget.startDate!.day}/${widget.startDate!.month}/${widget.startDate!.year}',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                  const Spacer(),
                  const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 14),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text('DURATION (DAYS)', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: Step2RulesWidget.durations.map((days) {
              final isSelected = widget.durationDays == days;
              return ChoiceChip(
                showCheckmark: false,
                label: Text('$days days'),
                selected: isSelected,
                selectedColor: const Color(0xFF6B11A1),
                backgroundColor: const Color(0xFF160E21),
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey.shade400,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                side: BorderSide(
                  color: isSelected ? const Color(0xFF6B11A1) : Colors.grey.shade800,
                ),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                onSelected: (_) => widget.onDurationChanged(days),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          const Text('DAILY GOAL', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextFormField(
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter a daily goal';
              }
              return null;
            },
            controller: widget.goalController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'e.g. Run 3 km / Read 10 pages',
              hintStyle: TextStyle(color: Colors.grey.shade600),
              prefixIcon: const Icon(Icons.ads_click, color: Color(0xFF6B11A1)),
              filled: true,
              fillColor: const Color(0xFF160E21),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade800),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF6B11A1)),
              ),


            ),
          ),
          const SizedBox(height: 20),
          SwitchListTile(
            tileColor: const Color(0xFF160E21),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey.shade800),
            ),
            secondary: const Icon(Icons.notifications_active_outlined, color: Color(0xFF6B11A1)),
            title: const Text('Daily reminder', style: TextStyle(color: Colors.white, fontSize: 14)),
            subtitle: GestureDetector(
              onTap: () {
                if (widget.isReminderOn) {
                  _selectReminderTime(context);
                }
              },
              child: Text(
                widget.reminderTime.format(context),
                style: const TextStyle(
                  color: Color(0xFF6B11A1),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            value: widget.isReminderOn,
            activeColor: const Color(0xFF6B11A1),
            onChanged: (val) {
              widget.onReminderStatusChanged(val);
              if (val) _selectReminderTime(context);
            },
          ),
          const SizedBox(height: 30),

          CustomButton(
            text: "Next: battle summary",
            onPressed: widget.onNext,
            padding: const EdgeInsets.symmetric(horizontal: 77, vertical: 16),
          ),
        ],
      ),
    );
  }
}