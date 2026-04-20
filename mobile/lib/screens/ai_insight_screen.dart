/// GitSwipe — AI Repository Insight Screen
///
/// Detailed AI-generated analysis of a repository with
/// key features, architecture stack, practical use cases.


import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import '../models/repository.dart';
import '../widgets/shared_widgets.dart';

class AiInsightScreen extends StatelessWidget {
  const AiInsightScreen({super.key, required this.repo});

  final Repository repo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Background accent glow
          Positioned(
            top: -100,
            right: -80,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.primaryContainer.withValues(alpha: 0.1),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // App bar
              SliverAppBar(
                backgroundColor: Colors.transparent,
                leading: _buildBackButton(context),
                pinned: true,
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Hero ──
                      _buildHero(context),
                      const SizedBox(height: 32),

                      // ── AI Summary ──
                      _buildAiSummary(context),
                      const SizedBox(height: 28),

                      // ── Technical Key Features ──
                      _buildKeyFeatures(context),
                      const SizedBox(height: 28),

                      // ── Architecture Stack ──
                      _buildArchStack(context),
                      const SizedBox(height: 28),

                      // ── Practical Use Cases ──
                      _buildUseCases(context),
                      const SizedBox(height: 120),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12),
      child: PressableScale(
        onTap: () => Navigator.of(context).pop(),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.surfaceContainer.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.06),
                ),
              ),
              child: const Icon(Icons.arrow_back_rounded, size: 20),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHero(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // AI Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primaryContainer.withValues(alpha: 0.3),
                AppColors.primary.withValues(alpha: 0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.auto_awesome_rounded,
                  size: 14, color: AppColors.primary),
              const SizedBox(width: 6),
              Text(
                'AI Repository Insight',
                style: AppTypography.labelMedium(context).copyWith(
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        )
            .animate()
            .fadeIn(duration: 400.ms)
            .slideX(begin: -0.1, end: 0, duration: 400.ms),
        const SizedBox(height: 16),

        Text(
          repo.name,
          style: AppTypography.headlineLarge(context).copyWith(
            fontSize: 34,
            fontWeight: FontWeight.w700,
          ),
        )
            .animate()
            .fadeIn(delay: 100.ms, duration: 500.ms)
            .slideX(begin: -0.05, end: 0, duration: 500.ms),
      ],
    );
  }

  Widget _buildAiSummary(BuildContext context) {
    return GlassContainer(
      borderRadius: 20,
      opacity: 0.4,
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryContainer],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Icon(Icons.psychology_rounded,
                      size: 16, color: Colors.white),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'AI Analysis',
                style: AppTypography.titleMedium(context).copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            repo.cardSummary ?? repo.description,
            style: AppTypography.bodyLarge(context).copyWith(
              height: 1.7,
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(delay: 200.ms, duration: 500.ms)
        .slideY(begin: 0.05, end: 0, duration: 500.ms);
  }

  Widget _buildKeyFeatures(BuildContext context) {
    final features = [
      {
        'title': 'Polymorphic Components',
        'desc':
            'Full support for the "as" prop pattern, allowing components to render as any HTML tag while maintaining strict TypeScript definitions.',
        'icon': Icons.widgets_rounded,
      },
      {
        'title': 'Design Token Bridge',
        'desc':
            'Automatic translation from Figma styles to CSS variables, ensuring a single source of truth for the entire design system.',
        'icon': Icons.palette_rounded,
      },
      {
        'title': 'Headless Logic',
        'desc':
            'Decoupled functionality from styling, enabling developers to build custom interfaces without fighting pre-built styles.',
        'icon': Icons.extension_rounded,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: 'Technical Key Features'),
        const SizedBox(height: 14),
        ...features.asMap().entries.map((entry) {
          final i = entry.key;
          final feature = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: GhostBorderCard(
              borderRadius: 16,
              padding: const EdgeInsets.all(18),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.primaryContainer.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      feature['icon'] as IconData,
                      size: 20,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          feature['title'] as String,
                          style: AppTypography.titleMedium(context).copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          feature['desc'] as String,
                          style: AppTypography.bodySmall(context),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
                .animate()
                .fadeIn(
                  delay: Duration(milliseconds: 300 + (i * 100)),
                  duration: 500.ms,
                )
                .slideX(
                  begin: 0.05,
                  end: 0,
                  delay: Duration(milliseconds: 300 + (i * 100)),
                  duration: 500.ms,
                ),
          );
        }),
      ],
    );
  }

  Widget _buildArchStack(BuildContext context) {
    final techs = ['React 18', 'TypeScript 5', 'Vite', 'Vitest', 'Storybook'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Architecture Stack',
          subtitle: 'CURATED MODERN TECHNOLOGIES',
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: techs.map((tech) {
            return GlassContainer(
              borderRadius: 12,
              opacity: 0.3,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              child: Text(
                tech,
                style: AppTypography.labelLarge(context).copyWith(
                  color: AppColors.onSurface,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    )
        .animate()
        .fadeIn(delay: 500.ms, duration: 500.ms)
        .slideY(begin: 0.05, end: 0, duration: 500.ms);
  }

  Widget _buildUseCases(BuildContext context) {
    final cases = [
      {
        'title': 'FinTech Trading Terminals',
        'desc':
            'Perfect for real-time data streaming where UI latency can impact user decisions.',
        'icon': Icons.candlestick_chart_rounded,
      },
      {
        'title': 'SaaS Multi-Tenant Platforms',
        'desc':
            'The robust token system allows for easy white-labeling across different brand identities.',
        'icon': Icons.cloud_rounded,
      },
      {
        'title': 'Developer Productivity Tools',
        'desc':
            'Pre-built complex components like data tables and filtered lists speed up internal tool builds.',
        'icon': Icons.terminal_rounded,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: 'Practical Use Cases'),
        const SizedBox(height: 14),
        ...cases.asMap().entries.map((entry) {
          final i = entry.key;
          final useCase = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: GlassContainer(
              borderRadius: 16,
              opacity: 0.3,
              padding: const EdgeInsets.all(18),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.secondaryContainer.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      useCase['icon'] as IconData,
                      size: 22,
                      color: AppColors.secondary,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          useCase['title'] as String,
                          style: AppTypography.titleMedium(context).copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          useCase['desc'] as String,
                          style: AppTypography.bodySmall(context),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
                .animate()
                .fadeIn(
                  delay: Duration(milliseconds: 600 + (i * 100)),
                  duration: 500.ms,
                )
                .slideX(
                  begin: 0.05,
                  end: 0,
                  delay: Duration(milliseconds: 600 + (i * 100)),
                  duration: 500.ms,
                ),
          );
        }),
      ],
    );
  }
}
