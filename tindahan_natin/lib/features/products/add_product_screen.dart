// ignore_for_file: use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tindahan_natin/shared/utils/snackbar_utils.dart';
import 'package:tindahan_natin/shared/widgets/custom_image_picker.dart';
import 'package:tindahan_natin/features/products/product_service.dart';
import 'package:tindahan_natin/features/categories/category_service.dart';
import 'package:tindahan_natin/features/settings/store_service.dart';
import 'package:tindahan_natin/core/network/dio_client.dart';
import 'package:tindahan_natin/features/store_map/map_service.dart';
import 'package:tindahan_natin/features/store_map/visual_shelf_selector.dart';
import 'package:tindahan_natin/shared/widgets/barcode_scanner_dialog.dart';

class AddProductScreen extends ConsumerStatefulWidget {
  const AddProductScreen({super.key});

  @override
  ConsumerState<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends ConsumerState<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _quantityController = TextEditingController();
  final _minStockThresholdController = TextEditingController(text: '5');
  final _barcodeController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? _imageUrl;
  bool _isUploading = false;
  bool _isLookingUp = false;
  String? _selectedCategoryId;
  String? _selectedShelfId;

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    _minStockThresholdController.dispose();
    _barcodeController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _scanBarcode() async {
    final barcode = await showDialog<String>(
      context: context,
      builder: (context) => const BarcodeScannerDialog(),
    );

    if (barcode != null && barcode.isNotEmpty) {
      setState(() {
        _barcodeController.text = barcode;
        _isLookingUp = true;
      });

      try {
        final info = await ref
            .read(productServiceProvider)
            .lookupProductByBarcode(barcode);
        if (info != null) {
          if (_nameController.text.isEmpty) {
            _nameController.text = info['name'] ?? '';
          }
          if (_descriptionController.text.isEmpty) {
            _descriptionController.text = info['description'] ?? '';
          }
          if (_imageUrl == null || _imageUrl!.isEmpty) {
            _imageUrl = info['imageUrl'];
          }
        }
      } catch (e) {
        debugPrint('Lookup failed: $e');
      } finally {
        if (mounted) setState(() => _isLookingUp = false);
      }
    }
  }

