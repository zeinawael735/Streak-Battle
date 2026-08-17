//old
/*import 'package:flutter/material.dart';
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
}*/
// new without connections

/*import 'package:flutter/material.dart';

class JoinBattleScreen extends StatefulWidget {
  const JoinBattleScreen({super.key});

  @override
  State<JoinBattleScreen> createState() => _JoinBattleScreenState();
}


class _JoinBattleScreenState extends State<JoinBattleScreen> {
  final List<TextEditingController> _codeControllers =
  List.generate(7, (_) => TextEditingController());

  final List<FocusNode> _focusNodes =
  List.generate(7, (_) => FocusNode());

  @override
  void dispose() {
    for (final controller in _codeControllers) {
      controller.dispose();
    }

    for (final node in _focusNodes) {
      node.dispose();
    }

    super.dispose();
  }

  void _onCodeChanged(String value, int index) {
    if (value.length == 1 && index < 6) {
      _focusNodes[index + 1].requestFocus();
    }

    if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF131313),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            // ==================================================
            // STATUS BAR
            // ==================================================

            SizedBox(
              height: MediaQuery.of(context).padding.top,
              child: const Row(
                children: [
                  SizedBox(width: 39),

                  Text(
                    '9:41',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 7,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  Spacer(),

                  Icon(
                    Icons.signal_cellular_alt,
                    color: Colors.white,
                    size: 9,
                  ),

                  SizedBox(width: 4),

                  Icon(
                    Icons.wifi,
                    color: Colors.white,
                    size: 9,
                  ),

                  SizedBox(width: 4),

                  Icon(
                    Icons.battery_full,
                    color: Colors.white,
                    size: 10,
                  ),

                  SizedBox(width: 14),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      // ==================================================
                      // HEADER
                      // ==================================================

                      SizedBox(
                        height: 56,
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: const SizedBox(
                                width: 31,
                                height: 40,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Icon(
                                    Icons.chevron_left,
                                    color: Color(0xFFE6D8F7),
                                    size: 26,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(width: 15),

                            const Text(
                              'Join Battle',
                              style: TextStyle(
                                color: Color(0xFFE8DDF0),
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // ==================================================
                      // TICKET ICON SECTION
                      // ==================================================

                      Container(
                        height: 78,
                        width: double.infinity,
                        color: const Color(0xFF111015),
                        child: Center(
                          child: Container(
                            width: 58,
                            height: 50,
                            decoration: BoxDecoration(
                              color: const Color(0xFF26006E),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF7200FF)
                                      .withOpacity(0.22),
                                  blurRadius: 14,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.confirmation_num_outlined,
                                color: Color(0xFFD69AFF),
                                size: 30,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 18),

                      // ==================================================
                      // ENTER BATTLE CODE
                      // ==================================================

                      const Text(
                        'Enter battle code',
                        style: TextStyle(
                          color: Color(0xFFE5E1E5),
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      const SizedBox(height: 13),

                      // ==================================================
                      // CODE BOXES
                      // ==================================================

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          7,
                              (index) {
                            return Padding(
                              padding: EdgeInsets.only(
                                right: index == 6 ? 0 : 5,
                              ),
                              child: _buildCodeBox(index),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 20),

                      // ==================================================
                      // FIND BATTLE BUTTON
                      // ==================================================

                      SizedBox(
                        width: double.infinity,
                        height: 29,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF7911FF),
                            foregroundColor: Colors.white,
                            elevation: 7,
                            shadowColor:
                            const Color(0xFF7911FF).withOpacity(0.4),
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(17),
                            ),
                          ),
                          child: const Text(
                            'Find Battle',
                            style: TextStyle(
                              fontSize: 8,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),

                      // ==================================================
                      // BATTLE CARD
                      // ==================================================

                      _buildBattleCard(),

                      const SizedBox(height: 20),
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

  // ==============================================================
  // CODE BOX
  // ==============================================================

  Widget _buildCodeBox(int index) {
    return Container(
      width: 23,
      height: 30,
      decoration: BoxDecoration(
        color: const Color(0xFF17131C),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: const Color(0xFF7931C9),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7B19FF).withOpacity(0.16),
            blurRadius: 7,
          ),
        ],
      ),
      child: TextField(
        controller: _codeControllers[index],
        focusNode: _focusNodes[index],
        maxLength: 1,
        textAlign: TextAlign.center,
        textCapitalization: TextCapitalization.characters,
        keyboardType: TextInputType.text,
        cursorColor: const Color(0xFFA864FF),
        onChanged: (value) {
          _onCodeChanged(value, index);
        },
        style: const TextStyle(
          color: Color(0xFFD4A5FF),
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
        decoration: const InputDecoration(
          counterText: '',
          border: InputBorder.none,
          contentPadding: EdgeInsets.only(
            bottom: 1,
          ),
        ),
      ),
    );
  }

  // ==============================================================
  // BATTLE CARD
  // ==============================================================

  Widget _buildBattleCard() {
    return Container(
      width: double.infinity,
      height: 201,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1C),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: const Color(0xFF414141),
          width: 1,
        ),
      ),
      child: Stack(
        children: [
          // ============================================================
          // DECORATIVE CIRCLES
          // ============================================================

          Positioned(
            right: -34,
            top: -25,
            child: Container(
              width: 84,
              height: 84,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF343434),
                  width: 1,
                ),
              ),
            ),
          ),

          Positioned(
            right: -20,
            top: -11,
            child: Container(
              width: 57,
              height: 57,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF343434),
                  width: 1,
                ),
              ),
            ),
          ),

          // ============================================================
          // CONTENT
          // ============================================================

          Padding(
            padding: const EdgeInsets.fromLTRB(
              13,
              12,
              13,
              13,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // -----------------------------
                // BATTLE FOUND
                // -----------------------------

                Row(
                  children: [
                    Container(
                      width: 5,
                      height: 5,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFFD900),
                        shape: BoxShape.circle,
                      ),
                    ),

                    const SizedBox(width: 4),

                    const Text(
                      'BATTLE FOUND',
                      style: TextStyle(
                        color: Color(0xFFFFD900),
                        fontSize: 7,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 9),

                // -----------------------------
                // BATTLE NAME
                // -----------------------------

                const Text(
                  'Morning Run\nClub',
                  style: TextStyle(
                    color: Color(0xFFE6E2E5),
                    fontSize: 15,
                    height: 1.08,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 5),

                // -----------------------------
                // HOST
                // -----------------------------

                const Text(
                  'Hosted by Maya • 12\nplayers',
                  style: TextStyle(
                    color: Color(0xFFB5B0B5),
                    fontSize: 8,
                    height: 1.45,
                    fontWeight: FontWeight.w400,
                  ),
                ),

                const SizedBox(height: 11),

                // -----------------------------
                // BATTLE DETAILS
                // -----------------------------

                Container(
                  width: double.infinity,
                  height: 33,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF202020),
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: const Color(0xFF292929),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.directions_run_rounded,
                        color: Color(0xFFCDB5FF),
                        size: 14,
                      ),

                      const SizedBox(width: 8),

                      const Text(
                        '21 days • Run 3 km daily',
                        style: TextStyle(
                          color: Color(0xFFD0CBD0),
                          fontSize: 8,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 17),

                // -----------------------------
                // JOIN BUTTON
                // -----------------------------

                SizedBox(
                  width: double.infinity,
                  height: 29,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7911FF),
                      foregroundColor: Colors.white,
                      elevation: 6,
                      shadowColor:
                      const Color(0xFF7911FF).withOpacity(0.35),
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'JOIN',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}*/
//claude not working
/*import 'package:flutter/material.dart';
import 'package:streak_battle/core/common/common.dart';
import 'package:streak_battle/features/battle/view_model/join_battle_cubit.dart';
import 'package:streak_battle/features/battle/view_model/join_battle_state.dart';

class JoinBattleScreen extends StatefulWidget {
  const JoinBattleScreen({super.key});

  @override
  State<JoinBattleScreen> createState() => _JoinBattleScreenState();
}

class _JoinBattleScreenState extends State<JoinBattleScreen> {
  final List<TextEditingController> _codeControllers =
  List.generate(7, (_) => TextEditingController());

  final List<FocusNode> _focusNodes =
  List.generate(7, (_) => FocusNode());

  // ================= Firebase wiring additions =================
  final JoinBattleCubit _cubit = JoinBattleCubit();

  @override
  void initState() {
    super.initState();
    _cubit.stream.listen((_) {
      if (mounted) setState(() {});
    });
  }
  // ================================================================

  @override
  void dispose() {
    for (final controller in _codeControllers) {
      controller.dispose();
    }

    for (final node in _focusNodes) {
      node.dispose();
    }

    _cubit.close(); // Firebase wiring addition
    super.dispose();
  }

  String get _currentCode => // Firebase wiring addition
  _codeControllers.map((c) => c.text).join();

  void _onCodeChanged(String value, int index) {
    if (value.length == 1 && index < 6) {
      _focusNodes[index + 1].requestFocus();
    }

    if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }

    _cubit.onCodeChanged(_currentCode); // Firebase wiring addition
  }

  @override
  Widget build(BuildContext context) {
    final state = _cubit.state; // Firebase wiring addition

    return Scaffold(
      backgroundColor: const Color(0xFF131313),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            // ==================================================
            // STATUS BAR
            // ==================================================

            SizedBox(
              height: MediaQuery.of(context).padding.top,
              child: const Row(
                children: [
                  SizedBox(width: 39),

                  Text(
                    '9:41',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 7,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  Spacer(),

                  Icon(
                    Icons.signal_cellular_alt,
                    color: Colors.white,
                    size: 9,
                  ),

                  SizedBox(width: 4),

                  Icon(
                    Icons.wifi,
                    color: Colors.white,
                    size: 9,
                  ),

                  SizedBox(width: 4),

                  Icon(
                    Icons.battery_full,
                    color: Colors.white,
                    size: 10,
                  ),

                  SizedBox(width: 14),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      // ==================================================
                      // HEADER
                      // ==================================================

                      SizedBox(
                        height: 56,
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: const SizedBox(
                                width: 31,
                                height: 40,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Icon(
                                    Icons.chevron_left,
                                    color: Color(0xFFE6D8F7),
                                    size: 26,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(width: 15),

                            const Text(
                              'Join Battle',
                              style: TextStyle(
                                color: Color(0xFFE8DDF0),
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // ==================================================
                      // TICKET ICON SECTION
                      // ==================================================

                      Container(
                        height: 78,
                        width: double.infinity,
                        color: const Color(0xFF111015),
                        child: Center(
                          child: Container(
                            width: 58,
                            height: 50,
                            decoration: BoxDecoration(
                              color: const Color(0xFF26006E),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF7200FF)
                                      .withOpacity(0.22),
                                  blurRadius: 14,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.confirmation_num_outlined,
                                color: Color(0xFFD69AFF),
                                size: 30,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 18),

                      // ==================================================
                      // ENTER BATTLE CODE
                      // ==================================================

                      const Text(
                        'Enter battle code',
                        style: TextStyle(
                          color: Color(0xFFE5E1E5),
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      const SizedBox(height: 13),

                      // ==================================================
                      // CODE BOXES
                      // ==================================================

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          7,
                              (index) {
                            return Padding(
                              padding: EdgeInsets.only(
                                right: index == 6 ? 0 : 5,
                              ),
                              child: _buildCodeBox(index),
                            );
                          },
                        ),
                      ),

                      // Firebase wiring addition: error message
                      if (_errorMessage(state) != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          _errorMessage(state)!,
                          style: const TextStyle(
                            color: Colors.redAccent,
                            fontSize: 10,
                          ),
                        ),
                      ],

                      const SizedBox(height: 20),

                      // ==================================================
                      // FIND BATTLE BUTTON
                      // ==================================================

                      SizedBox(
                        width: double.infinity,
                        height: 29,
                        child: ElevatedButton(
                          onPressed: state is JoinBattleLoading
                              ? null
                              : () => _cubit.findBattle(_currentCode), // Firebase wiring
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF7911FF),
                            foregroundColor: Colors.white,
                            elevation: 7,
                            shadowColor:
                            const Color(0xFF7911FF).withOpacity(0.4),
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(17),
                            ),
                          ),
                          child: state is JoinBattleLoading
                              ? const SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                              : const Text(
                            'Find Battle',
                            style: TextStyle(
                              fontSize: 8,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),

                      // ==================================================
                      // BATTLE CARD (Firebase wiring: shown only when found)
                      // ==================================================

                      if (state is JoinBattlePreview) ...[
                        _buildBattleCard(state.battle),
                        const SizedBox(height: 20),
                      ],
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

  // Firebase wiring addition
  String? _errorMessage(JoinBattleState state) {
    if (state is JoinBattleInvalid) return 'Invalid battle code. Please check and try again.';
    if (state is JoinBattleExpired) return 'This battle has already ended.';
    if (state is JoinBattleAlreadyJoined) return 'You already joined this battle.';
    return null;
  }

  // ==============================================================
  // CODE BOX
  // ==============================================================

  Widget _buildCodeBox(int index) {
    return Container(
      width: 23,
      height: 30,
      decoration: BoxDecoration(
        color: const Color(0xFF17131C),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: const Color(0xFF7931C9),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7B19FF).withOpacity(0.16),
            blurRadius: 7,
          ),
        ],
      ),
      child: TextField(
        controller: _codeControllers[index],
        focusNode: _focusNodes[index],
        maxLength: 1,
        textAlign: TextAlign.center,
        textCapitalization: TextCapitalization.characters,
        keyboardType: TextInputType.text,
        cursorColor: const Color(0xFFA864FF),
        onChanged: (value) {
          _onCodeChanged(value, index);
        },
        style: const TextStyle(
          color: Color(0xFFD4A5FF),
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
        decoration: const InputDecoration(
          counterText: '',
          border: InputBorder.none,
          contentPadding: EdgeInsets.only(
            bottom: 1,
          ),
        ),
      ),
    );
  }

  // ==============================================================
  // BATTLE CARD (Firebase wiring: now takes real battle data)
  // ==============================================================

  Widget _buildBattleCard(BattleEntity battle) {
    return Container(
      width: double.infinity,
      height: 201,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1C),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: const Color(0xFF414141),
          width: 1,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -34,
            top: -25,
            child: Container(
              width: 84,
              height: 84,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF343434),
                  width: 1,
                ),
              ),
            ),
          ),

          Positioned(
            right: -20,
            top: -11,
            child: Container(
              width: 57,
              height: 57,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF343434),
                  width: 1,
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(13, 12, 13, 13),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 5,
                      height: 5,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFFD900),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      'BATTLE FOUND',
                      style: TextStyle(
                        color: Color(0xFFFFD900),
                        fontSize: 7,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 9),

                Text(
                  battle.title, // Firebase wiring: was hardcoded 'Morning Run\nClub'
                  style: const TextStyle(
                    color: Color(0xFFE6E2E5),
                    fontSize: 15,
                    height: 1.08,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  '${battle.members.length} players joined', // Firebase wiring: was hardcoded 'Hosted by Maya...'
                  style: const TextStyle(
                    color: Color(0xFFB5B0B5),
                    fontSize: 8,
                    height: 1.45,
                    fontWeight: FontWeight.w400,
                  ),
                ),

                const SizedBox(height: 11),

                Container(
                  width: double.infinity,
                  height: 33,
                  padding: const EdgeInsets.symmetric(horizontal: 9),
                  decoration: BoxDecoration(
                    color: const Color(0xFF202020),
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: const Color(0xFF292929),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.directions_run_rounded,
                        color: Color(0xFFCDB5FF),
                        size: 14,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${battle.durationDays} days • ${battle.dailyGoal}', // Firebase wiring
                        style: const TextStyle(
                          color: Color(0xFFD0CBD0),
                          fontSize: 8,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 17),

                SizedBox(
                  width: double.infinity,
                  height: 29,
                  child: ElevatedButton(
                    onPressed: () => _cubit.joinBattle(), // Firebase wiring: was empty () {}
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7911FF),
                      foregroundColor: Colors.white,
                      elevation: 6,
                      shadowColor:
                      const Color(0xFF7911FF).withOpacity(0.35),
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'JOIN',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}*/
import 'package:flutter/material.dart';
import 'package:streak_battle/core/common/common.dart';
import 'package:streak_battle/features/battle/view_model/join_battle_cubit.dart';
import 'package:streak_battle/features/battle/view_model/join_battle_state.dart';

