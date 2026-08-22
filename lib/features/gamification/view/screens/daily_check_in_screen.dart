import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/utils/app_toast.dart';
import '../../../battle/view/widgets/custom_button.dart';
import '../../view_model/check_in_cubit.dart';
import '../../view_model/check_in_repository.dart';
import '../../view_model/check_in_state.dart';
import '../widgets/goal_card.dart';

class DailyCheckInScreen extends StatelessWidget {
  const DailyCheckInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String battleId =
        (ModalRoute.of(context)?.settings.arguments as String?) ?? '';

    return BlocProvider(
      // التعديل هنا: بنحمل الداتا أول ما نفتح الشاشة
      create: (context) => CheckInCubit(CheckInRepository())..loadBattleData(battleId),
      child: DailyCheckInContent(battleId: battleId),
    );
  }
}

class DailyCheckInContent extends StatefulWidget {
  final String battleId;

  const DailyCheckInContent({super.key, required this.battleId});

  @override
  State<DailyCheckInContent> createState() => _DailyCheckInContentState();
}

class _DailyCheckInContentState extends State<DailyCheckInContent> {
  bool? isCompleted;
  final TextEditingController _noteController = TextEditingController();
  int _noteLength = 0;

  @override
  void initState() {
    super.initState();
    _noteController.addListener(() {
      setState(() {
        _noteLength = _noteController.text.length;
      });
    });
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocConsumer<CheckInCubit, CheckInState>(
      listener: (context, state) {
        if (state is CheckInError) {
          AppToast.showToast(
            context: context,
            title: 'Check-in Failed',
            description: state.message,
            type: ToastificationType.error,
          );
        }

        if (state is CheckInSuccess) {
          AppToast.showToast(
            context: context,
            title: 'Check-in Successful!',
            description: '+${state.earnedPoints} Points | Level ${state.level} 🚀',
            type: ToastificationType.success,
          );

          Future.delayed(const Duration(seconds: 1), () {
            if (mounted) Navigator.pop(context);
          });
        }
      },
      builder: (context, state) {
        final isLoading = state is CheckInLoading;
        final cubit = context.read<CheckInCubit>(); // بنجيب الكوبيت عشان نقرأ منه الداتا

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: isDark ? Colors.white : Colors.black, size: 18),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text('Daily check-in', style: Theme.of(context).textTheme.headlineMedium),
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 16),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1C2A22) : Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  children: [
                    Text('🔥', style: TextStyle(fontSize: 13)),
                    SizedBox(width: 4),
                    Text(
                      'Daily Streak',
                      style: TextStyle(color: AppColors.success, fontWeight: FontWeight.w600, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // التعديل هنا: بنعرض الداتا الحقيقية لو حملت، ولو لسه بنعرض Lodaing
                          cubit.battleTitle.isEmpty
                              ? const Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Center(child: CircularProgressIndicator(color: AppColors.purple)),
                          )
                              : GoalCard(
                            title: cubit.battleTitle,
                            goal: cubit.battleGoal,
                          ),

                          const SizedBox(height: 24),
                          Text("Did you complete today's goal?", style: Theme.of(context).textTheme.labelLarge),
                          const SizedBox(height: 12),
                          GestureDetector(
                            onTap: () => setState(() => isCompleted = (isCompleted == true) ? null : true),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: isDark ? AppColors.indigo : Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: (isCompleted == true) ? AppColors.success : Colors.grey.withOpacity(0.3),
                                  width: 2,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: (isCompleted == true) ? AppColors.success : Colors.transparent,
                                      border: Border.all(
                                        color: (isCompleted == true) ? AppColors.success : (isDark ? Colors.white : Colors.black54),
                                        width: 2,
                                      ),
                                    ),
                                    child: (isCompleted == true) ? const Icon(Icons.check, size: 16, color: Colors.white) : null,
                                  ),
                                  const SizedBox(width: 16),
                                  Text('Yes, completed', style: Theme.of(context).textTheme.bodyLarge),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Add a note (optional)', style: Theme.of(context).textTheme.labelLarge),
                              Text('$_noteLength/120', style: Theme.of(context).textTheme.labelLarge),
                            ],
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _noteController,
                            maxLength: 120,
                            maxLines: 2,
                            style: TextStyle(color: isDark ? Colors.white : Colors.black, fontSize: 14),
                            decoration: InputDecoration(
                              counterText: '',
                              filled: true,
                              fillColor: isDark ? AppColors.indigo : Colors.grey.shade100,
                              hintText: 'Felt strong - 18:42 pace.',
                              hintStyle: const TextStyle(color: Colors.grey),
                              contentPadding: const EdgeInsets.all(16),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(color: Colors.grey.withOpacity(0.2), width: 1),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(color: AppColors.purple, width: 1.5),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                      text: isLoading ? 'Checking in...' : 'Confirm check-in',
                      onPressed: (isCompleted == true && !isLoading && widget.battleId.isNotEmpty)
                          ? () {
                        context.read<CheckInCubit>().confirmCheckIn(
                          battleId: widget.battleId,
                          note: _noteController.text,
                        );
                      }
                          : null,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}