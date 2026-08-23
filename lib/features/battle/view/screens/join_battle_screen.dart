import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';
import '../../../../../core/utils/app_toast.dart';
import 'package:streak_battle/core/routes/app_routes.dart';
import 'package:streak_battle/features/battle/view_model/join_battle_cubit.dart';
import 'package:streak_battle/features/battle/view_model/join_battle_state.dart';


import '../../../../core/theme/theme.dart';
import '../widgets/battle_code_input.dart';
import '../widgets/battle_preview_card.dart';

class JoinBattleScreen extends StatefulWidget {
  const JoinBattleScreen({super.key});

  @override
  State<JoinBattleScreen> createState() => _JoinBattleScreenState();
}

class _JoinBattleScreenState extends State<JoinBattleScreen> {
  final JoinBattleCubit _cubit = JoinBattleCubit();
  String _currentCode = '';

  @override
  void initState() {
    super.initState();
    _cubit.stream.listen((state) {
      if (!mounted) return;
      setState(() {});

      if (state is JoinBattleInvalid) {
        AppToast.showToast(
          context: context,
          title: 'Error',
          description: 'Battle not found',
          type: ToastificationType.error,
        );
      }

      if (state is JoinBattleAlreadyJoined) {
        AppToast.showToast(
          context: context,
          title: 'Already a Member',
          description: 'You are already participating in this battle!',
          type: ToastificationType.info,
        );
      }

      if (state is JoinBattleJoined) {
        AppToast.showToast(
          context: context,
          title: 'Success',
          description: 'You joined the battle successfully!',
          type: ToastificationType.success,
        );

        Future.delayed(const Duration(milliseconds: 900), () {
          if (!mounted) return;
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.appSection,
                (route) => false,
          );
        });
      }
    });
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = _cubit.state;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      // HEADER
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(
                              Icons.arrow_back_ios_new_rounded,
                              size: 22,
                            ),
                            padding: EdgeInsets.only(right: 25),
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                'Join Battle',
                                style: Theme.of(context).textTheme.headlineLarge
                              ),
                            ),
                          ),
                          const SizedBox(width: 30),
                        ],
                      ),
                      const SizedBox(height: 32),

                      // TICKET ICON SECTION
                      Container(
                        height: 120,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.onTertiaryContainer,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: const Color(0xFF26006E),
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF7200FF).withOpacity(0.3),
                                  blurRadius: 20,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.confirmation_num_outlined,
                                color: Color(0xFFD69AFF),
                                size: 40,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      const Text(
                        'Enter battle code',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 24),

                      BattleCodeInput(
                        onChanged: (value) {
                          _currentCode = value;
                          _cubit.onCodeChanged(value);
                        },
                        onCompleted: (value) {
                          _cubit.findBattle(value);
                        },
                      ),
                      const SizedBox(height: 32),

                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed:
                          state is JoinBattleLoading ||
                              _currentCode.length < 8
                              ? null
                              : () => _cubit.findBattle(_currentCode),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF7911FF),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(26),
                            ),
                          ),
                          child: const Text(
                            'Find Battle',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // BATTLE CARD
                      if (state is JoinBattlePreview)
                        BattlePreviewCard(
                          battle: state.battle,
                          onJoinPressed: () => _cubit.joinBattle(),
                        ),

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}