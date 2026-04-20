/// GitSwipe — Repo Deep Dive Screen
///
/// Full-page exploration of a repository with glassmorphic sections,
/// tech stack display, folder highlights, and getting-started guide.


import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import '../models/repository.dart';
import '../widgets/shared_widgets.dart';

class RepoDeepDiveScreen extends StatelessWidget {
  const RepoDeepDiveScreen({
    super.key,
    required this.repo,
    this.onChatTap,
  });

  final Repository repo;
  final VoidCallback? onChatTap;

  String _formatNumber(int n) {
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}k';
    return n.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // ── Background glow ──
          Positioned(
            top: -120,
            left: -60,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    repo.languageColor.withValues(alpha: 0.08),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // ── App bar ──
              SliverAppBar(
                backgroundColor: Colors.transparent,
                leading: _buildBackButton(context),
                actions: [
                  _buildGithubButton(context),
                  const SizedBox(width: 12),
                ],
                pinned: true,
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Hero section ──
                      _buildHeroSection(context),
                      const SizedBox(height: 28),

                      // ── What it is ──
                      _buildSection(
                        context,
                        title: 'What it is',
                        delay: 200,
                        child: Text(
                          repo.cardSummary ?? repo.description,
                          style: AppTypography.bodyLarge(context).copyWith(
                            fontSize: 15,
                            height: 1.7,
                            fontStyle: FontStyle.italic,
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // ── The Stack ──
                      _buildSection(
                        context,
                        title: 'The Stack',
                        delay: 300,
                        child: _buildTechStack(context),
                      ),
                      const SizedBox(height: 24),

                      // ── Key Metrics ──
                      _buildSection(
                        context,
                        title: 'Key Metrics',
                        delay: 400,
                        child: _buildMetricsGrid(context),
                      ),
                      const SizedBox(height: 24),

                      // ── Folder Highlights ──
                      _buildSection(
                        context,
                        title: 'Folder Highlights',
                        delay: 500,
                        child: _buildFolderHighlights(context),
                      ),
                      const SizedBox(height: 24),

                      // ── How to Start ──
                      _buildSection(
                        context,
                        title: 'How to Start',
                        delay: 600,
                        child: _buildGettingStarted(context),
                      ),
                      const SizedBox(height: 24),

                      // ── Topics ──
                      _buildSection(
                        context,
                        title: 'Topics',
                        delay: 700,
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: repo.topics
                              .map((t) => TopicChip(label: t))
                              .toList(),
                        ),
                      ),
                      const SizedBox(height: 120),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // ── Floating Chat FAB ──
          if (onChatTap != null)
            Positioned(
              bottom: 32,
              right: 24,
              child: GlassActionButton(
                icon: Icons.chat_bubble_outline_rounded,
                color: AppColors.primary,
                size: 64,
                iconSize: 28,
                onTap: onChatTap!,
              )
                  .animate()
                  .fadeIn(delay: 800.ms, duration: 500.ms)
                  .scale(begin: const Offset(0.5, 0.5), end: const Offset(1, 1), duration: 500.ms),
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

  Widget _buildGithubButton(BuildContext context) {
    return PressableScale(
      onTap: () => HapticFeedback.lightImpact(),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainer.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.06),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.open_in_new_rounded, size: 16),
                const SizedBox(width: 6),
                Text(
                  'GitHub',
                  style: AppTypography.labelMedium(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Owner
        Text(
          repo.owner,
          style: AppTypography.labelLarge(context).copyWith(
            color: AppColors.outline,
          ),
        )
            .animate()
            .fadeIn(duration: 400.ms),
        const SizedBox(height: 4),
        // Name
        Text(
          repo.name,
          style: AppTypography.headlineLarge(context).copyWith(
            fontSize: 36,
            fontWeight: FontWeight.w700,
          ),
        )
            .animate()
            .fadeIn(duration: 500.ms)
            .slideX(begin: -0.05, end: 0, duration: 500.ms),
        const SizedBox(height: 16),
        // Stats row
        Row(
          children: [
            StatBadge(
              icon: Icons.star_rounded,
              value: _formatNumber(repo.stars),
              color: const Color(0xFFffd54f),
            ),
            const SizedBox(width: 20),
            StatBadge(
              icon: Icons.call_split_rounded,
              value: _formatNumber(repo.forks),
            ),
            const SizedBox(width: 20),
            LanguageChip(
              language: repo.language,
              color: repo.languageColor,
            ),
            if (repo.license != null) ...[
              const SizedBox(width: 20),
              StatBadge(
                icon: Icons.gavel_rounded,
                value: repo.license!,
              ),
            ],
          ],
        )
            .animate()
            .fadeIn(delay: 100.ms, duration: 400.ms),
      ],
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required int delay,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: title,
          subtitle: null,
        ),
        const SizedBox(height: 14),
        child,
      ],
    )
        .animate()
        .fadeIn(delay: Duration(milliseconds: delay), duration: 500.ms)
        .slideY(begin: 0.05, end: 0, duration: 500.ms);
  }

  Widget _buildTechStack(BuildContext context) {
    final techs = [
      {'name': repo.language, 'icon': Icons.code_rounded, 'color': repo.languageColor},
      {'name': 'GitHub Actions', 'icon': Icons.play_circle_rounded, 'color': AppColors.secondary},
      {'name': 'Docker', 'icon': Icons.inventory_2_rounded, 'color': const Color(0xFF2496ED)},
      {'name': 'npm', 'icon': Icons.terminal_rounded, 'color': const Color(0xFFCB3837)},
    ];

    return Row(
      children: techs.map((tech) {
        return Expanded(
          child: GhostBorderCard(
            borderRadius: 14,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            child: Column(
              children: [
                Icon(
                  tech['icon'] as IconData,
                  size: 24,
                  color: tech['color'] as Color,
                ),
                const SizedBox(height: 8),
                Text(
                  tech['name'] as String,
                  style: AppTypography.labelSmall(context),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMetricsGrid(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GlassContainer(
            borderRadius: 16,
            opacity: 0.35,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.commit_rounded, size: 20, color: AppColors.primary),
                const SizedBox(height: 8),
                Text(
                  '${repo.commitFrequency ?? 0}/wk',
                  style: AppTypography.headlineSmall(context),
                ),
                Text(
                  'COMMITS',
                  style: AppTypography.labelSmall(context),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: GlassContainer(
            borderRadius: 16,
            opacity: 0.35,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.trending_up_rounded, size: 20, color: AppColors.secondary),
                const SizedBox(height: 8),
                Text(
                  '${repo.starVelocity?.toStringAsFixed(1) ?? '0'}/day',
                  style: AppTypography.headlineSmall(context),
                ),
                Text(
                  'STAR VELOCITY',
                  style: AppTypography.labelSmall(context),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFolderHighlights(BuildContext context) {
    final folders = [
      {'path': 'src/core/', 'desc': 'Core engine and runtime'},
      {'path': 'src/components/', 'desc': 'UI component library'},
      {'path': 'tests/', 'desc': 'Test suites and fixtures'},
      {'path': 'docs/', 'desc': 'Documentation and guides'},
    ];

    return Column(
      children: folders.map((f) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: GhostBorderCard(
            borderRadius: 12,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                Icon(
                  Icons.folder_rounded,
                  size: 20,
                  color: AppColors.primary.withValues(alpha: 0.7),
                ),
                const SizedBox(width: 12),
                Text(
                  f['path'] as String,
                  style: AppTypography.labelLarge(context).copyWith(
                    color: AppColors.primary,
                  ),
                ),
                const Spacer(),
                Text(
                  f['desc'] as String,
                  style: AppTypography.bodySmall(context),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildGettingStarted(BuildContext context) {
    final steps = [
      {
        'title': 'Clone & Install',
        'cmd': 'git clone ${repo.githubUrl}\ncd ${repo.name} && npm install',
      },
      {
        'title': 'Bootstrap Engine',
        'cmd': 'npm run build:engine',
      },
      {
        'title': 'Define Schema',
        'cmd': 'touch config.yaml && npm run dev',
      },
    ];

    return Column(
      children: steps.asMap().entries.map((entry) {
        final i = entry.key;
        final step = entry.value;
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: GhostBorderCard(
            borderRadius: 14,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: AppColors.primaryContainer.withValues(alpha: 0.3),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${i + 1}',
                          style: AppTypography.labelMedium(context).copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      step['title'] as String,
                      style: AppTypography.titleMedium(context).copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    step['cmd'] as String,
                    style: AppTypography.labelMedium(context).copyWith(
                      fontSize: 12,
                      height: 1.6,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
