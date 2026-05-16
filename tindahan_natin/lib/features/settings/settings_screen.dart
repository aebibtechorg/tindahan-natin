import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tindahan_natin/core/config/package_info.dart';
import 'package:tindahan_natin/core/config/public_web_config.dart';
import 'package:tindahan_natin/core/widgets/inline_ad_widget.dart';
import 'package:tindahan_natin/features/settings/store_service.dart';
import 'package:tindahan_natin/features/auth/auth_service.dart';
import 'package:tindahan_natin/features/dashboard/store.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  var _loading = false;
  String? _lastSyncedStoreName;

  Future<void> _shareStore(Store store) async {
    final shareUrl = buildPublicStoreUrl(slug: store.slug);
    if (shareUrl == null) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Public store sharing is not configured')),
      );
      return;
    }

    final shareText = store.name.trim().isEmpty
        ? shareUrl
        : 'Check out ${store.name} on Tindahan Natin \n$shareUrl';

    await SharePlus.instance.share(ShareParams(text: shareText));
  }

  void _syncNameFromStore(Store? store) {
    if (store == null) {
      return;
    }

    final nextName = store.name;
    final currentName = _nameController.text;
    final shouldSync = currentName.isEmpty || currentName == _lastSyncedStoreName;

    if (!shouldSync || currentName == nextName) {
      _lastSyncedStoreName = nextName;
      return;
    }

    _nameController.value = _nameController.value.copyWith(
      text: nextName,
      selection: TextSelection.collapsed(offset: nextName.length),
      composing: TextRange.empty,
    );
    _lastSyncedStoreName = nextName;
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final messenger = ScaffoldMessenger.of(context);

    setState(() => _loading = true);
    try {
      final svc = ref.read(storeServiceProvider);
      await svc.updateStoreName(_nameController.text.trim());
      ref.invalidate(myStoreProvider);
      if (mounted) {
        messenger.showSnackBar(
          const SnackBar(content: Text('Store updated')),
        );
      }
    } catch (e) {
      if (mounted) {
        messenger.showSnackBar(
          const SnackBar(content: Text('Failed to update store')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final myStoreAsync = ref.watch(myStoreProvider);
    myStoreAsync.whenData(_syncNameFromStore);
    final showInitialLoading = myStoreAsync.isLoading && _nameController.text.isEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        actions: [
          if (PublicWebConfig.hasBaseUrl)
            myStoreAsync.when(
              data: (store) => IconButton(
                onPressed: store == null ? null : () => _shareStore(store),
                tooltip: 'Share public store',
                icon: const Icon(Icons.share_outlined),
              ),
              loading: () => const Padding(
                padding: EdgeInsets.only(right: 16),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
              error: (_, _) => const SizedBox.shrink(),
            ),
        ],
      ),
        body: _loading || showInitialLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Store name',
                      ),
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Enter a store name'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _loading ? null : _save,
                      child: const Text('Save'),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: _loading
                          ? null
                          : () async {
                              final messenger = ScaffoldMessenger.of(context);

                              setState(() => _loading = true);
                              try {
                                await ref
                                    .read(authStateProvider.notifier)
                                    .logout();
                                if (mounted) {
                                  messenger.showSnackBar(
                                    const SnackBar(content: Text('Logged out')),
                                  );
                                }
                              } catch (e) {
                                if (mounted) {
                                  messenger.showSnackBar(
                                    const SnackBar(
                                      content: Text('Failed to log out'),
                                    ),
                                  );
                                }
                              } finally {
                                if (mounted) {
                                  setState(() => _loading = false);
                                }
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                      ),
                      child: const Text('Log out'),
                    ),
                    const Spacer(),
                    const InlineAdWidget(),
                    const SizedBox(height: 16),
                    ref.watch(packageInfoProvider).when(
                          data: (info) => Text(
                            'Version ${info.version} (${info.buildNumber})',
                            style: Theme.of(context).textTheme.bodySmall,
                            textAlign: TextAlign.center,
                          ),
                          loading: () => const SizedBox.shrink(),
                          error: (_, stack) => const SizedBox.shrink(),
                        ),
                  ],
                ),
              ),
            ),
    );
  }
}
