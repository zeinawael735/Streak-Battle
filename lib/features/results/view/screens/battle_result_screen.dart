import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streak_battle/core/utils/responsive_helper.dart';
import '../../view_model/battle_result_cubit.dart';
import '../../view_model/battle_result_state.dart';

class BattleResultScreen extends StatelessWidget {
  const BattleResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BattleResultCubit(),
      child: const _BattleResultView(),
    );
  }
}

class _BattleResultView extends StatefulWidget {
  const _BattleResultView();

  @override
  State<_BattleResultView> createState() => _BattleResultViewState();
}

class _BattleResultViewState extends State<_BattleResultView>
    with TickerProviderStateMixin {
  late final AnimationController _scaleController;
  late final AnimationController _fadeController;
  late final Animation<double> _circleScale;
  late final Animation<double> _crownOffset;
  late final Animation<double> _contentFade;

  bool _hasPlayedOnce = false;

  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _circleScale = CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    );

    _crownOffset = Tween<double>(begin: -40, end: 0).animate(
      CurvedAnimation(
        parent: _scaleController,
        curve: const Interval(0.3, 1.0, curve: Curves.bounceOut),
      ),
    );

    _contentFade = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );
  }

  void _playCelebrationOnce() {
    if (_hasPlayedOnce) return;
    _hasPlayedOnce = true;
    _scaleController.forward();
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) _fadeController.forward();
    });
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = theme.colorScheme.onSurface;
    final secondaryTextColor = textColor.withOpacity(0.55);
    final cardColor = isDark ? const Color(0xFF1C1C1C) : const Color(0xFFF5F5F5);
    final progressBg = isDark ? Colors.black : Colors.grey.shade300;
    final r = ResponsiveHelper(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: BlocBuilder<BattleResultCubit, BattleResultState>(
          builder: (context, state) {
            if (state is BattleResultCalculating) {
              return Center(
                child: CircularProgressIndicator(color: theme.colorScheme.secondary),
              );
            }

            if (state is BattleResultError) {
              return Center(
                child: Text(state.message, style: TextStyle(color: textColor)),
              );
            }

            final result = state as BattleResultLoaded;

            // Trigger the celebration animation once data is ready.
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _playCelebrationOnce();
            });

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: r.w(20)),
              child: Column(
                children: [
                  SizedBox(height: r.h(24)),

                  // ================= HEADER =================
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.auto_awesome,
                          color: theme.colorScheme.secondary, size: r.w(14)),
                      SizedBox(width: r.w(8)),
                      Text(
                        'BATTLE COMPLETE',
                        style: TextStyle(
                          color: theme.colorScheme.secondary,
                          fontSize: r.sp(12),
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                      SizedBox(width: r.w(8)),
                      Icon(Icons.auto_awesome,
                          color: theme.colorScheme.secondary, size: r.w(14)),
                    ],
                  ),

                  SizedBox(height: r.h(28)),

                  // ================= WINNER CIRCLE (ANIMATED) =================
                  AnimatedBuilder(
                    animation: _scaleController,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _circleScale.value,
                        child: child,
                      );
                    },
                    child: Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: r.w(120),
                          height: r.w(120),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: cardColor,
                            boxShadow: [
                              BoxShadow(
                                color: theme.colorScheme.secondary.withOpacity(0.35),
                                blurRadius: r.w(30),
                                spreadRadius: r.w(4),
                              ),
                            ],
                          ),
                        ),
                        AnimatedBuilder(
                          animation: _crownOffset,
                          builder: (context, child) {
                            return Positioned(
                              top: r.h(-22) + _crownOffset.value,
                              child: child!,
                            );
                          },
                          child: Icon(Icons.emoji_events,
                              color: theme.colorScheme.tertiary, size: r.w(34)),
                        ),
                        Positioned(
                          bottom: r.h(-6),
                          right: r.w(30),
                          child: Container(
                            width: r.w(26),
                            height: r.w(26),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.tertiary,
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: theme.scaffoldBackgroundColor, width: 2),
                            ),
                            child: Center(
                              child: Text('1',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: r.sp(13))),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: r.h(18)),

                  // ================= FADE-IN CONTENT =================
                  FadeTransition(
                    opacity: _contentFade,
                    child: Column(
                      children: [
                        Text(
                          '${result.winnerName} wins!',
                          style: TextStyle(
                            color: textColor,
                            fontSize: r.sp(22),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: r.h(6)),
                        Text(
                          result.battleTitle,
                          style: TextStyle(color: secondaryTextColor, fontSize: r.sp(13)),
                        ),
                        SizedBox(height: r.h(24)),

                        // ================= YOUR RESULT CARD =================
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(r.w(16)),
                          decoration: BoxDecoration(
                            color: cardColor,
                            borderRadius: BorderRadius.circular(r.w(16)),
                            border: Border.all(
                                color: theme.colorScheme.tertiary.withOpacity(0.4)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.bar_chart,
                                      color: theme.colorScheme.tertiary, size: r.w(14)),
                                  SizedBox(width: r.w(6)),
                                  Text(
                                    'YOUR RESULT',
                                    style: TextStyle(
                                      color: theme.colorScheme.tertiary,
                                      fontSize: r.sp(11),
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.6,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: r.h(10)),
                              Text(
                                result.userRankLabel,
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: r.sp(20),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: r.h(4)),
                              Text(
                                '${result.points} points',
                                style: TextStyle(
                                  color: theme.colorScheme.secondary,
                                  fontSize: r.sp(14),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: r.h(14)),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(r.w(10)),
                                child: LinearProgressIndicator(
                                  value: result.completionPercent,
                                  minHeight: r.h(8),
                                  backgroundColor: progressBg,
                                  valueColor: AlwaysStoppedAnimation(
                                      theme.colorScheme.tertiary),
                                ),
                              ),
                              SizedBox(height: r.h(8)),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${(result.completionPercent * 100).round()}% completion',
                                    style: TextStyle(
                                        color: theme.colorScheme.tertiary,
                                        fontSize: r.sp(12)),
                                  ),
                                  Row(
                                    children: [
                                      Icon(Icons.check_circle_outline,
                                          color: secondaryTextColor, size: r.w(13)),
                                      SizedBox(width: r.w(4)),
                                      Text(
                                        '${result.checkIns} check-ins',
                                        style: TextStyle(
                                            color: secondaryTextColor, fontSize: r.sp(12)),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: r.h(16)),

                        // ================= STATS CARDS =================
                        Row(
                          children: [
                            Expanded(
                              child: _statCard(
                                icon: Icons.local_fire_department,
                                iconColor: theme.colorScheme.error,
                                value: '${result.bestStreak} days',
                                label: 'Best streak',
                                textColor: textColor,
                                secondaryTextColor: secondaryTextColor,
                                cardColor: cardColor,
                                r: r,
                              ),
                            ),
                            SizedBox(width: r.w(12)),
                            Expanded(
                              child: _statCard(
                                icon: Icons.directions_run,
                                iconColor: theme.colorScheme.secondary,
                                value: '${result.totalDistanceKm} km',
                                label: 'Total distance',
                                textColor: textColor,
                                secondaryTextColor: secondaryTextColor,
                                cardColor: cardColor,
                                r: r,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: r.h(24)),

                        // ================= SHARE BUTTON =================
                        SizedBox(
                          width: double.infinity,
                          height: r.h(50),
                          child: ElevatedButton.icon(
                            onPressed: () {
                              // TODO: implement Share Results
                            },
                            icon: Icon(Icons.ios_share, size: r.w(18)),
                            label: Text('Share result', style: TextStyle(fontSize: r.sp(14))),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.colorScheme.primary,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(r.w(26)),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: r.h(14)),

                        TextButton(
                          onPressed: () {
                            Navigator.popUntil(context, (route) => route.isFirst);
                          },
                          child: Text(
                            'Back to home',
                            style: TextStyle(color: secondaryTextColor, fontSize: r.sp(13)),
                          ),
                        ),

                        SizedBox(height: r.h(20)),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _statCard({
    required IconData icon,
    required Color iconColor,
    required String value,
    required String label,
    required Color textColor,
    required Color secondaryTextColor,
    required Color cardColor,
    required ResponsiveHelper r,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: r.h(16), horizontal: r.w(12)),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(r.w(14)),
        border: Border.all(color: textColor.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: r.w(18)),
          SizedBox(height: r.h(8)),
          Text(value,
              style: TextStyle(
                  color: textColor, fontSize: r.sp(15), fontWeight: FontWeight.bold)),
          SizedBox(height: r.h(2)),
          Text(label, style: TextStyle(color: secondaryTextColor, fontSize: r.sp(11))),
        ],
      ),
    );
  }
}