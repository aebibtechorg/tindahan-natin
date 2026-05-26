import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tindahan_natin/core/config/package_info.dart';
import 'package:tindahan_natin/core/config/public_web_config.dart';
import 'package:tindahan_natin/core/widgets/inline_ad_widget.dart';
import 'package:tindahan_natin/features/settings/store_service.dart';
import 'package:tindahan_natin/features/auth/auth_service.dart';
import 'package:tindahan_natin/features/dashboard/store.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.store_outlined),
            title: const Text('Store Settings'),
            subtitle: const Text('Manage your store name and account'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const StoreSettingsScreen()),
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: const Text('Privacy Policy'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen()),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.description_outlined),
            title: const Text('Terms and Conditions'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const TermsAndConditionsScreen()),
            ),
          ),
          const Divider(),
          const InlineAdWidget(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: Consumer(
              builder: (context, ref, child) {
                return ref.watch(packageInfoProvider).when(
                      data: (info) => Text(
                        'Version ${info.version} (${info.buildNumber})',
                        style: Theme.of(context).textTheme.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                      loading: () => const SizedBox.shrink(),
                      error: (_, stack) => const SizedBox.shrink(),
                    );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class StoreSettingsScreen extends ConsumerStatefulWidget {
  const StoreSettingsScreen({super.key});

  @override
  ConsumerState<StoreSettingsScreen> createState() => _StoreSettingsScreenState();
}

class _StoreSettingsScreenState extends ConsumerState<StoreSettingsScreen> {
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
        title: const Text('Store Settings'),
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
          : LayoutBuilder(
              builder: (context, constraints) => SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Padding(
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
                                        await ref.read(authStateProvider.notifier).logout();
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
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Log out'),
                            ),
                            const SizedBox(height: 24),
                            const Spacer(),
                            const SizedBox(height: 16),
                            // ref.watch(packageInfoProvider).when(
                            //       data: (info) => Text(
                            //         'Version ${info.version} (${info.buildNumber})',
                            //         style: Theme.of(context).textTheme.bodySmall,
                            //         textAlign: TextAlign.center,
                            //       ),
                            //       loading: () => const SizedBox.shrink(),
                            //       error: (_, stack) => const SizedBox.shrink(),
                            //     ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final titleStyle = Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold);

    return Scaffold(
      appBar: AppBar(title: const Text('Privacy Policy')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text('Privacy Policy', style: titleStyle),
            const Text('Last updated: May 20, 2026', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 24),
            _buildSection(
              context,
              '1. Information We Collect',
              'Tindahan Natin collects information to provide store management services. This includes:\n\n'
                  '• Account Information: We use Auth0 to manage authentication. This includes your name, email, and profile picture provided by your chosen login provider.\n'
                  '• Store Data: Details about your sari-sari store, including store name, product names, pricing, inventory levels, and categories.\n'
                  '• Organizational Data: Visual layouts of your shelves and the specific placement of products within your store.\n'
                  '• Media: Images of products you choose to upload to our storage service. These are collected to display within the app and on your coordination storefronts.\n'
                  '• Device Features (Camera & Gallery): We access your device\'s camera to scan barcodes and to take product photos. We access your photo gallery only when you choose to select an existing product image. Camera frames used for barcode scanning are processed ephemerally on your device and are not stored. Product photos you capture or select are uploaded to our secure storage.\n'
                  '• Local Data: We use Hive to store a copy of your data on your device for offline use and faster performance.\n\n'
                  'Note: We do NOT collect GPS coordinates or precise location data from your device.',
            ),
            _buildSection(
              context,
              '2. How We Use Information',
              'We use the information we collect to:\n\n'
                  '• Authenticate your identity and secure your account.\n'
                  '• Provide and maintain our inventory, barcode scanning, and shelf-mapping features.\n'
                  '• Automatically populate product details by querying third-party APIs (such as Open Food Facts, Open Beauty Facts, and others) when you scan a barcode.\n'
                  '• Synchronize your data between your device and our servers when you are online.\n'
                  '• Generate internal storefronts for coordination with your family and staff.\n'
                  '• Display relevant advertisements via Google Mobile Ads.',
            ),
            _buildSection(
              context,
              '3. Third-Party Services',
              'We integrate with the following third-party services which may collect data according to their own privacy policies:\n\n'
                  '• Auth0: Used for secure authentication and account management.\n'
                  '• Product Databases: We query open databases including Open Food Facts, Open Beauty Facts, and Open Products Facts to retrieve product information based on scanned barcodes.\n'
                  '• Google APIs: We use the Google Books API to retrieve book information for ISBN barcodes.\n'
                  '• Google Mobile Ads (AdMob): Used to display advertisements within the application. AdMob may use device identifiers to personalize ads.',
            ),
            _buildSection(
              context,
              '4. Data Synchronization',
              'The app is designed to work offline. Any changes you make while offline are stored locally on your device and will be automatically synchronized with our servers once an active internet connection is detected.',
            ),
            _buildSection(
              context,
              '5. Data Security',
              'We implement industry-standard security measures to protect your data. Communication between the app and our servers is encrypted using HTTPS. Account security is managed through Auth0\'s robust identity platform.',
            ),
            _buildSection(
              context,
              '6. Contact Us',
              'If you have any questions about this Privacy Policy, please contact us at support@aebibtech.com.',
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(content, style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.5)),
        ],
      ),
    );
  }
}

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final titleStyle = Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold);

    return Scaffold(
      appBar: AppBar(title: const Text('Terms and Conditions')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text('Terms and Conditions', style: titleStyle),
            const Text('Last updated: May 20, 2026', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 24),
            _buildSection(
              context,
              '1. Agreement to Terms',
              'By accessing or using Tindahan Natin, you agree to be bound by these Terms and Conditions. Our service is designed to help sari-sari store owners manage their inventory and store layout.',
            ),
            _buildSection(
              context,
              '2. Description of Service',
              'Tindahan Natin provides a digital companion for sari-sari store management. Key features include:\n\n'
                  '• Inventory Management: Tracking products, prices, and stock levels.\n'
                  '• Barcode Scanning & Photo Management: Using your device camera to identify products and capture or select product images for your inventory.\n'
                  '• Visual Store Map: Designing and organizing shelf layouts.\n'
                  '• Offline Support: Local data persistence and automatic background synchronization.\n'
                  '• Internal Coordination: Generation of storefront links for family members, tinderos, and tinderas to view store data.',
            ),
            _buildSection(
              context,
              '3. User Accounts',
              'Registration is required to use most features. We use Auth0 for secure account management. You are responsible for all activity that occurs under your account and for maintaining the confidentiality of your credentials.',
            ),
            _buildSection(
              context,
              '4. Advertisements',
              'Tindahan Natin includes advertisements provided by Google Mobile Ads (AdMob). By using the service, you agree to the display of these advertisements within the app interface.',
            ),
            _buildSection(
              context,
              '5. Data and Content',
              'You retain ownership of the store data and images you upload. However, you grant Tindahan Natin a license to store, synchronize, and display this content to you and your authorized coordination partners (family/staff) as part of the service.',
            ),
            _buildSection(
              context,
              '6. Offline Use and Sync',
              'The app provides offline functionality. While we strive to ensure data integrity during synchronization, we are not responsible for data loss or conflicts arising from simultaneous updates across multiple devices while offline.',
            ),
            _buildSection(
              context,
              '7. Limitation of Liability',
              'Tindahan Natin is provided "as is". In no event shall we be liable for any indirect, incidental, or consequential damages resulting from the use or inability to use the service, including inventory inaccuracies or data synchronization errors.',
            ),
            _buildSection(
              context,
              '8. Contact Us',
              'If you have any questions about these Terms and Conditions, please contact us at support@aebibtech.com.',
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(content, style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.5)),
        ],
      ),
    );
  }
}
