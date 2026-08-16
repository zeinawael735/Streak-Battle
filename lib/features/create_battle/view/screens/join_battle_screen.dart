import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streak_battle/core/theme/theme.dart';
import 'package:streak_battle/core/common/common.dart';
import '../../view_model/join_battle_cubit.dart';
import '../../view_model/join_battle_state.dart';
import '../widgets/battle_code_input.dart';
import '../widgets/battle_preview_card.dart';

class JoinBattleScreen extends StatelessWidget {
  const JoinBattleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => JoinBattleCubit(),
      child: const _JoinBattleView(),
    );
  }
}

class _JoinBattleView extends StatefulWidget {
  const _JoinBattleView();

  @override
  State<_JoinBattleView> createState() => _JoinBattleViewState();
}

class _JoinBattleViewState extends State<_JoinBattleView> {
  String _currentCode = '';

  String? _errorMessage(JoinBattleState state) {
    if (state is JoinBattleInvalid) return 'Invalid battle code. Please check and try again.';
    if (state is JoinBattleExpired) return 'This battle has already ended.';
    if (state is JoinBattleAlreadyJoined) return 'You already joined this battle.';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: const BackButton(color: AppColors.textPrimary),
        title: const Text('Join Battle', style: TextStyle(color: AppColors.textPrimary)),
      ),
      body: BlocConsumer<JoinBattleCubit, JoinBattleState>(
        listener: (context, state) {
          if (state is JoinBattleJoined) {
            Navigator.pop(context, state.battleId);
          }
        },
        builder: (context, state) {
          final isLoading = state is JoinBattleLoading;
          final error = _errorMessage(state);

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Center(
                  child: Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(Icons.confirmation_number_outlined,
                        color: Colors.white, size: 40),
                  ),
                ),
                const SizedBox(height: 24),
                const Text('Enter battle code',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                BattleCodeInput(
                  onChanged: (code) {
                    _currentCode = code;
                    context.read<JoinBattleCubit>().onCodeChanged(code);
                  },
                  onCompleted: (code) {
                    _currentCode = code;
                  },
                ),
                if (error != null) ...[
                  const SizedBox(height: 10),
                  Text(error, style: const TextStyle(color: AppColors.error, fontSize: 13)),
                ],
                const SizedBox(height: 20),
                CustomButton(
                  label: 'Find Battle',
                  isLoading: isLoading,
                  onPressed: _currentCode.length == 6
                      ? () => context.read<JoinBattleCubit>().findBattle(_currentCode)
                      : null,
                ),
                if (state is JoinBattlePreview) ...[
                  const SizedBox(height: 20),
                  BattlePreviewCard(battle: state.battle),
                  const SizedBox(height: 16),
                  CustomButton(
                    label: 'JOIN',
                    isLoading: false,
                    onPressed: () => context.read<JoinBattleCubit>().joinBattle(),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}