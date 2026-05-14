import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tindahan_natin/features/categories/category_service.dart';
import 'package:tindahan_natin/features/settings/store_service.dart';

class CategoryListScreen extends ConsumerStatefulWidget {
  const CategoryListScreen({super.key});

  @override
  ConsumerState<CategoryListScreen> createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends ConsumerState<CategoryListScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  String _query = '';
  bool _isSearching = false;

  void _onSearchChanged(String value) {
    // update UI immediately (e.g. clear icon visibility)
    setState(() {});
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      setState(() {
        _query = value.trim();
      });
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final myStoreAsync = ref.watch(myStoreProvider);

    return myStoreAsync.when(
      data: (store) {
        if (store == null) return const Scaffold(body: Center(child: Text('No store found')));
        final storeId = store.id;
        final categoriesAsync = ref.watch(categoriesProvider(storeId));
        final displayAsync = _query.isEmpty ? categoriesAsync : ref.watch(categorySearchProvider('$storeId::$_query'));

        return Scaffold(
          appBar: AppBar(
            title: _isSearching
                ? TextField(
                    controller: _searchController,
                    onChanged: _onSearchChanged,
                    decoration: InputDecoration(
                      hintText: 'Search categories',
                      border: InputBorder.none,
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                _onSearchChanged('');
                                setState(() {
                                  _query = '';
                                });
                              },
                            )
                          : null,
                    ),
                  )
                : const Text('Categories'),
            actions: [
              IconButton(
                icon: Icon(_isSearching ? Icons.close : Icons.search),
                onPressed: () => setState(() {
                  if (_isSearching) {
                    _isSearching = false;
                    _searchController.clear();
                    _query = '';
                  } else {
                    _isSearching = true;
                  }
                }),
              ),
            ],
          ),
          body: displayAsync.when(
            data: (categories) {
              if (categories.isEmpty) return const Center(child: Text('No categories yet.'));
              return ListView.separated(
                itemCount: categories.length,
                separatorBuilder: (_, __) => const SizedBox.shrink(),
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
