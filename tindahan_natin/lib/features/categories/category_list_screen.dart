// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tindahan_natin/core/widgets/app_error_widget.dart';
import 'package:tindahan_natin/core/widgets/inline_ad_widget.dart';
import 'package:tindahan_natin/shared/utils/snackbar_utils.dart';
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
                    _debounce?.cancel();
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

              return RefreshIndicator(
                onRefresh: () => ref.read(categoriesProvider(storeId).notifier).refresh(),
                child: Builder(builder: (context) {
                  if (categories.isEmpty) return const Center(child: Text('No categories yet.'));

                  const adInterval = 10;
                  final itemCount = categories.length + (categories.length / adInterval).floor();

                  return ListView.builder(
                    itemCount: itemCount,
                    itemBuilder: (context, index) {
                      final isAd = (index + 1) % (adInterval + 1) == 0;
                      if (isAd) {
                        return const Column(
                          children: [
                            InlineAdWidget(),
                            Divider(),
                          ],
                        );
                      }

                      final categoryIndex = index - (index / (adInterval + 1)).floor();
                      final c = categories[categoryIndex];
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
                                  await ref.read(categoriesProvider(storeId).notifier).updateCategory(c.id, result.trim());
                                  if (mounted) SnackBarUtils.showSuccess(context, 'Category updated');
                                } catch (e) {
                                  if (mounted) SnackBarUtils.showError(context, e);
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
                                  await ref.read(categoriesProvider(storeId).notifier).deleteCategory(c.id);
                                  if (mounted) SnackBarUtils.showSuccess(context, 'Category deleted');
                                } catch (e) {
                                  if (mounted) SnackBarUtils.showError(context, e);
                                }
                              }
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              }),
            );
          },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, s) => AppErrorWidget(
              error: e,
              stackTrace: s,
              onRetry: () => ref.read(categoriesProvider(storeId).notifier).refresh(),
            ),
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
                  await ref.read(categoriesProvider(storeId).notifier).addCategory(result.trim());
                  if (mounted) SnackBarUtils.showSuccess(context, 'Category created');
                } catch (e) {
                  if (mounted) SnackBarUtils.showError(context, e);
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
