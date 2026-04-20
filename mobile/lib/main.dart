import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/login_screen.dart';
import 'screens/swipe_feed_screen.dart';
import 'screens/repo_deep_dive_screen.dart';
import 'screens/ai_insight_screen.dart';
import 'screens/guide_chat_screen.dart';
import 'screens/preferences_screen.dart';
import 'screens/saved_repos_screen.dart';
import 'widgets/bottom_nav_bar.dart';
import 'models/repository.dart';

void main() {
  runApp(const GitSwipeApp());
}

class GitSwipeApp extends StatelessWidget {
  const GitSwipeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GitSwipe',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: const MainNavigationWrapper(),
    );
  }
}

class MainNavigationWrapper extends StatefulWidget {
  const MainNavigationWrapper({super.key});

  @override
  State<MainNavigationWrapper> createState() => _MainNavigationWrapperState();
}

class _MainNavigationWrapperState extends State<MainNavigationWrapper> {
  int _currentIndex = 0;
  bool _isLoggedIn = false;

  @override
  Widget build(BuildContext context) {
    if (!_isLoggedIn) {
      return LoginScreen(onLogin: () {
        setState(() => _isLoggedIn = true);
      });
    }

    return Scaffold(
      body: Stack(
        children: [
          IndexedStack(
            index: _currentIndex,
            children: [
              SwipeFeedScreen(
                onRepoTap: (repo) => _showRepoDeepDive(context, repo),
              ),
              AiInsightScreen(repo: mockRepositories[1]), // Demo with second repo
              SavedReposScreen(
                onRepoTap: (repo) => _showRepoDeepDive(context, repo),
              ),
              const PreferencesScreen(),
            ],
          ),
          AppBottomNavBar(
            currentIndex: _currentIndex,
            onTap: (index) => setState(() => _currentIndex = index),
          ),
        ],
      ),
    );
  }

  void _showRepoDeepDive(BuildContext context, Repository repo) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => RepoDeepDiveScreen(
          repo: repo,
          onChatTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => GuideChatScreen(
                repoName: repo.name,
                repoOwner: repo.owner,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
