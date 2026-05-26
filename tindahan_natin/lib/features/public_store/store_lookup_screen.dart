import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tindahan_natin/features/settings/store_service.dart';
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
                    const Divider(height: 48),
                    Text(
                      'Are you a staff member?',
                      style: Theme.of(context).textTheme.titleSmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: () => _showJoinStoreDialog(context),
                      icon: const Icon(Icons.group_add_outlined),
                      label: const Text('Join Store with Invite Code'),
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

  void _showJoinStoreDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const _JoinStoreDialog(),
    );
  }
}

class _JoinStoreDialog extends ConsumerStatefulWidget {
  const _JoinStoreDialog();

  @override
  ConsumerState<_JoinStoreDialog> createState() => _JoinStoreDialogState();
}

class _JoinStoreDialogState extends ConsumerState<_JoinStoreDialog> {
  final _controller = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Join Store'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Enter the 8-character invite code provided by your store owner.'),
          const SizedBox(height: 16),
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              labelText: 'Invite Code',
              hintText: 'ABC123XY',
              border: OutlineInputBorder(),
            ),
            textCapitalization: TextCapitalization.characters,
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: _loading
              ? null
              : () async {
                  final code = _controller.text.trim();
                  if (code.isEmpty) return;

                  setState(() => _loading = true);
                  try {
                    await ref.read(storeServiceProvider).joinStore(code);
                    ref.invalidate(membershipsProvider);
                    if (context.mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Successfully joined the store!')),
                      );
                      context.go('/settings');
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: $e')),
                      );
                    }
                  } finally {
                    if (context.mounted) setState(() => _loading = false);
                  }
                },
          child: _loading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Join'),
        ),
      ],
    );
  }
}
