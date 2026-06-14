// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tindahan_natin/core/widgets/app_error_widget.dart';
import 'package:tindahan_natin/core/widgets/inline_ad_widget.dart';
import 'package:tindahan_natin/shared/utils/snackbar_utils.dart';
import 'package:tindahan_natin/features/categories/category.dart';
import 'package:tindahan_natin/features/categories/category_service.dart';
import 'package:tindahan_natin/features/settings/store_service.dart';
import 'package:tindahan_natin/shared/widgets/empty_state_widget.dart';

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
              if (categories.isEmpty) {
                return EmptyStateWidget(
                  icon: Icons.category_outlined,
                  title: 'No Categories Yet',
                  description: 'Create categories to organize and manage your products easily.',
                  actionLabel: 'Add Category',
                  onActionPressed: () => _showAddCategoryDialog(storeId),
                );
              }

              return RefreshIndicator(
                onRefresh: () => ref.read(categoriesProvider(storeId).notifier).refresh(),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final isWide = constraints.maxWidth > 700;
                    
                    const adInterval = 10;
                    final itemCount = categories.length + (categories.length / adInterval).floor();

                    if (isWide) {
                      final slivers = <Widget>[];
                      for (int i = 0; i < categories.length; i += adInterval) {
                        final chunk = categories.sublist(
                          i,
                          i + adInterval > categories.length ? categories.length : i + adInterval,
                        );
                        slivers.add(
                          SliverPadding(
                            padding: const EdgeInsets.all(8),
                            sliver: SliverGrid(
                              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 400,
                                mainAxisExtent: 72,
                                mainAxisSpacing: 8,
                                crossAxisSpacing: 8,
                              ),
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  final c = chunk[index];
                                  return Card(
                                    margin: EdgeInsets.zero,
                                    child: _CategoryTile(
                                      category: c,
                                      storeId: storeId,
                                    ),
                                  );
                                },
                                childCount: chunk.length,
                              ),
                            ),
                          ),
                        );
                        if (i + adInterval < categories.length) {
                          slivers.add(
                            const SliverToBoxAdapter(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.0),
                                child: InlineAdWidget(),
                              ),
                            ),
                          );
                        }
                      }
                      return CustomScrollView(slivers: slivers);
                    }

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
                        return Card(
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          child: _CategoryTile(
                            category: c,
                            storeId: storeId,
                          ),
                        );
                      },
                    );
                  },
                ),
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
            onPressed: () => _showAddCategoryDialog(storeId),
            child: const Icon(Icons.add),
          ),
        );
      },
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, s) => Scaffold(
        body: AppErrorWidget(
          error: e,
          stackTrace: s,
          onRetry: () => ref.invalidate(myStoreProvider),
        ),
      ),
    );
  }

  Future<void> _showAddCategoryDialog(String storeId) async {
    final controller = TextEditingController();
    final result = await showDialog<String?>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Category'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Name'),
          autofocus: true,
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(controller.text),
            child: const Text('Save'),
          ),
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
  }
}

class _CategoryTile extends ConsumerWidget {
  final Category category;
  final String storeId;

  const _CategoryTile({required this.category, required this.storeId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          Icons.label_outlined,
          color: Theme.of(context).colorScheme.primary,
          size: 20,
        ),
      ),
      title: Text(
        category.name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final controller = TextEditingController(text: category.name);
              final result = await showDialog<String?>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Edit Category'),
                  content: TextField(
                    controller: controller,
                    decoration: const InputDecoration(labelText: 'Name'),
                    autofocus: true,
                  ),
                  actions: [
                    // TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                    ElevatedButton(onPressed: () => Navigator.of(ctx).pop(controller.text), child: const Text('Save')),
                  ],
                ),
              );
              if (result != null && result.trim().isNotEmpty) {
                try {
                  await ref.read(categoriesProvider(storeId).notifier).updateCategory(category.id, result.trim());
                  if (context.mounted) SnackBarUtils.showSuccess(context, 'Category updated');
                } catch (e) {
                  if (context.mounted) SnackBarUtils.showError(context, e);
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
                  content: Text('Delete category "${category.name}"? This cannot be undone.'),
                  actions: [
                    // TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.error,
                        foregroundColor: Theme.of(context).colorScheme.onError,
                      ),
                      onPressed: () => Navigator.of(ctx).pop(true),
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              );
              if (confirmed == true) {
                try {
                  await ref.read(categoriesProvider(storeId).notifier).deleteCategory(category.id);
                  if (context.mounted) SnackBarUtils.showSuccess(context, 'Category deleted');
                } catch (e) {
                  if (context.mounted) SnackBarUtils.showError(context, e);
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