  Future<void> _pickImage() async {
    final XFile? result;
    if (kIsWeb) {
      result = await ImagePicker().pickImage(source: ImageSource.gallery);
    } else {
      result = await Navigator.push<XFile>(
        context,
        MaterialPageRoute(
          builder: (context) => const CustomImagePicker(),
          fullscreenDialog: true,
        ),
      );
    }

    if (result != null) {
      setState(() {
        _isUploading = true;
      });

      try {
        final url = await ref.read(productServiceProvider).uploadImage(result);
        setState(() {
          _imageUrl = url;
          _isUploading = false;
        });
      } catch (e) {
        setState(() => _isUploading = false);
        if (mounted) {
          SnackBarUtils.showError(context, e);
        }
      }
    }
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      final myStore = await ref.read(myStoreProvider.future);
      final storeId = myStore?.id ?? '';
      debugPrint('Store ID: $storeId');
      if (_selectedCategoryId == null || _selectedCategoryId!.isEmpty) {
        if (mounted) {
          SnackBarUtils.showError(context, 'Please select a category');
        }
        return;
      }

      final data = {
        'name': _nameController.text,
        'price': double.parse(_priceController.text),
        'quantity': int.parse(_quantityController.text),
        'minStockThreshold': int.parse(_minStockThresholdController.text),
        'categoryId': _selectedCategoryId,
        'storeId': storeId,
        'imageUrl': _imageUrl,
        'barcode': _barcodeController.text,
        'description': _descriptionController.text,
      };
      if (_selectedShelfId != null && _selectedShelfId!.isNotEmpty) {
        data['shelfId'] = _selectedShelfId;
      }

      try {
        await ref.read(productsProvider(storeId).notifier).addProduct(data);
        if (mounted) {
          context.pop();
          SnackBarUtils.showSuccess(context, 'Product added successfully');
        }
      } catch (e) {
        if (mounted) {
          SnackBarUtils.showError(context, e);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final myStoreAsync = ref.watch(myStoreProvider);

    return myStoreAsync.when(
      data: (store) {
        if (store == null) {
          return const Scaffold(body: Center(child: Text('No store found')));
        }
        final storeId = store.id;
        final categoriesAsync = ref.watch(categoriesProvider(storeId));

        return Scaffold(
          appBar: AppBar(
            title: const Text('Add Product'),
            actions: [
              IconButton(
                onPressed: _isUploading ? null : _submit,
                icon: const Icon(Icons.check),
                tooltip: 'Save Product',
              ),
            ],
          ),
          body: SingleChildScrollView(
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
                                _imageUrl!.startsWith('http')
                                    ? _imageUrl!
                                    : '${ref.read(apiBaseUrlProvider)}$_imageUrl',
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
                    controller: _barcodeController,
                    decoration: InputDecoration(
                      labelText: 'Barcode',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.qr_code_scanner),
                        onPressed: _scanBarcode,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (_isLookingUp)
                    const Padding(
                      padding: EdgeInsets.only(bottom: 16.0),
                      child: LinearProgressIndicator(),
                    ),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Product Name *',
                    ),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Please enter a name'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Description (optional)',
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _priceController,
                    decoration: const InputDecoration(labelText: 'Price *'),
                    keyboardType: TextInputType.number,
                    validator: (value) => value == null || value.isEmpty
                        ? 'Please enter a price'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _quantityController,
                    decoration: const InputDecoration(labelText: 'Quantity *'),
                    keyboardType: TextInputType.number,
                    validator: (value) => value == null || value.isEmpty
                        ? 'Please enter quantity'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _minStockThresholdController,
                    decoration: const InputDecoration(
                      labelText: 'Low Stock Alert Threshold',
                      helperText: 'Alert me when stock reaches this level',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) => value == null || value.isEmpty
                        ? 'Please enter alert threshold'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  categoriesAsync.when(
                    data: (categories) {
                      if (categories.isNotEmpty) {
                        _selectedCategoryId ??= categories.first.id;
                      }
                      return Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              initialValue: _selectedCategoryId,
                              decoration: const InputDecoration(
                                labelText: 'Category *',
                              ),
                              items: categories
                                  .map(
                                    (c) => DropdownMenuItem(
                                      value: c.id,
                                      child: Text(c.name),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (v) =>
                                  setState(() => _selectedCategoryId = v),
                              validator: (v) => v == null || v.isEmpty
                                  ? 'Please select a category'
                                  : null,
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
                                  content: TextField(
                                    controller: nameController,
                                    decoration: const InputDecoration(
                                      labelText: 'Name',
                                    ),
                                  ),
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () => Navigator.of(
                                        ctx,
                                      ).pop(nameController.text),
                                      child: const Text('Save'),
                                    ),
                                  ],
                                ),
                              );

                              if (result != null && result.trim().isNotEmpty) {
                                try {
                                  final created = await ref
                                      .read(categoryServiceProvider)
                                      .createCategory(result.trim(), storeId);
                                  // refresh the categories provider and select the new one
                                  ref.invalidate(categoriesProvider(storeId));
                                  setState(
                                    () => _selectedCategoryId = created.id,
                                  );
                                  if (mounted) {
                                    SnackBarUtils.showSuccess(context, 'Category created');
                                  }
                                } catch (e) {
                                  if (mounted) {
                                    SnackBarUtils.showError(context, e);
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
                  const SizedBox(height: 16),
                  Builder(
                    builder: (ctx) {
                      final shelvesAsync = ref.watch(shelvesProvider(storeId));
                      return shelvesAsync.when(
                        data: (shelves) {
                          final selectedShelf = shelves
                              .where((s) => s.id == _selectedShelfId)
                              .firstOrNull;
                          return InkWell(
                            onTap: () async {
                              final result = await Navigator.push<String>(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => VisualShelfSelector(
                                    storeId: storeId,
                                    initialShelfId: _selectedShelfId,
                                  ),
                                  fullscreenDialog: true,
                                ),
                              );
                              if (result != null) {
                                setState(
                                  () =>
                                      _selectedShelfId =
                                          (result == '' ? null : result),
                                );
                              }
                            },
                            child: InputDecorator(
                              decoration: const InputDecoration(
                                labelText: 'Shelf (optional)',
                                prefixIcon: Icon(Icons.map),
                                suffixIcon: Icon(Icons.arrow_drop_down),
                              ),
                              child: Text(
                                selectedShelf?.name ?? 'Unassigned',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
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
                    },
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _isUploading ? null : _submit,
                      child: _isUploading
                          ? const CircularProgressIndicator()
                          : const Text(
                              'Save Product',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        );
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, s) =>
          Scaffold(body: Center(child: Text('Error loading store: $e'))),
    );
  }
}
