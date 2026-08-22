import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streak_battle/features/battle/view/widgets/step2_rules_widget.dart';
import 'package:streak_battle/features/battle/view/widgets/step3_invite_widget.dart';
import '../../../../core/constants/app_color_style.dart';
import '../../../../core/helper/code_generator.dart';
import '../../view_model/battle_entity.dart';
import '../../view_model/create_battle_cubit.dart';
import '../../view_model/create_battle_state.dart';
import '../widgets/custom_stepper.dart';
import '../widgets/step1_info_widget.dart';

class CreateBattleScreen extends StatefulWidget {
  const CreateBattleScreen({super.key});
  @override
  State<CreateBattleScreen> createState() => _CreateBattleScreenState();
}

class _CreateBattleScreenState extends State<CreateBattleScreen> {
  final PageController _pageController = PageController();
  int currentStep = 0;

  String battleCode = 'Loading...';
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController customCategoryController = TextEditingController();
  String? selectedCategory;
final _step1Key=GlobalKey<FormState>();
final _step2Key=GlobalKey<FormState>();


  final TextEditingController goalController = TextEditingController();
  DateTime? startDate;
  int? durationDays;
  bool isReminderOn = true;
  TimeOfDay reminderTime = const TimeOfDay(hour: 20, minute: 0);
  bool isInviteOnly = true;



  final List<String> invitedFriends = [];

  void _nextPage() {

    if (currentStep == 0) {
      if (!(_step1Key.currentState?.validate() ?? false)) return;


      if (selectedCategory == null || selectedCategory!.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a battle category')),
        );
        return;
      }
    }


    else if (currentStep == 1) {

      if (!(_step2Key.currentState?.validate() ?? false)) return;


      if (startDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a start date')),
        );
        return;
      }


      if (durationDays == null || durationDays! <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select battle duration')),
        );
        return;
      }
    }


    if (currentStep < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    }
  }


  void _submitBattle(BuildContext blocContext) {

    final finalCategory = selectedCategory == 'Custom'
        ? customCategoryController.text.trim()
        : selectedCategory;


    final formattedReminderTime =
        '${reminderTime.hour.toString().padLeft(2, '0')}:${reminderTime.minute.toString().padLeft(2, '0')}';

    final battle = BattleEntity(
      title: titleController.text.trim(),
      category: finalCategory??'',
      description: descriptionController.text.trim(),
      startDate: startDate ?? DateTime.now(),
      durationDays: durationDays??0,
      dailyGoal: goalController.text.trim(),
      isReminderOn: isReminderOn,
      reminderTime: formattedReminderTime,
      isInviteOnly: isInviteOnly,
      battleCode: battleCode,
      creatorId: '',
      members: invitedFriends,
      createdAt: DateTime.now(),
    );



    blocContext.read<CreateBattleCubit>().createBattle(battle);
  }
  @override
  void initState() {
    super.initState();
    _loadUniqueBattleCode();
  }


  Future<void> _loadUniqueBattleCode() async {
    final code = await BattleCodeHelper.generateUniqueCode();

    if (mounted) {
      setState(() {
        battleCode = code;
      });
    }
  }
  @override
  void dispose() {
    _pageController.dispose();
    titleController.dispose();
    descriptionController.dispose();
    customCategoryController.dispose();
    goalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CreateBattleCubit(),
      child: BlocConsumer<CreateBattleCubit, CreateBattleState>(
        listener: (context, state) {
          if (state is CreateBattleSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Battle Created Successfully!')),
            );
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          } else if (state is CreateBattleError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.message}')),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is CreateBattleLoading;

          return Scaffold(
            backgroundColor: AppColorStyle.backgroundColor,
            appBar: AppBar(
              backgroundColor: AppColorStyle.backgroundColor,
              title: const Text(
                'Create Battle',
                style: TextStyle(color: Colors.white),
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: isLoading ? null : _previousPage,
              ),
            ),
            body: isLoading
                ? const Center(
              child: CircularProgressIndicator(color: Colors.white),
            )
                : Column(
              children: [
                CustomStepperHeader(currentStep: currentStep),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    onPageChanged: (index) {
                      setState(() {
                        currentStep = index;
                      });
                    },
                    children: [
                      Form(
                        key: _step1Key,
                        child: Step1InfoWidget(
                          titleController: titleController,
                          descriptionController: descriptionController,
                          customCategoryController: customCategoryController,
                          selectedCategory: selectedCategory??'',
                          onCategoryChanged: (cat) =>
                              setState(() => selectedCategory = cat),
                          onNext: _nextPage,
                        ),
                      ),
                      Form(
                        key: _step2Key,
                        child: Step2RulesWidget(
                          goalController: goalController,
                          startDate: startDate,
                          durationDays: durationDays??0,
                          isReminderOn: isReminderOn,
                          reminderTime: reminderTime,
                          isInviteOnly: isInviteOnly,
                          onStartDateChanged: (date) =>
                              setState(() => startDate = date),
                          onDurationChanged: (days) =>
                              setState(() => durationDays = days),
                          onReminderStatusChanged: (val) =>
                              setState(() => isReminderOn = val),
                          onReminderTimeChanged: (time) =>
                              setState(() => reminderTime = time),
                          onInviteOnlyChanged: (val) =>
                              setState(() => isInviteOnly = val),
                          onNext: _nextPage,
                        ),
                      ),
                      Step3InviteWidget(
                        battleCode: battleCode,
                        invitedFriends: invitedFriends,
                        onNext: () => _submitBattle(context),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}