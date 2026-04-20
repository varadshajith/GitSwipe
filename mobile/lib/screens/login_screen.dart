/// GitSwipe — Login Screen
///
/// Full-screen dark landing with glassmorphic card, animated background,
/// GitHub OAuth button, and code snippet decoration.


import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.onLogin});

  final VoidCallback onLogin;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  late final AnimationController _bgController;

  @override
  void initState() {
    super.initState();
    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _bgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // ── Animated gradient background ──
          AnimatedBuilder(
            animation: _bgController,
            builder: (context, _) {
              return Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment(
                      math.sin(_bgController.value * math.pi * 2) * 0.3,
                      math.cos(_bgController.value * math.pi * 2) * 0.3 - 0.2,
                    ),
                    radius: 1.5,
                    colors: [
                      AppColors.primaryContainer.withValues(alpha: 0.12),
                      AppColors.background,
                    ],
                  ),
                ),
              );
            },
          ),

          // ── Floating code snippet (decorative) ──
          Positioned(
            top: MediaQuery.of(context).size.height * 0.12,
            right: -40,
            child: Transform.rotate(
              angle: 0.15,
              child: _buildCodeSnippet(),
            ),
          ),

          // ── Main content ──
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  const Spacer(flex: 3),
                  // Logo / Brand
                  _buildLogo()
                      .animate()
                      .fadeIn(duration: 800.ms, curve: AppAnimation.defaultCurve)
                      .slideY(begin: 0.3, end: 0, duration: 800.ms),
                  const SizedBox(height: 16),
                  // Tagline
                  Text(
                    'Discover your next\nobsession.',
                    textAlign: TextAlign.center,
                    style: AppTypography.headlineLarge(context).copyWith(
                      height: 1.15,
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 200.ms, duration: 800.ms)
                      .slideY(begin: 0.2, end: 0, duration: 800.ms),
                  const SizedBox(height: 16),
                  Text(
                    'Swipe through curated open-source repositories\ntailored to your interests.',
                    textAlign: TextAlign.center,
                    style: AppTypography.bodyMedium(context),
                  )
                      .animate()
                      .fadeIn(delay: 400.ms, duration: 800.ms),
                  const Spacer(flex: 2),

                  // ── GitHub Login Button ──
                  _buildLoginButton()
                      .animate()
                      .fadeIn(delay: 600.ms, duration: 600.ms)
                      .slideY(begin: 0.4, end: 0, duration: 600.ms),
                  const SizedBox(height: 20),

                  // Terms text
                  Text(
                    'By continuing, you agree to our Terms and Privacy.',
                    textAlign: TextAlign.center,
                    style: AppTypography.bodySmall(context).copyWith(
                      color: AppColors.outline,
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 800.ms, duration: 600.ms),
                  const SizedBox(height: 48),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.primary, AppColors.primaryContainer],
            ),
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryContainer.withValues(alpha: 0.3),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Center(
            child: Icon(Icons.swipe_rounded, color: Colors.white, size: 28),
          ),
        ),
        const SizedBox(width: 14),
        Text(
          'GitSwipe',
          style: AppTypography.headlineLarge(context).copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton() {
    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        widget.onLogin();
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primaryContainer, Color(0xFF1a5fd4)],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.3),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryContainer.withValues(alpha: 0.3),
                  blurRadius: 32,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.code_rounded, color: Colors.white, size: 22),
                const SizedBox(width: 12),
                Text(
                  'Continue with GitHub',
                  style: AppTypography.titleMedium(context).copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCodeSnippet() {
    return Opacity(
      opacity: 0.06,
      child: Container(
        padding: const EdgeInsets.all(20),
        width: 300,
        child: Text(
          "const session = await auth.login({\n"
          "  provider: 'github',\n"
          "  scope: ['repo', 'user']\n"
          "});\n\n"
          "await pipeline.discover({\n"
          "  interests: user.profile,\n"
          "  depth: 'deep'\n"
          "});",
          style: AppTypography.labelMedium(context).copyWith(
            fontSize: 14,
            color: AppColors.primary,
            height: 1.8,
          ),
        ),
      ),
    );
  }
}