class JoinBattleScreen extends StatefulWidget {
  const JoinBattleScreen({super.key});

  @override
  State<JoinBattleScreen> createState() => _JoinBattleScreenState();
}

class _JoinBattleScreenState extends State<JoinBattleScreen> {
  final List<TextEditingController> _codeControllers =
  List.generate(7, (_) => TextEditingController());

  final List<FocusNode> _focusNodes =
  List.generate(7, (_) => FocusNode());

  final JoinBattleCubit _cubit = JoinBattleCubit();

  @override
  void initState() {
    super.initState();
    _cubit.stream.listen((_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    for (final controller in _codeControllers) {
      controller.dispose();
    }
    for (final node in _focusNodes) {
      node.dispose();
    }
    _cubit.close();
    super.dispose();
  }

  String get _currentCode => _codeControllers.map((c) => c.text).join();

  void _onCodeChanged(String value, int index) {
    if (value.length == 1 && index < 6) {
      _focusNodes[index + 1].requestFocus();
    }

    if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }

    _cubit.onCodeChanged(_currentCode);
  }

  @override
  Widget build(BuildContext context) {
    final state = _cubit.state;

    return Scaffold(
      backgroundColor: const Color(0xFF131313),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            // ==================================================
            // STATUS BAR
            // ==================================================

            SizedBox(
              height: MediaQuery.of(context).padding.top,
              child: const Row(
                children: [
                  SizedBox(width: 39),
                  Text(
                    '9:41',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 7,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Spacer(),
                  Icon(Icons.signal_cellular_alt, color: Colors.white, size: 9),
                  SizedBox(width: 4),
                  Icon(Icons.wifi, color: Colors.white, size: 9),
                  SizedBox(width: 4),
                  Icon(Icons.battery_full, color: Colors.white, size: 10),
                  SizedBox(width: 14),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      // ==================================================
                      // HEADER
                      // ==================================================

                      SizedBox(
                        height: 56,
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: const SizedBox(
                                width: 31,
                                height: 40,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Icon(
                                    Icons.chevron_left,
                                    color: Color(0xFFE6D8F7),
                                    size: 26,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 15),
                            const Text(
                              'Join Battle',
                              style: TextStyle(
                                color: Color(0xFFE8DDF0),
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // ==================================================
                      // TICKET ICON SECTION
                      // ==================================================

                      Container(
                        height: 78,
                        width: double.infinity,
                        color: const Color(0xFF111015),
                        child: Center(
                          child: Container(
                            width: 58,
                            height: 50,
                            decoration: BoxDecoration(
                              color: const Color(0xFF26006E),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF7200FF).withOpacity(0.22),
                                  blurRadius: 14,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.confirmation_num_outlined,
                                color: Color(0xFFD69AFF),
                                size: 30,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 18),

                      // ==================================================
                      // ENTER BATTLE CODE
                      // ==================================================

                      const Text(
                        'Enter battle code',
                        style: TextStyle(
                          color: Color(0xFFE5E1E5),
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      const SizedBox(height: 13),

                      // ==================================================
                      // CODE BOXES
                      // ==================================================

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          7,
                              (index) {
                            return Padding(
                              padding: EdgeInsets.only(
                                right: index == 6 ? 0 : 5,
                              ),
                              child: _buildCodeBox(index),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 20),

                      // ==================================================
                      // FIND BATTLE BUTTON
                      // ==================================================

                      SizedBox(
                        width: double.infinity,
                        height: 29,
                        child: ElevatedButton(
                          onPressed: state is JoinBattleLoading
                              ? null
                              : () => _cubit.findBattle(_currentCode),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF7911FF),
                            foregroundColor: Colors.white,
                            elevation: 7,
                            shadowColor: const Color(0xFF7911FF).withOpacity(0.4),
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(17),
                            ),
                          ),
                          child: const Text(
                            'Find Battle',
                            style: TextStyle(
                              fontSize: 8,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),

                      // ==================================================
                      // BATTLE CARD
                      // (UI unchanged — only the surrounding `if` is new)
                      // ==================================================

                      if (state is JoinBattlePreview)
                        _buildBattleCard(state.battle),

                      const SizedBox(height: 20),
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

  // ==============================================================
  // CODE BOX
  // ==============================================================

  Widget _buildCodeBox(int index) {
    return Container(
      width: 23,
      height: 30,
      decoration: BoxDecoration(
        color: const Color(0xFF17131C),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: const Color(0xFF7931C9),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7B19FF).withOpacity(0.16),
            blurRadius: 7,
          ),
        ],
      ),
      child: TextField(
        controller: _codeControllers[index],
        focusNode: _focusNodes[index],
        maxLength: 1,
        textAlign: TextAlign.center,
        textCapitalization: TextCapitalization.characters,
        keyboardType: TextInputType.text,
        cursorColor: const Color(0xFFA864FF),
        onChanged: (value) {
          _onCodeChanged(value, index);
        },
        style: const TextStyle(
          color: Color(0xFFD4A5FF),
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
        decoration: const InputDecoration(
          counterText: '',
          border: InputBorder.none,
          contentPadding: EdgeInsets.only(
            bottom: 1,
          ),
        ),
      ),
    );
  }

  // ==============================================================
  // BATTLE CARD
  // (same exact visual widget — content now comes from `battle`)
  // ==============================================================

  Widget _buildBattleCard(BattleEntity battle) {
    return Container(
      width: double.infinity,
      height: 201,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1C),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: const Color(0xFF414141),
          width: 1,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -34,
            top: -25,
            child: Container(
              width: 84,
              height: 84,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF343434),
                  width: 1,
                ),
              ),
            ),
          ),
          Positioned(
            right: -20,
            top: -11,
            child: Container(
              width: 57,
              height: 57,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF343434),
                  width: 1,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(13, 12, 13, 13),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 5,
                      height: 5,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFFD900),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      'BATTLE FOUND',
                      style: TextStyle(
                        color: Color(0xFFFFD900),
                        fontSize: 7,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 9),
                Text(
                  battle.title,
                  style: const TextStyle(
                    color: Color(0xFFE6E2E5),
                    fontSize: 15,
                    height: 1.08,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '${battle.members.length} players joined',
                  style: const TextStyle(
                    color: Color(0xFFB5B0B5),
                    fontSize: 8,
                    height: 1.45,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 11),
                Container(
                  width: double.infinity,
                  height: 33,
                  padding: const EdgeInsets.symmetric(horizontal: 9),
                  decoration: BoxDecoration(
                    color: const Color(0xFF202020),
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: const Color(0xFF292929),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.directions_run_rounded,
                        color: Color(0xFFCDB5FF),
                        size: 14,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${battle.durationDays} days • ${battle.dailyGoal}',
                        style: const TextStyle(
                          color: Color(0xFFD0CBD0),
                          fontSize: 8,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 17),
                SizedBox(
                  width: double.infinity,
                  height: 29,
                  child: ElevatedButton(
                    onPressed: () => _cubit.joinBattle(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7911FF),
                      foregroundColor: Colors.white,
                      elevation: 6,
                      shadowColor: const Color(0xFF7911FF).withOpacity(0.35),
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'JOIN',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}