/// GitSwipe — Saved Repos Screen
///
/// Gallery of saved repositories with glassmorphic list items,
/// tonal layering, and staggered entrance animations.


import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import '../models/repository.dart';
import '../widgets/shared_widgets.dart';

class SavedReposScreen extends StatefulWidget {
  const SavedReposScreen({super.key, required this.onRepoTap});

  final void Function(Repository repo) onRepoTap;

  @override
  State<SavedReposScreen> createState() => _SavedReposScreenState();
}

class _SavedReposScreenState extends State<SavedReposScreen> {
  // Use first 5 repos as "saved" for demo
  late final List<Repository> _savedRepos;

  @override
  void initState() {
    super.initState();
    _savedRepos = mockRepositories.take(5).toList();
  }

  String _formatNumber(int n) {
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}k';
    return n.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── Header ──
          SliverToBoxAdapter(
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Collection',
                      style: AppTypography.headlineLarge(context),
                    )
                        .animate()
                        .fadeIn(duration: 500.ms)
                        .slideX(begin: -0.1, end: 0, duration: 500.ms),
                    const SizedBox(height: 8),
                    Text(
                      'Your curated gallery of world-class source code.',
                      style: AppTypography.bodyMedium(context),
                    )
                        .animate()
                        .fadeIn(delay: 200.ms, duration: 500.ms),
                    const SizedBox(height: 24),

                    // Stats row
                    Row(
                      children: [
                        _buildStatCard(
                          '${_savedRepos.length}',
                          'Saved',
                          Icons.bookmark_rounded,
                          AppColors.primary,
                        ),
                        const SizedBox(width: 12),
                        _buildStatCard(
                          '3',
                          'Languages',
                          Icons.code_rounded,
                          AppColors.secondary,
                        ),
                        const SizedBox(width: 12),
                        _buildStatCard(
                          '18',
                          'Topics',
                          Icons.tag_rounded,
                          AppColors.tertiary,
                        ),
                      ],
                    )
                        .animate()
                        .fadeIn(delay: 300.ms, duration: 500.ms)
                        .slideY(begin: 0.2, end: 0, duration: 500.ms),
                    const SizedBox(height: 28),
                  ],
                ),
              ),
            ),
          ),

          // ── Saved Repos List ──
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (index >= _savedRepos.length) return null;
                  final repo = _savedRepos[index];
                  return _buildRepoListItem(repo, index)
                      .animate()
                      .fadeIn(
                        delay: Duration(milliseconds: 100 * index),
                        duration: 500.ms,
                      )
                      .slideX(
                        begin: 0.05,
                        end: 0,
                        delay: Duration(milliseconds: 100 * index),
                        duration: 500.ms,
                        curve: AppAnimation.defaultCurve,
                      );
                },
                childCount: _savedRepos.length,
              ),
            ),
          ),

          // ── CTA at bottom ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: GlassContainer(
                borderRadius: 16,
                opacity: 0.4,
                child: Column(
                  children: [
                    Icon(
                      Icons.swipe_rounded,
                      size: 32,
                      color: AppColors.primary.withValues(alpha: 0.6),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Discover More',
                      style: AppTypography.titleMedium(context),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Swipe on more repositories to grow your gallery.',
                      style: AppTypography.bodySmall(context),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
                  .animate()
                  .fadeIn(delay: 600.ms, duration: 500.ms),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String value,
    String label,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: GlassContainer(
        borderRadius: 16,
        opacity: 0.35,
        blurSigma: 12,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(height: 10),
            Text(
              value,
              style: AppTypography.headlineSmall(context).copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label.toUpperCase(),
              style: AppTypography.labelSmall(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRepoListItem(Repository repo, int index) {
    // Alternate tonal background for "no-line" separation
    final isEven = index.isEven;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: PressableScale(
        onTap: () {
          HapticFeedback.lightImpact();
          widget.onRepoTap(repo);
        },
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: isEven
                ? AppColors.surfaceContainerHigh.withValues(alpha: 0.7)
                : AppColors.surfaceContainerLow.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.outlineVariant.withValues(alpha: 0.08),
            ),
          ),
          child: Row(
            children: [
              // Owner avatar
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      repo.languageColor.withValues(alpha: 0.3),
                      repo.languageColor.withValues(alpha: 0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    repo.owner[0].toUpperCase(),
                    style: AppTypography.titleMedium(context).copyWith(
                      color: repo.languageColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      repo.name,
                      style: AppTypography.titleMedium(context).copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      repo.description,
                      style: AppTypography.bodySmall(context),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  StatBadge(
                    icon: Icons.star_rounded,
                    value: _formatNumber(repo.stars),
                    color: const Color(0xFFffd54f),
                  ),
                  const SizedBox(height: 6),
                  LanguageChip(
                    language: repo.language,
                    color: repo.languageColor,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
