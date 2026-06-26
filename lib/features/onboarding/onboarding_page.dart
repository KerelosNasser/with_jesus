import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'onboarding_page_1.dart';
import 'onboarding_page_2.dart';
import 'onboarding_page_3.dart';

/// Onboarding flow wrapper — a PageView with 3 onboarding screens.
///
/// Navigates to settings on completion, or skip at any point.
class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _pageController = PageController();
  var _currentPage = 0;

  void _goToPage(int page) {
    if (page < 0 || page > 2) return;
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  void _skipToSettings() {
    context.go('/home');
  }

  void _finishOnboarding() {
    context.go('/home');
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      physics: const ClampingScrollPhysics(),
      onPageChanged: (index) => setState(() => _currentPage = index),
      children: [
        OnboardingPage1(
          onSkip: _skipToSettings,
          onNext: () => _goToPage(1),
        ),
        OnboardingPage2(
          onSkip: _skipToSettings,
          onNext: () => _goToPage(2),
        ),
        OnboardingPage3(
          onStart: _finishOnboarding,
        ),
      ],
    );
  }
}
