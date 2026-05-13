import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tindahan_natin/features/auth/auth_service.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue[700]!, Colors.blue[900]!],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.store, size: 120, color: Colors.white)
                  .animate()
                  .scale(duration: 800.ms, curve: Curves.elasticOut)
                  .fadeIn(),
              const SizedBox(height: 24),
              const Text(
                'Tindahan Natin',
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2),
              const SizedBox(height: 8),
              const Text(
                'Your sari-sari store, digitized.',
                style: TextStyle(fontSize: 18, color: Colors.white70),
              ).animate().fadeIn(delay: 500.ms),
              const SizedBox(height: 60),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: authState.when(
                  data: (credentials) => credentials == null
                      ? ElevatedButton(
                          onPressed: () => ref.read(authStateProvider.notifier).login(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.blue[900],
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.login),
                              SizedBox(width: 12),
                              Text('Login to Get Started'),
                            ],
                          ),
                        ).animate().fadeIn(delay: 700.ms).scale()
                      : Column(
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundImage: NetworkImage(credentials.user.pictureUrl.toString()),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Kumusta, ${credentials.user.name}!',
                              style: const TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton(
                              onPressed: () => ref.read(authStateProvider.notifier).logout(),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.redAccent,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Logout'),
                            ),
                          ],
                        ),
                  loading: () => const CircularProgressIndicator(color: Colors.white),
                  error: (e, s) => Text('Error: $e', style: const TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}