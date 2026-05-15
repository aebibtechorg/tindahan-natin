import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tindahan_natin/shared/widgets/app_logo.dart';

class StoreLookupScreen extends StatefulWidget {
  const StoreLookupScreen({super.key});

  @override
  State<StoreLookupScreen> createState() => _StoreLookupScreenState();
}

class _StoreLookupScreenState extends State<StoreLookupScreen> {
  final TextEditingController _slugController = TextEditingController();

  @override
  void dispose() {
    _slugController.dispose();
    super.dispose();
  }

  void _openStore() {
    final slug = _slugController.text.trim();
    if (slug.isEmpty) return;

    context.go('/store/${Uri.encodeComponent(slug)}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Open Store'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Center(child: AppLogo(size: 64)),
                    const SizedBox(height: 16),
                    Text(
                      'Enter a store ID to open its public page.',
                      style: Theme.of(context).textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    TextField(
                      controller: _slugController,
                      decoration: const InputDecoration(
                        labelText: 'Store ID',
                        hintText: 'example-store',
                      ),
                      textInputAction: TextInputAction.go,
                      onSubmitted: (_) => _openStore(),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _openStore,
                      child: const Text('Go to Store'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
