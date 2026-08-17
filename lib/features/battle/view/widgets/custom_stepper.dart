import 'package:flutter/material.dart';

class CustomStepperHeader extends StatelessWidget {
  final int currentStep;

  const CustomStepperHeader({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,

    children: [
        _buildStepCircle(
          stepNumber: 1,
          label: 'Info',
          isActive: currentStep >= 0,
        ),

        _buildLine(isActive: currentStep >= 1),

        _buildStepCircle(
          stepNumber: 2,
          label: 'Rules',
          isActive: currentStep >= 1,
        ),

        _buildLine(isActive: currentStep >= 2),

        _buildStepCircle(
          stepNumber: 3,
          label: 'Invite',
          isActive: currentStep >= 2,
        ),
      ],
    );
  }

  Widget _buildStepCircle({
    required int stepNumber,
    required String label,
    required bool isActive,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,

            color: isActive ? const Color(0xFF6B11A1) : const Color(0xFF1C1326),
            border: Border.all(
              color: isActive
                  ? const Color(0xFF6B11A1)
                  : const Color(0xFF2D2338),
            ),
          ),
          child: Center(
            child: Text(
              '$stepNumber',
              style: TextStyle(
                color: isActive ? Colors.white : Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.grey,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildLine({required bool isActive}) {
    return Container(
      width: 60,
      height: 2,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      color: isActive ? const Color(0xFF6B11A1) : const Color(0xFF2D2338),
    );
  }
}
