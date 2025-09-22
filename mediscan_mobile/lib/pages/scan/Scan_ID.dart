// lib/pages/scan/Scan_ID.dart
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'ORC_Result.dart';
import '../dashboard/Dashboard.dart';
import '../search/Search.dart';

class ScanIDPage extends StatefulWidget {
  static const routeName = '/scan';

  const ScanIDPage({super.key});

  @override
  State<ScanIDPage> createState() => _ScanIDPageState();
}

class _ScanIDPageState extends State<ScanIDPage> {
  final String _selectedItem = 'Scan ID';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  File? _selectedImage;
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
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
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
          Navigator.of(context).pushNamed(route);
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
                Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 16),
                child: Row(
                  children: [
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
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1800,
        maxHeight: 1800,
        imageQuality: 85,
      );
      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      _showErrorDialog('Failed to take photo: $e');
    }
  }

  Future<void> _uploadImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1800,
        maxHeight: 1800,
        imageQuality: 85,
      );
      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      _showErrorDialog('Failed to upload image: $e');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _processImage() async {
    if (_selectedImage == null) return;

    setState(() {
      _isProcessing = true;
    });

    // Simulate processing delay
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    setState(() {
      _isProcessing = false;
    });

    // Navigate to ORC Result page
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ORCResultPage(originalImage: _selectedImage!),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_scaffoldKey.currentState?.isDrawerOpen ?? false) {
          Navigator.of(context).pop();
          return false;
        } else {
          _scaffoldKey.currentState?.openDrawer();
          return false;
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
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
                  boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2))],
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
                Navigator.of(context).pushNamed(SearchPage.routeName);
              },
              icon: const Icon(Icons.search, color: Colors.black87),
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Scan Patient ID',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Capture or upload a patient identification\ndocument for verification',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),

                    // Capture Photo Section
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF0B79FF),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                              ),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Capture Photo',
                                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      'Use your device camera or upload an existing image',
                                      style: TextStyle(color: Colors.black54, fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // Image Preview Area
                          Container(
                            width: double.infinity,
                            height: 200,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
                            ),
                            child: _selectedImage != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.file(
                                      _selectedImage!,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: double.infinity,
                                    ),
                                  )
                                : const Center(
                                    child: Icon(
                                      Icons.image_outlined,
                                      size: 48,
                                      color: Colors.grey,
                                    ),
                                  ),
                          ),
                          const SizedBox(height: 16),

                          // Action Buttons
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _takePhoto,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0B79FF),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.camera_alt, color: Colors.white, size: 18),
                                  SizedBox(width: 8),
                                  Text(
                                    'Take a Photo',
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: _uploadImage,
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: Colors.grey.shade300),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.upload, color: Colors.black54, size: 18),
                                  SizedBox(width: 8),
                                  Text(
                                    'Upload Image',
                                    style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ORC Processing Section
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFA726),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(Icons.bolt, color: Colors.white, size: 20),
                              ),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'ORC Processing',
                                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      'Extract text data from the captured image',
                                      style: TextStyle(color: Colors.black54, fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // Processing Status Area
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 40),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade200),
                            ),
                            child: Column(
                              children: [
                                if (_selectedImage == null) ...[
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: const BoxDecoration(
                                      color: Colors.grey,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.info_outline, color: Colors.white, size: 24),
                                  ),
                                  const SizedBox(height: 12),
                                  const Text(
                                    'No image to process',
                                    style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w500),
                                  ),
                                ] else if (_isProcessing) ...[
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF4CAF50),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  const Text(
                                    'Processing image...',
                                    style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w500),
                                  ),
                                ] else ...[
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF4CAF50),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(Icons.bolt, color: Colors.white, size: 24),
                                  ),
                                  const SizedBox(height: 12),
                                  const Text(
                                    'Ready to process',
                                    style: TextStyle(color: Color(0xFF4CAF50), fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    'Click below to extract text from the image',
                                    style: TextStyle(color: Colors.black54, fontSize: 12),
                                  ),
                                ],
                              ],
                            ),
                          ),

                          if (_selectedImage != null && !_isProcessing) ...[
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _processImage,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF4CAF50),
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.bolt, color: Colors.white, size: 18),
                                    SizedBox(width: 8),
                                    Text(
                                      'Process Image',
                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}