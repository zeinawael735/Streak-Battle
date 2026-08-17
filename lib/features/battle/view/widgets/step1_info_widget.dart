import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/constants/app_assets.dart';
import 'custom_button.dart';
import 'custom_text_form_field.dart';


class Step1InfoWidget extends StatefulWidget {
  const Step1InfoWidget({
    super.key,
    required this.onNext,
    required this.titleController,
    required this.descriptionController,
    required this.customCategoryController,
    required this.selectedCategory,
    required this.onCategoryChanged,
  });

  final VoidCallback onNext;
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final TextEditingController customCategoryController;
  final String selectedCategory;
  final ValueChanged<String> onCategoryChanged;

  static const Map<String, IconData> categories = {
    'Fitness': Icons.directions_run,
    'Learning': Icons.menu_book,
    'Wellness': Icons.self_improvement,
    'Nutrition': Icons.apple,
    'Coding': Icons.code,
    'Custom': Icons.edit,
  };

  @override
  State<Step1InfoWidget> createState() => _Step1InfoWidgetState();
}

class _Step1InfoWidgetState extends State<Step1InfoWidget> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 13),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Battle Basics",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "Give your challenge a clear, motivating identity.",
              style: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              "Battle name",
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            CustomTextFormField(
              prefixIcon: Padding(
                padding: const EdgeInsets.all(12.0),
                child: SvgPicture.asset(
                  AppAssets.swordIconSvg,
                  width: 20,
                  height: 20,
                ),
              ),
              borderRadius: BorderRadius.circular(8),
              controller: widget.titleController,
            ),
            const SizedBox(height: 10),
            const Text(
              "Categories",
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 10,
              children: Step1InfoWidget.categories.entries.map((entry) {
                final String title = entry.key;
                final IconData icon = entry.value;
                final bool isSelected = widget.selectedCategory == title;

                return ChoiceChip(
                  showCheckmark: false,
                  avatar: Icon(
                    icon,
                    size: 18,
                    color: isSelected ? Colors.white : Colors.grey.shade400,
                  ),
                  label: Text(
                    title,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey.shade300,
                      fontWeight:
                      isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  selected: isSelected,
                  selectedColor: const Color(0xFF6B11A1),
                  backgroundColor: const Color(0xFF160E21),
                  side: BorderSide(
                    width: 1.5,
                    color: isSelected
                        ? const Color(0xFF6B11A1)
                        : const Color(0xFF2D2338),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  onSelected: (_) => widget.onCategoryChanged(title),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            if (widget.selectedCategory == 'Custom') ...[
              const Text(
                "Specify your category",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              CustomTextFormField(
                controller: widget.customCategoryController,
                hintText: "Enter custom category",
              ),
              const SizedBox(height: 10),
            ],
            const SizedBox(height: 20),
            const Text('Description (optional)',
                style: TextStyle(color: Colors.white, fontSize: 14)),
            const SizedBox(height: 8),
            TextField(
              controller: widget.descriptionController,
              maxLines: 3,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintStyle: TextStyle(color: Colors.grey.shade600),
                filled: true,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    width: 1.0,
                    color: Colors.grey.shade800,
                  ),
                ),
                fillColor: const Color(0xFF160E21),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 30),
            CustomButton(
              text: "Next: battle rules",
              onPressed: widget.onNext,
              padding: const EdgeInsets.symmetric(horizontal: 105, vertical: 16),
            ),
          ],
        ),
      ),
    );
  }
}