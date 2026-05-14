import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tindahan_natin/features/settings/store_service.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            const Icon(Icons.store, size: 100, color: Colors.blue)
                .animate()
                .scale(duration: 600.ms, curve: Curves.easeOutBack)
                .fadeIn(),
            const SizedBox(height: 20),
            const Text(
              'Welcome, Store Owner!',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.3),
            const SizedBox(height: 10),
            const Text(
              'Manage your sari-sari store with ease.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ).animate().fadeIn(delay: 400.ms),
            const SizedBox(height: 50),
            _buildMenuCard(
              context,
              title: 'Products',
              subtitle: 'Add, edit, and track products',
              icon: Icons.inventory_2_outlined,
              color: Colors.blue,
              onTap: () => context.push('/inventory'),
            ).animate().fadeIn(delay: 600.ms).slideX(begin: -0.1),
            const SizedBox(height: 16),
            _buildMenuCard(
              context,
              title: 'Store Map',
              subtitle: 'Organize shelves visually',
              icon: Icons.map_outlined,
              color: Colors.orange,
              onTap: () => context.push('/map'),
            ).animate().fadeIn(delay: 800.ms).slideX(begin: 0.1),
            const SizedBox(height: 16),
            _buildMenuCard(
              context,
              title: 'Product Search',
              subtitle: 'Quickly find products in your store',
              icon: Icons.search_outlined,
              color: Colors.green,
              onTap: () async {
                final myStore = await ref.read(myStoreProvider.future);
                if (myStore == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('No store available')),
                  );
                  return;
                }
                context.push('/store/${myStore.slug}');
              },
            ).animate().fadeIn(delay: 1000.ms).slideY(begin: 0.1),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 30),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }
}