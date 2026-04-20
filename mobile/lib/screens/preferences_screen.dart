/// GitSwipe — Preferences Screen
///
/// User preference configuration with glassmorphic sections,
/// language chips, domain focus toggles, and session override controls.



import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import '../widgets/shared_widgets.dart';

class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({super.key});

  @override
  State<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  // Language selections
  final Map<String, bool> _languages = {
    'TypeScript': true,
    'Rust': true,
    'Python': true,
    'Go': false,
    'Swift': false,
    'Kotlin': false,
    'C++': false,
    'Zig': false,
  };

  // Domain focus
  final Map<String, bool> _domains = {
    'Backend & CLI': true,
    'AI & ML': true,
    'Frontend': false,
    'DevOps': false,
    'Systems': false,
    'Mobile': false,
  };

  // Avoid list items
  final List<String> _avoidList = ['tutorial-repos', 'awesome-lists', 'forks'];

  // Goal mode
  String _goalMode = 'Both';

  // Session override
  bool _sessionOverride = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Preferences',
                      style: AppTypography.headlineLarge(context),
                    )
                        .animate()
                        .fadeIn(duration: 500.ms)
                        .slideX(begin: -0.1, end: 0, duration: 500.ms),
                    const SizedBox(height: 8),
                    Text(
                      'Fine-tune your discovery engine. These settings directly influence the repositories curated for your feed.',
                      style: AppTypography.bodyMedium(context),
                    )
                        .animate()
                        .fadeIn(delay: 200.ms, duration: 500.ms),
                  ],
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Core Languages ──
                  _buildSectionWrapper(
                    'Core Languages',
                    'SELECT YOUR PREFERRED LANGUAGES',
                    delay: 300,
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 10,
                      children: _languages.entries.map((entry) {
                        return PressableScale(
                          onTap: () {
                            HapticFeedback.selectionClick();
                            setState(() {
                              _languages[entry.key] = !entry.value;
                            });
                          },
                          child: TopicChip(
                            label: entry.key,
                            isSelected: entry.value,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 28),

                  // ── Domain Focus ──
                  _buildSectionWrapper(
                    'Domain Focus',
                    'AREAS OF INTEREST',
                    delay: 400,
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 10,
                      children: _domains.entries.map((entry) {
                        return PressableScale(
                          onTap: () {
                            HapticFeedback.selectionClick();
                            setState(() {
                              _domains[entry.key] = !entry.value;
                            });
                          },
                          child: _buildDomainChip(entry.key, entry.value),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 28),

                  // ── Avoid Lists ──
                  _buildSectionWrapper(
                    'Avoid Lists',
                    'FILTERED FROM YOUR FEED',
                    delay: 500,
                    child: Column(
                      children: _avoidList.map((item) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: GhostBorderCard(
                            borderRadius: 12,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 12,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.block_rounded,
                                  size: 16,
                                  color: AppColors.error.withValues(alpha: 0.6),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  item,
                                  style: AppTypography.labelLarge(context).copyWith(
                                    color: AppColors.onSurfaceVariant,
                                  ),
                                ),
                                const Spacer(),
                                PressableScale(
                                  onTap: () {
                                    HapticFeedback.lightImpact();
                                    setState(() => _avoidList.remove(item));
                                  },
                                  child: Icon(
                                    Icons.close_rounded,
                                    size: 16,
                                    color: AppColors.outline,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 28),

                  // ── Current Goal ──
                  _buildSectionWrapper(
                    'Current Goal',
                    null,
                    delay: 600,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildGoalOption(
                          'Discover',
                          'Focus on high-quality, trending repositories',
                          Icons.explore_rounded,
                        ),
                        const SizedBox(height: 8),
                        _buildGoalOption(
                          'Contribute',
                          'Prioritize repos with "help wanted" tags',
                          Icons.handshake_rounded,
                        ),
                        const SizedBox(height: 8),
                        _buildGoalOption(
                          'Both',
                          'Balance discovery with contribution opportunities',
                          Icons.balance_rounded,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '"Both" mode balances high-quality stars with "help wanted" tags.',
                          style: AppTypography.bodySmall(context).copyWith(
                            fontStyle: FontStyle.italic,
                            color: AppColors.outline,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),

                  // ── Session Override ──
                  _buildSectionWrapper(
                    'Session Override',
                    null,
                    delay: 700,
                    child: GlassContainer(
                      borderRadius: 16,
                      opacity: 0.35,
                      padding: const EdgeInsets.all(18),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Temporary Mode',
                                  style: AppTypography.titleMedium(context),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Explore freely without affecting your long-term preferences.',
                                  style: AppTypography.bodySmall(context),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Switch.adaptive(
                            value: _sessionOverride,
                            onChanged: (v) {
                              HapticFeedback.selectionClick();
                              setState(() => _sessionOverride = v);
                            },
                            activeTrackColor: AppColors.primary,
                            inactiveTrackColor: AppColors.surfaceBright,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionWrapper(
    String title,
    String? subtitle, {
    required int delay,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: title, subtitle: subtitle),
        const SizedBox(height: 14),
        child,
      ],
    )
        .animate()
        .fadeIn(delay: Duration(milliseconds: delay), duration: 500.ms)
        .slideY(begin: 0.05, end: 0, duration: 500.ms);
  }

  Widget _buildDomainChip(String label, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isActive
            ? AppColors.primaryContainer.withValues(alpha: 0.25)
            : AppColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(12),
        border: isActive
            ? Border.all(color: AppColors.primary.withValues(alpha: 0.3))
            : Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.1)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isActive ? Icons.check_circle_rounded : Icons.circle_outlined,
            size: 16,
            color: isActive ? AppColors.primary : AppColors.outline,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: AppTypography.labelLarge(context).copyWith(
              color: isActive ? AppColors.primary : AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalOption(String label, String desc, IconData icon) {
    final isActive = _goalMode == label;
    return PressableScale(
      onTap: () {
        HapticFeedback.selectionClick();
        setState(() => _goalMode = label);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.primaryContainer.withValues(alpha: 0.15)
              : AppColors.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(14),
          border: isActive
              ? Border.all(color: AppColors.primary.withValues(alpha: 0.4))
              : Border.all(
                  color: AppColors.outlineVariant.withValues(alpha: 0.08)),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: isActive
                    ? AppColors.primaryContainer.withValues(alpha: 0.3)
                    : AppColors.surfaceBright,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                size: 18,
                color: isActive ? AppColors.primary : AppColors.outline,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppTypography.titleMedium(context).copyWith(
                      color: isActive
                          ? AppColors.primary
                          : AppColors.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(desc, style: AppTypography.bodySmall(context)),
                ],
              ),
            ),
            if (isActive)
              Icon(
                Icons.check_circle_rounded,
                size: 22,
                color: AppColors.primary,
              ),
          ],
        ),
      ),
    );
  }
}
