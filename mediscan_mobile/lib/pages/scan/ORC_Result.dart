// lib/pages/scan/ORC_Result.dart
import 'package:flutter/material.dart';
import 'dart:io';
import 'Scan_ID.dart';
import 'Medical_Information.dart';
import '../search/Search.dart';

class ORCResultPage extends StatefulWidget {
  final File originalImage;

  const ORCResultPage({super.key, required this.originalImage});

  @override
  State<ORCResultPage> createState() => _ORCResultPageState();
}

class _ORCResultPageState extends State<ORCResultPage> {
  bool _isEditingEnabled = false;
  final Map<String, TextEditingController> _controllers = {};

  // Simulated extracted data from ORC processing
  final Map<String, String> _extractedData = {
    'fullName': 'MARIA SANTOS DELA CRUZ',
    'idNumber': 'ID-2024-001234',
    'address': '123 Rizal St., Makati City',
    'emergencyContact': 'JUAN DELA CRUZ (09171234567)',
    'birthDate': '1985-03-15',
    'bloodType': 'O+',
  };

  @override
  void initState() {
    super.initState();
    // Initialize controllers with extracted data
    _extractedData.forEach((key, value) {
      _controllers[key] = TextEditingController(text: value);
    });
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Widget _buildEditableField(String label, String key, {IconData? icon, bool isRequired = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black54,
              ),
            ),
            if (isRequired)
              const Text(' *', style: TextStyle(color: Colors.red)),
          ],
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: _isEditingEnabled ? Colors.white : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _isEditingEnabled ? Colors.grey.shade300 : Colors.grey.shade200,
            ),
          ),
          child: TextField(
            controller: _controllers[key],
            enabled: _isEditingEnabled,
            style: const TextStyle(fontSize: 14),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              hintStyle: TextStyle(color: Colors.grey[400]),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  void _scanAgain() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const ScanIDPage()),
    );
  }

  void _searchRecords() {
    Navigator.of(context).pushNamed(SearchPage.routeName);
  }

  void _next() {
    // Navigate to Medical Information page
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MedicalInformationPage(
          patientData: _extractedData,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
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
                    'ORC Result',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Review and edit the extracted information before proceeding',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),

                  // Original Image Section - Optimized for horizontal ID cards
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
                        const Text(
                          'Original Image',
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Scanned patient ID Document',
                          style: TextStyle(color: Colors.black54, fontSize: 12),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          width: double.infinity,
                          height: 150, // Reduced height for horizontal ID cards
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              widget.originalImage,
                              fit: BoxFit.cover, // Changed to cover for better horizontal display
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F5E8),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFF4CAF50).withOpacity(0.3)),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.check_circle, color: Color(0xFF4CAF50), size: 20),
                              SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'ORC Confidence',
                                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                                    ),
                                    Text(
                                      'Processing completed successfully',
                                      style: TextStyle(fontSize: 11, color: Colors.black54),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Extracted Information Section
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Extracted Information',
                                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    'Verify the accuracy of the extracted data',
                                    style: TextStyle(color: Colors.black54, fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  _isEditingEnabled = !_isEditingEnabled;
                                });
                              },
                              icon: Icon(
                                _isEditingEnabled ? Icons.edit_off : Icons.edit,
                                color: const Color(0xFF0B79FF),
                                size: 20,
                              ),
                              tooltip: _isEditingEnabled ? 'Disable editing' : 'Edit Fields',
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        _buildEditableField('Full Name', 'fullName', icon: Icons.person, isRequired: true),
                        _buildEditableField('# ID Number', 'idNumber', icon: Icons.badge, isRequired: true),
                        _buildEditableField('Address', 'address', icon: Icons.location_on),
                        _buildEditableField('Emergency Contact', 'emergencyContact', icon: Icons.phone),
                        _buildEditableField('Birth Date', 'birthDate', icon: Icons.calendar_today, isRequired: true),
                        _buildEditableField('Blood Type', 'bloodType', icon: Icons.bloodtype),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _scanAgain,
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
                              Icon(Icons.refresh, color: Colors.black54, size: 18),
                              SizedBox(width: 8),
                              Text(
                                'Scan Again',
                                style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _searchRecords,
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
                          Icon(Icons.search, color: Colors.white, size: 18),
                          SizedBox(width: 8),
                          Text(
                            'Search Records',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _next,
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
                          Text(
                            'Next',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward, color: Colors.white, size: 18),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                  Text(
                    'Click "Search Records" to verify against existing patient database',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}