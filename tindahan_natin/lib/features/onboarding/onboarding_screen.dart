import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tindahan_natin/core/storage/local_storage.dart';
import 'package:tindahan_natin/shared/widgets/app_logo.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingSlideData> _slides = [
    OnboardingSlideData(
      title: 'Welcome to Tindahan Natin',
      description: 'Your practical mini inventory operating system for family stores, small businesses, and retail kiosks.',
      color: Colors.blue,
      useLogo: true,
    ),
    OnboardingSlideData(
      title: 'Interactive Store Map',
      description: 'Visualize your physical store layout. Add, rotate, and place shelves, then assign products to see exactly where they belong.',
      icon: Icons.map_outlined,
      color: Colors.orange,
    ),
    OnboardingSlideData(
      title: 'Smart Barcode & Low Stock Alerts',
      description: 'Scan barcodes to quickly add products. Define a low stock threshold to automatically keep track of items needing a restock.',
      icon: Icons.notifications_active_outlined,
      color: Colors.purple,
    ),
    OnboardingSlideData(
      title: 'Public Sharing & Lista',
      description: 'Share your store map publicly so customers can locate products themselves, and track listing updates seamlessly.',
      icon: Icons.share_outlined,
      color: Colors.teal,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _finishOnboarding() async {
    await ref.read(localStorageProvider).setOnboardingCompleted(true);
    if (mounted) {
      context.go('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.2),
              Theme.of(context).colorScheme.surface,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const AppLogo(size: 32, showText: true),
                    TextButton(
                      onPressed: _finishOnboarding,
                      child: const Text('Skip'),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _slides.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    final slide = _slides[index];
                    return _OnboardingSlide(slide: slide);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Slide Indicators
                    Row(
                      children: List.generate(
                        _slides.length,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.only(right: 8.0),
                          height: 8.0,
                          width: _currentPage == index ? 24.0 : 8.0,
                          decoration: BoxDecoration(
                            color: _currentPage == index
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                        ),
                      ),
                    ),
                    // Next / Finish Button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(0, 56),
                        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {
                        if (_currentPage < _slides.length - 1) {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          _finishOnboarding();
                        }
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(_currentPage == _slides.length - 1 ? 'Get Started' : 'Next'),
                          const SizedBox(width: 8),
                          Icon(
                            _currentPage == _slides.length - 1 ? Icons.check : Icons.arrow_forward,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OnboardingSlideData {
  final String title;
  final String description;
  final IconData? icon;
  final Color color;
  final bool useLogo;

  OnboardingSlideData({
    required this.title,
    required this.description,
    this.icon,
    required this.color,
    this.useLogo = false,
  });
}

class _OnboardingSlide extends StatelessWidget {
  final OnboardingSlideData slide;

  const _OnboardingSlide({required this.slide});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (slide.useLogo)
            const AppLogo(size: 150, showText: false)
                .animate()
                .scale(delay: 100.ms, duration: 400.ms, curve: Curves.easeOutBack)
          else
            Container(
              padding: const EdgeInsets.all(32.0),
              decoration: BoxDecoration(
                color: slide.color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                slide.icon,
                size: 100,
                color: slide.color,
              ),
            ).animate().scale(delay: 100.ms, duration: 400.ms, curve: Curves.easeOutBack),
          const SizedBox(height: 48),
          Text(
            slide.title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
          ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, curve: Curves.easeOutQuad),
          const SizedBox(height: 16),
          Text(
            slide.description,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  height: 1.5,
                ),
          ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2, curve: Curves.easeOutQuad),
        ],
      ),
    );
  }
}
