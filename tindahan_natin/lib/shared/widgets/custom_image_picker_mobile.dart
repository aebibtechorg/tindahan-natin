import 'dart:io';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class CustomImagePicker extends StatefulWidget {
  const CustomImagePicker({super.key});

  @override
  State<CustomImagePicker> createState() => _CustomImagePickerState();
}

class _CustomImagePickerState extends State<CustomImagePicker>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<AssetEntity> _assets = [];
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isCameraInitialized = false;
  bool _hasGalleryPermission = false;
  bool _isLoadingAssets = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _initializeGallery();
    _initializeCamera();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _initializeGallery() async {
    final PermissionState ps = await PhotoManager.requestPermissionExtend();
    if (ps.isAuth || ps == PermissionState.limited) {
      setState(() => _hasGalleryPermission = true);
      _loadAssets();
    } else {
      setState(() => _hasGalleryPermission = false);
    }
  }

  Future<void> _loadAssets() async {
    setState(() => _isLoadingAssets = true);
    final List<AssetPathEntity> paths = await PhotoManager.getAssetPathList(
      type: RequestType.image,
    );
    if (paths.isNotEmpty) {
      final List<AssetEntity> assets = await paths[0].getAssetListPaged(
        page: 0,
        size: 100,
      );
      setState(() {
        _assets = assets;
        _isLoadingAssets = false;
      });
    } else {
      setState(() => _isLoadingAssets = false);
    }
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras != null && _cameras!.isNotEmpty) {
        _cameraController = CameraController(
          _cameras![0],
          ResolutionPreset.medium,
          enableAudio: false,
        );
        await _cameraController!.initialize();
        if (mounted) {
          setState(() => _isCameraInitialized = true);
        }
      }
    } catch (e) {
      debugPrint('Camera initialization failed: $e');
    }
  }

  Future<void> _takePhoto() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    try {
      final XFile photo = await _cameraController!.takePicture();
      if (mounted) {
        Navigator.pop(context, photo);
      }
    } catch (e) {
      debugPrint('Taking photo failed: $e');
    }
  }

  Future<void> _selectAsset(AssetEntity asset) async {
    final File? file = await asset.file;
    if (file != null && mounted) {
      Navigator.pop(context, XFile(file.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Image'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.photo_library), text: 'Gallery'),
            Tab(icon: Icon(Icons.camera_alt), text: 'Camera'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildGalleryTab(),
          _buildCameraTab(),
        ],
      ),
    );
  }

  Widget _buildGalleryTab() {
    if (!_hasGalleryPermission) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.photo_library, size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              const Text(
                'Permission to access gallery is required to select existing photos.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _initializeGallery,
                child: const Text('Allow Access'),
              ),
              TextButton(
                onPressed: () => PhotoManager.openSetting(),
                child: const Text('Open Settings'),
              ),
            ],
          ),
        ),
      );
    }

    if (_isLoadingAssets) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_assets.isEmpty) {
      return const Center(child: Text('No images found.'));
    }

    return GridView.builder(
      padding: const EdgeInsets.all(2),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
      ),
      itemCount: _assets.length,
      itemBuilder: (context, index) {
        final asset = _assets[index];
        return GestureDetector(
          onTap: () => _selectAsset(asset),
          child: AssetThumbnail(asset: asset),
        );
      },
    );
  }

  Widget _buildCameraTab() {
    if (!_isCameraInitialized || _cameraController == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Stack(
      children: [
        // Camera Preview filling the entire space
        SizedBox.expand(
          child: FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: _cameraController!.value.previewSize?.height ?? 1,
              height: _cameraController!.value.previewSize?.width ?? 1,
              child: CameraPreview(_cameraController!),
            ),
          ),
        ),
        // Floating Capture Button
        Positioned(
          bottom: 48,
          left: 0,
          right: 0,
          child: Center(
            child: GestureDetector(
              onTap: _takePhoto,
              child: Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 4),
                ),
                child: Container(
                  margin: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    color: Colors.black,
                    size: 32,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class AssetThumbnail extends StatelessWidget {
  const AssetThumbnail({
    super.key,
    required this.asset,
  });

  final AssetEntity asset;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List?>(
      future: asset.thumbnailData,
      builder: (_, snapshot) {
        final bytes = snapshot.data;
        if (bytes == null) return const Center(child: CircularProgressIndicator());
        return Image.memory(bytes, fit: BoxFit.cover);
      },
    );
  }
}
