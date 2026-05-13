import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tindahan_natin/features/categories/category_service.dart';
import 'package:tindahan_natin/features/settings/store_service.dart';

class CategoryListScreen extends ConsumerWidget {
  const CategoryListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myStoreAsync = ref.watch(myStoreProvider);

    return myStoreAsync.when(
      data: (store) {
        if (store == null) return const Scaffold(body: Center(child: Text('No store found')));
        final storeId = store.id;
        final categoriesAsync = ref.watch(categoriesProvider(storeId));

        return Scaffold(
          appBar: AppBar(title: const Text('Categories')),
          body: categoriesAsync.when(
            data: (categories) {
              if (categories.isEmpty) return const Center(child: Text('No categories yet.'));
              return ListView.separated(
                itemCount: categories.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final c = categories[index];
                  return ListTile(
                    leading: const Icon(Icons.label),
                    title: Text(c.name),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () async {
                            final controller = TextEditingController(text: c.name);
                            final result = await showDialog<String?>(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text('Edit Category'),
                                content: TextField(controller: controller, decoration: const InputDecoration(labelText: 'Name')),
                                actions: [
                                  TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
                                  ElevatedButton(onPressed: () => Navigator.of(ctx).pop(controller.text), child: const Text('Save')),
                                ],
                              ),
                            );
                            if (result != null && result.trim().isNotEmpty) {
                              try {
                                await ref.read(categoryServiceProvider).updateCategory(c.id, result.trim());
                                ref.invalidate(categoriesProvider(storeId));
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Category updated')));
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update: $e')));
                              }
                            }
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () async {
                            final confirmed = await showDialog<bool?>(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text('Delete Category'),
                                content: Text('Delete category "${c.name}"? This cannot be undone.'),
                                actions: [
                                  TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancel')),
                                  ElevatedButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Delete')),
                                ],
                              ),
                            );
                            if (confirmed == true) {
                              try {
                                await ref.read(categoryServiceProvider).deleteCategory(c.id);
                                ref.invalidate(categoriesProvider(storeId));
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Category deleted')));
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to delete: $e')));
                              }
                            }
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, s) => Center(child: Text('Error loading categories: $e')),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              final controller = TextEditingController();
              final result = await showDialog<String?>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Add Category'),
                  content: TextField(controller: controller, decoration: const InputDecoration(labelText: 'Name')),
                  actions: [
                    TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
                    ElevatedButton(onPressed: () => Navigator.of(ctx).pop(controller.text), child: const Text('Save')),
                  ],
                ),
              );
              if (result != null && result.trim().isNotEmpty) {
                try {
                  await ref.read(categoryServiceProvider).createCategory(result.trim(), storeId);
                  ref.invalidate(categoriesProvider(storeId));
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Category created')));
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to create: $e')));
                }
              }
            },
            child: const Icon(Icons.add),
          ),
        );
      },
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, s) => Scaffold(body: Center(child: Text('Error loading store: $e'))),
    );
  }
}
