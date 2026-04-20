/// GitSwipe — Swipe Feed Screen (The Hero)
///
/// Tinder-style swipeable repo discovery cards with glassmorphism,
/// haptic feedback, staggered entrance animations, and tonal layering.
library;

import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import '../models/repository.dart';
import '../widgets/shared_widgets.dart';

class SwipeFeedScreen extends StatefulWidget {
  const SwipeFeedScreen({super.key, required this.onRepoTap});

  final void Function(Repository repo) onRepoTap;

  @override
  State<SwipeFeedScreen> createState() => _SwipeFeedScreenState();
}

class _SwipeFeedScreenState extends State<SwipeFeedScreen>
    with TickerProviderStateMixin {
  late List<Repository> _repos;
  int _currentIndex = 0;

  // Swipe state
  double _dragX = 0;
  double _dragY = 0;
  bool _isDragging = false;

  late AnimationController _entranceController;

  @override
  void initState() {
    super.initState();
    _repos = List.from(mockRepositories);
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();
  }

  @override
  void dispose() {
    _entranceController.dispose();
    super.dispose();
  }

  void _onSwipeComplete(bool isSave) {
    HapticFeedback.mediumImpact();
    setState(() {
      _currentIndex++;
      _dragX = 0;
      _dragY = 0;
      if (_currentIndex >= _repos.length) {
        _currentIndex = 0; // loop for demo
      }
    });
    _entranceController.reset();
    _entranceController.forward();
  }

  String _formatNumber(int n) {
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}k';
    return n.toString();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // ── Ambient background gradient ──
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0, -0.4),
                  radius: 1.8,
                  colors: [
                    AppColors.primaryContainer.withValues(alpha: 0.06),
                    AppColors.background,
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // ── Top Bar ──
                _buildTopBar()
                    .animate()
                    .fadeIn(duration: 500.ms),
                const SizedBox(height: 8),

                // ── Card Stack ──
                Expanded(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Background cards (stack effect)
                      if (_currentIndex + 2 < _repos.length)
                        _buildStackCard(_repos[_currentIndex + 2], 2),
                      if (_currentIndex + 1 < _repos.length)
                        _buildStackCard(_repos[_currentIndex + 1], 1),

                      // Active card (draggable)
                      if (_currentIndex < _repos.length)
                        GestureDetector(
                          onPanStart: (_) {
                            setState(() => _isDragging = true);
                          },
                          onPanUpdate: (details) {
                            setState(() {
                              _dragX += details.delta.dx;
                              _dragY += details.delta.dy;
                            });
                          },
                          onPanEnd: (details) {
                            setState(() => _isDragging = false);
                            if (_dragX.abs() > screenWidth * 0.3) {
                              _onSwipeComplete(_dragX > 0);
                            } else {
                              setState(() {
                                _dragX = 0;
                                _dragY = 0;
                              });
                            }
                          },
                          onTap: () =>
                              widget.onRepoTap(_repos[_currentIndex]),
                          child: AnimatedContainer(
                            duration: _isDragging
                                ? Duration.zero
                                : const Duration(milliseconds: 300),
                            curve: AppAnimation.defaultCurve,
                            transform: Matrix4.identity()
                              ..translate(_dragX, _dragY * 0.4)
                              ..rotateZ(_dragX * 0.0008),
                            child: _buildRepoCard(_repos[_currentIndex]),
                          ),
                        ),

                      // ── Swipe indicators ──
                      if (_dragX.abs() > 40)
                        Positioned(
                          top: 40,
                          left: _dragX > 0 ? null : 30,
                          right: _dragX > 0 ? null : null,
                          child: _dragX > 0
                              ? Positioned(
                                  right: 30,
                                  child: _buildSwipeIndicator(
                                    'SAVE',
                                    AppColors.secondary,
                                    Icons.check_rounded,
                                  ),
                                )
                              : _buildSwipeIndicator(
                                  'SKIP',
                                  AppColors.error,
                                  Icons.close_rounded,
                                ),
                        ),
                    ],
                  ),
                ),

                // ── Action Buttons ──
                _buildActionButtons(),
                const SizedBox(height: 16),

                // ── Status indicator ──
                _buildStatusBar()
                    .animate()
                    .fadeIn(delay: 400.ms, duration: 500.ms),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.primaryContainer],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(
              child: Icon(Icons.swipe_rounded, color: Colors.white, size: 20),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'GitSwipe',
            style: AppTypography.titleMedium(context).copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.onSurface,
            ),
          ),
          const Spacer(),
          // User avatar placeholder
          GlassContainer(
            borderRadius: 100,
            padding: const EdgeInsets.all(2),
            opacity: 0.4,
            blurSigma: 10,
            child: const CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.surfaceContainerHigh,
              child: Icon(Icons.person_rounded, size: 18, color: AppColors.onSurfaceVariant),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStackCard(Repository repo, int depth) {
    final scale = 1.0 - (depth * 0.04);
    final yOffset = depth * 12.0;
    return Transform.translate(
      offset: Offset(0, yOffset),
      child: Transform.scale(
        scale: scale,
        child: Opacity(
          opacity: 1.0 - (depth * 0.25),
          child: _buildRepoCard(repo, isBackground: true),
        ),
      ),
    );
  }

  Widget _buildRepoCard(Repository repo, {bool isBackground = false}) {
    return Container(
      width: MediaQuery.of(context).size.width - 40,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: isBackground ? 10 : 20,
            sigmaY: isBackground ? 10 : 20,
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerHigh.withValues(alpha: 0.85),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.06),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryContainer.withValues(alpha: 0.05),
                  blurRadius: 40,
                  offset: const Offset(0, 20),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Owner / org
                Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceBright,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          repo.owner[0].toUpperCase(),
                          style: AppTypography.labelLarge(context).copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      '${repo.owner} /',
                      style: AppTypography.labelMedium(context).copyWith(
                        color: AppColors.outline,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Repo name (hero)
                Text(
                  repo.name,
                  style: AppTypography.headlineLarge(context).copyWith(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),

                // Description
                Text(
                  repo.cardSummary ?? repo.description,
                  style: AppTypography.bodyMedium(context),
                  maxLines: 4,
                  overflow: TextOverflow.fade,
                ),
                const SizedBox(height: 20),

                // Language chip + stats row
                Row(
                  children: [
                    LanguageChip(
                      language: repo.language,
                      color: repo.languageColor,
                    ),
                    const Spacer(),
                    StatBadge(
                      icon: Icons.star_rounded,
                      value: _formatNumber(repo.stars),
                      color: const Color(0xFFffd54f),
                    ),
                    const SizedBox(width: 16),
                    StatBadge(
                      icon: Icons.call_split_rounded,
                      value: _formatNumber(repo.forks),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Topics
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: repo.topics
                      .take(4)
                      .map((t) => TopicChip(label: t))
                      .toList(),
                ),

                const SizedBox(height: 20),

                // Velocity indicator
                if (repo.starVelocity != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.secondaryContainer.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.trending_up_rounded,
                          size: 16,
                          color: AppColors.secondary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${repo.starVelocity!.toStringAsFixed(1)} stars/day',
                          style: AppTypography.labelMedium(context).copyWith(
                            color: AppColors.secondary,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    )
        .animate(controller: _entranceController)
        .slideY(begin: 0.15, end: 0, duration: 600.ms, curve: Curves.easeOutCubic)
        .fadeIn(duration: 500.ms);
  }

  Widget _buildSwipeIndicator(String label, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.5), width: 2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Text(
            label,
            style: AppTypography.labelLarge(context).copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Skip
          GlassActionButton(
            icon: Icons.close_rounded,
            color: AppColors.error,
            onTap: () => _onSwipeComplete(false),
          ),
          // Explore (deep dive)
          GlassActionButton(
            icon: Icons.auto_awesome_rounded,
            color: AppColors.primary,
            size: 72,
            iconSize: 32,
            onTap: () {
              if (_currentIndex < _repos.length) {
                widget.onRepoTap(_repos[_currentIndex]);
              }
            },
          ),
          // Save
          GlassActionButton(
            icon: Icons.check_rounded,
            color: AppColors.secondary,
            onTap: () => _onSwipeComplete(true),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(delay: 300.ms, duration: 500.ms)
        .slideY(begin: 0.3, end: 0, duration: 500.ms);
  }

  Widget _buildStatusBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: AppColors.secondary,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.secondary.withValues(alpha: 0.4),
                  blurRadius: 8,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'Matching Now',
            style: AppTypography.labelMedium(context).copyWith(
              color: AppColors.secondary,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            '·  Swipe right to save • Swipe left to skip',
            style: AppTypography.labelSmall(context),
          ),
        ],
      ),
    );
  }
}
