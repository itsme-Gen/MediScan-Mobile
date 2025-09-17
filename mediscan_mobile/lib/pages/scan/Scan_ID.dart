// lib/pages/scan/scan_id.dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../dashboard/dashboard.dart';
import '../search/search.dart';

class ScanIDPage extends StatefulWidget {
  static const routeName = '/scan';

  const ScanIDPage({super.key});

  @override
  State<ScanIDPage> createState() => _ScanIDPageState();
}

class _ScanIDPageState extends State<ScanIDPage> {
  final String _selectedItem = 'Scan ID';
  File? _imageFile;
  bool _isProcessing = false;

  final ImagePicker _picker = ImagePicker();

  Widget _buildDrawerHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
      color: Colors.white,
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () => Navigator.of(context).maybePop(),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.arrow_back_ios, color: Color(0xFF1E88FF), size: 16),
                  SizedBox(width: 6),
                  Text('Back', style: TextStyle(color: Color(0xFF1E88FF))),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
          CircleAvatar(
            radius: 36,
            backgroundColor: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black87, width: 2),
              ),
              child: const CircleAvatar(
                radius: 32,
                backgroundColor: Colors.transparent,
                child: Icon(Icons.person_outline, size: 36, color: Colors.black87),
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Juan Dela Cruz',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F0FF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text('Doctor', style: TextStyle(color: Color(0xFF1E88FF), fontWeight: FontWeight.w600, fontSize: 12)),
          ),
        ],
      ),
    );
  }

  Widget _drawerItem(IconData icon, String label, String route) {
    final selected = _selectedItem == label;
    return InkWell(
      onTap: () {
        Navigator.of(context).pop();
        if (route != ScanIDPage.routeName) {
          Navigator.of(context).pushReplacementNamed(route);
        }
      },
      child: Container(
        color: selected ? const Color(0xFF0B79FF) : Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: selected ? Colors.white : Colors.black54, size: 20),
            const SizedBox(width: 14),
            Text(
              label,
              style: TextStyle(
                color: selected ? Colors.white : Colors.black87,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDrawerHeader(context),
            const Divider(height: 1, color: Colors.black12),
            _drawerItem(Icons.home_outlined, 'Dashboard', Dashboard.routeName),
            _drawerItem(Icons.camera_alt_outlined, 'Scan ID', ScanIDPage.routeName),
            _drawerItem(Icons.search, 'Search', SearchPage.routeName),
            _drawerItem(Icons.folder_open_outlined, 'Records', '/records'),
            _drawerItem(Icons.chat_bubble_outline, 'Assistant', '/assistant'),
            const Spacer(),
            InkWell(
              onTap: () {
                Navigator.of(context).pushReplacementNamed('/');
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 16),
                child: Row(
                  children: const [
                    Icon(Icons.logout_outlined, color: Color(0xFF1E88FF)),
                    SizedBox(width: 10),
                    Text('Log out', style: TextStyle(color: Color(0xFF1E88FF), fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _takePhoto() async {
    try {
      final XFile? picked = await _picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.rear,
        imageQuality: 85,
        maxWidth: 1600,
        maxHeight: 1200,
      );

      if (picked == null) return;

      setState(() {
        _imageFile = File(picked.path);
        _isProcessing = true;
      });

      // Simulate processing delay (frontend only)
      await Future.delayed(const Duration(seconds: 2));
      if (!mounted) return;
      setState(() => _isProcessing = false);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to take photo: $e')));
    }
  }

  Future<void> _uploadImage() async {
    try {
      final XFile? picked = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 90,
        maxWidth: 1600,
        maxHeight: 1200,
      );

      if (picked == null) return;

      setState(() {
        _imageFile = File(picked.path);
        _isProcessing = true;
      });

      // Simulate processing delay (frontend only)
      await Future.delayed(const Duration(seconds: 2));
      if (!mounted) return;
      setState(() => _isProcessing = false);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to pick image: $e')));
    }
  }

  Widget _imagePreview(double size) {
    return Center(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
        ),
        child: _imageFile != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(_imageFile!, fit: BoxFit.cover),
              )
            : Center(
                child: Image.asset(
                  'assets/images/image_icon.png',
                  width: 40,
                  height: 40,
                  color: Colors.grey[400],
                ),
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final previewSize = MediaQuery.of(context).size.width > 480 ? 220.0 : 110.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      drawer: _buildDrawer(context),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: false,
        leading: Builder(builder: (ctx) {
          return IconButton(
            icon: const Icon(Icons.menu, color: Colors.black87),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
            tooltip: 'Open menu',
          );
        }),
        titleSpacing: 0,
        title: Row(
          children: [
            Container(
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF0B79FF),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2))],
              ),
              child: Image.asset(
                'assets/images/mediscanapp_logo.png',
                width: 18,
                height: 18,
                color: Colors.white,
                fit: BoxFit.contain,
              ),
            ),
            const Text('MediScan', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w700)),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacementNamed(SearchPage.routeName);
            },
            icon: const Icon(Icons.search, color: Colors.black87),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Scan Patient ID',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Capture or upload a patient identification\ndocument for verification',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // Capture Photo Section
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 24),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0B79FF),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Image.asset(
                            'assets/images/camera_icon.png',
                            width: 24,
                            height: 24,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Capture Photo',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Use your device camera or upload an\nexisting image',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[600],
                                  height: 1.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Image Preview Area - responsive size
                    _imagePreview(previewSize),

                    const SizedBox(height: 16),

                    // Buttons
                    SizedBox(
                      width: double.infinity,
                      height: 44,
                      child: ElevatedButton.icon(
                        onPressed: _takePhoto,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0B79FF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        icon: Image.asset(
                          'assets/images/camera_icon.png',
                          width: 18,
                          height: 18,
                          color: Colors.white,
                        ),
                        label: const Text(
                          'Take a Photo',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    SizedBox(
                      width: double.infinity,
                      height: 44,
                      child: OutlinedButton.icon(
                        onPressed: _uploadImage,
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.grey[100],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          side: BorderSide(color: Colors.grey[300]!),
                        ),
                        icon: Image.asset(
                          'assets/images/upload_icon.png',
                          width: 18,
                          height: 18,
                          color: Colors.grey[700],
                        ),
                        label: Text(
                          'Upload Image',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // OCR Processing Section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.orange[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Image.asset(
                            'assets/images/lightning_icon.png',
                            width: 24,
                            height: 24,
                            color: Colors.orange[600],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'OCR Processing',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Extract text data from the captured\nimage',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[600],
                                  height: 1.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    if (_isProcessing)
                      Column(
                        children: [
                          const CircularProgressIndicator(
                            color: Color(0xFF0B79FF),
                            strokeWidth: 3,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Processing image...',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      )
                    else if (_imageFile == null)
                      Column(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
                            ),
                            child: Center(
                              child: Image.asset(
                                'assets/images/exclamation_point_icon.png',
                                width: 28,
                                height: 28,
                                color: Colors.grey[400],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No image to process',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      )
                    else
                      Column(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.green[100],
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Icon(
                              Icons.check,
                              size: 28,
                              color: Colors.green[600],
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Processing complete',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Text extracted successfully',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}