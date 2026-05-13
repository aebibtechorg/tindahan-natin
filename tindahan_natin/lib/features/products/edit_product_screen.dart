import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tindahan_natin/features/products/product_service.dart';
import 'package:tindahan_natin/features/categories/category_service.dart';
import 'package:tindahan_natin/features/settings/store_service.dart';
import 'package:tindahan_natin/core/network/dio_client.dart';
import 'package:tindahan_natin/features/store_map/map_service.dart';

class EditProductScreen extends ConsumerStatefulWidget {
  final String id;
  const EditProductScreen({super.key, required this.id});

  @override
  ConsumerState<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends ConsumerState<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _quantityController = TextEditingController();
  String? _imageUrl;
  bool _isUploading = false;
  String? _selectedCategoryId;
  String? _selectedShelfId;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadProduct();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  Future<void> _loadProduct() async {
    try {
      final product = await ref.read(productServiceProvider).getProduct(widget.id);
      _nameController.text = product.name;
      _priceController.text = product.price.toString();
      _quantityController.text = product.quantity.toString();
      _imageUrl = product.imageUrl;
      _selectedCategoryId = product.categoryId;
      _selectedShelfId = product.shelfId ?? '';
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to load product: $e')));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _isUploading = true;
      });

      try {
        final url = await ref.read(productServiceProvider).uploadImage(image);
        setState(() {
          _imageUrl = url;
          _isUploading = false;
        });
      } catch (e) {
        setState(() => _isUploading = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Upload failed: $e')),
          );
        }
      }
    }
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      final myStore = await ref.read(myStoreProvider.future);
      final storeId = myStore?.id ?? '';
      if (_selectedCategoryId == null || _selectedCategoryId!.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select a category')));
        }
        return;
      }

      final data = {
        'name': _nameController.text,
        'price': double.parse(_priceController.text),
        'quantity': int.parse(_quantityController.text),
        'categoryId': _selectedCategoryId,
        'storeId': storeId,
        'imageUrl': _imageUrl,
      };
      if (_selectedShelfId != null && _selectedShelfId!.isNotEmpty) {
        data['shelfId'] = _selectedShelfId;
      }

      try {
        await ref.read(productsProvider(storeId).notifier).updateProduct(widget.id, data);
        if (mounted) context.pop();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
        }
      }
    }
  }

  Future<void> _delete() async {
    final confirm = await showDialog<bool?>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete product?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancel')),
          ElevatedButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Delete')),
        ],
      ),
    );

    if (confirm != true) return;

    final myStore = await ref.read(myStoreProvider.future);
    final storeId = myStore?.id ?? '';
    try {
      await ref.read(productsProvider(storeId).notifier).deleteProduct(widget.id);
      if (mounted) context.pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to delete: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final myStoreAsync = ref.watch(myStoreProvider);

    return myStoreAsync.when(
      data: (store) {
        if (store == null) return const Scaffold(body: Center(child: Text('No store found')));
        final storeId = store.id;
        final categoriesAsync = ref.watch(categoriesProvider(storeId));

        return Scaffold(
          appBar: AppBar(
            title: const Text('Edit Product'),
            actions: [
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: _delete,
              ),
            ],
          ),
          body: _loading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            height: 200,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: _imageUrl != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      '${ref.read(apiBaseUrlProvider)}${_imageUrl}',
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : _isUploading
                                    ? const Center(child: CircularProgressIndicator())
                                    : const Center(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.add_a_photo, size: 50),
                                            Text('Add Product Image'),
                                          ],
                                        ),
                                      ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(labelText: 'Product Name'),
                          validator: (value) => value == null || value.isEmpty ? 'Please enter a name' : null,
                        ),
                        TextFormField(
                          controller: _priceController,
                          decoration: const InputDecoration(labelText: 'Price'),
                          keyboardType: TextInputType.number,
                          validator: (value) => value == null || value.isEmpty ? 'Please enter a price' : null,
                        ),
                        TextFormField(
                          controller: _quantityController,
                          decoration: const InputDecoration(labelText: 'Quantity'),
                          keyboardType: TextInputType.number,
                          validator: (value) => value == null || value.isEmpty ? 'Please enter quantity' : null,
                        ),
                        const SizedBox(height: 12),
                        categoriesAsync.when(
                          data: (categories) {
                            if (categories.isNotEmpty) {
                              _selectedCategoryId ??= categories.first.id;
                            }
                            return Row(
                              children: [
                                Expanded(
                                  child: DropdownButtonFormField<String>(
                                    value: _selectedCategoryId,
                                    decoration: const InputDecoration(labelText: 'Category'),
                                    items: categories.map((c) => DropdownMenuItem(value: c.id, child: Text(c.name))).toList(),
                                    onChanged: (v) => setState(() => _selectedCategoryId = v),
                                    validator: (v) => v == null || v.isEmpty ? 'Please select a category' : null,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                IconButton(
                                  icon: const Icon(Icons.add),
                                  tooltip: 'Add category',
                                  onPressed: () async {
                                    final nameController = TextEditingController();
                                    final result = await showDialog<String?>(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        title: const Text('Add Category'),
                                        content: TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Name')),
                                        actions: [
                                          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
                                          ElevatedButton(onPressed: () => Navigator.of(ctx).pop(nameController.text), child: const Text('Save')),
                                        ],
                                      ),
                                    );

                                    if (result != null && result.trim().isNotEmpty) {
                                      try {
                                        final created = await ref.read(categoryServiceProvider).createCategory(result.trim(), storeId);
                                        ref.invalidate(categoriesProvider(storeId));
                                        setState(() => _selectedCategoryId = created.id);
                                      } catch (e) {
                                        if (mounted) {
                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to create category: $e')));
                                        }
                                      }
                                    }
                                  },
                                ),
                              ],
                            );
                          },
                          loading: () => const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: Center(child: CircularProgressIndicator()),
                          ),
                          error: (e, s) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text('Failed to load categories: $e'),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Builder(builder: (ctx) {
                          final shelvesAsync = ref.watch(shelvesProvider(storeId));
                          return shelvesAsync.when(
                            data: (shelves) {
                              return DropdownButtonFormField<String>(
                                value: _selectedShelfId ?? '',
                                decoration: const InputDecoration(labelText: 'Shelf (optional)'),
                                items: [
                                  const DropdownMenuItem(value: '', child: Text('Unassigned')),
                                  ...shelves.map((s) => DropdownMenuItem(value: s.id, child: Text(s.name)))
                                ],
                                onChanged: (v) => setState(() => _selectedShelfId = (v == '' ? null : v)),
                              );
                            },
                            loading: () => const Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              child: Center(child: CircularProgressIndicator()),
                            ),
                            error: (e, s) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text('Failed to load shelves: $e'),
                            ),
                          );
                        }),
                        const SizedBox(height: 40),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(onPressed: _isUploading ? null : _submit, child: const Text('Save Product')),
                        ),
                      ],
                    ),
                  ),
                ),
        );
      },
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, s) => Scaffold(body: Center(child: Text('Error loading store: $e'))),
    );
  }
}
