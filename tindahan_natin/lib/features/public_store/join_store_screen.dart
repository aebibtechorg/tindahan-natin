import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tindahan_natin/features/auth/auth_service.dart';
import 'package:tindahan_natin/features/settings/store_service.dart';
import 'package:tindahan_natin/shared/widgets/app_logo.dart';

class JoinStoreScreen extends ConsumerStatefulWidget {
  final String code;

  const JoinStoreScreen({super.key, required this.code});

  @override
  ConsumerState<JoinStoreScreen> createState() => _JoinStoreScreenState();
}

class _JoinStoreScreenState extends ConsumerState<JoinStoreScreen> {
  String? _error;
  bool _success = false;
  bool _joining = false;

  @override
  void initState() {
    super.initState();
    // Use addPostFrameCallback to check if we can join immediately
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndJoin();
    });
  }

  void _checkAndJoin() {
    final auth = ref.read(authStateProvider);
    if (auth.value != null && !_joining && !_success) {
      _join();
    }
  }

  Future<void> _join() async {
    setState(() {
      _joining = true;
      _error = null;
    });
    try {
      await ref.read(storeServiceProvider).joinStore(widget.code);
      ref.invalidate(membershipsProvider);
      if (context.mounted) {
        setState(() => _success = true);
        await Future.delayed(const Duration(seconds: 2));
        if (context.mounted) {
          context.go('/settings');
        }
      }
    } catch (e) {
      if (context.mounted) {
        setState(() {
          _error = e.toString();
          _joining = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);

    // If they just logged in, trigger the join
    ref.listen(authStateProvider, (previous, next) {
      if (next.value != null && previous?.value == null) {
        _join();
      }
    });

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const AppLogo(size: 80),
              const SizedBox(height: 32),
              if (authState.value == null && !authState.isLoading) ...[
                const Icon(Icons.lock_outline, color: Colors.orange, size: 64),
                const SizedBox(height: 16),
                Text(
                  'Authentication Required',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Please login or create an account to join the store.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  onPressed: () => ref.read(authStateProvider.notifier).login(),
                  icon: const Icon(Icons.login),
                  label: const Text('Login / Signup to Join'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                ),
              ] else if (_success) ...[
                const Icon(Icons.check_circle_outline, color: Colors.green, size: 64),
                const SizedBox(height: 16),
                Text(
                  'Successfully joined store!',
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text('Redirecting to your dashboard...'),
              ] else if (_error != null) ...[
                const Icon(Icons.error_outline, color: Colors.red, size: 64),
                const SizedBox(height: 16),
                Text(
                  'Failed to join store',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(_error!, textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => context.go('/'),
                  child: const Text('Go to Home'),
                ),
              ] else ...[
                const CircularProgressIndicator(),
                const SizedBox(height: 24),
                Text(
                  _joining ? 'Joining store...' : 'Checking status...',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                const Text('Please wait while we set up your access.'),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
