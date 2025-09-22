// lib/pages/scan/Medical_Information.dart
import 'package:flutter/material.dart';
import '../search/Search.dart';

class MedicalInformationPage extends StatefulWidget {
  final Map<String, String> patientData;

  const MedicalInformationPage({super.key, required this.patientData});

  @override
  State<MedicalInformationPage> createState() => _MedicalInformationPageState();
}

class _MedicalInformationPageState extends State<MedicalInformationPage> {
  final List<Map<String, dynamic>> _medicalHistory = [];
  final List<Map<String, dynamic>> _vaccinations = [];
  
  final TextEditingController _conditionController = TextEditingController();
  final TextEditingController _vaccineNameController = TextEditingController();
  
  DateTime? _selectedDate;
  DateTime? _firstDoseDate;
  DateTime? _secondDoseDate;
  String _selectedStatus = 'Active';
  final List<String> _statusOptions = ['Active', 'Resolved', 'Chronic', 'Monitoring'];

  @override
  void dispose() {
    _conditionController.dispose();
    _vaccineNameController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectFirstDoseDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _firstDoseDate) {
      setState(() {
        _firstDoseDate = picked;
      });
    }
  }

  Future<void> _selectSecondDoseDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _secondDoseDate) {
      setState(() {
        _secondDoseDate = picked;
      });
    }
  }

  void _addMedicalCondition() {
    if (_conditionController.text.isNotEmpty && _selectedDate != null) {
      setState(() {
        _medicalHistory.add({
          'condition': _conditionController.text,
          'status': _selectedStatus,
          'date': '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
        });
        _conditionController.clear();
        _selectedStatus = 'Active';
        _selectedDate = null;
      });
    }
  }

  void _deleteMedicalCondition(int index) {
    setState(() {
      _medicalHistory.removeAt(index);
    });
  }

  void _addVaccination() {
    if (_vaccineNameController.text.isNotEmpty) {
      setState(() {
        _vaccinations.add({
          'vaccineName': _vaccineNameController.text,
          'firstDose': _firstDoseDate != null ? '${_firstDoseDate!.day}/${_firstDoseDate!.month}/${_firstDoseDate!.year}' : null,
          'secondDose': _secondDoseDate != null ? '${_secondDoseDate!.day}/${_secondDoseDate!.month}/${_secondDoseDate!.year}' : null,
        });
        _vaccineNameController.clear();
        _firstDoseDate = null;
        _secondDoseDate = null;
      });
    }
  }

  void _deleteVaccination(int index) {
    setState(() {
      _vaccinations.removeAt(index);
    });
  }

  Widget _buildDatePickerField({
    required String label,
    required DateTime? selectedDate,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.black54, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 4),
          GestureDetector(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    selectedDate != null
                        ? '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}'
                        : 'dd/mm/yyyy',
                    style: TextStyle(
                      fontSize: 14,
                      color: selectedDate != null ? Colors.black : Colors.grey,
                    ),
                  ),
                  const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                ],
              ),
            ),
          ),
        ],
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
                    'Medical Information',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Complete Patient Medical Profile',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),

                  // Personal Information Section
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
                        const Row(
                          children: [
                            Icon(Icons.person, size: 20, color: Colors.black54),
                            SizedBox(width: 8),
                            Text(
                              'Personal Information',
                              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        
                        _buildInfoRow('Full Name', widget.patientData['fullName'] ?? 'N/A'),
                        _buildInfoRow('ID Number', widget.patientData['idNumber'] ?? 'N/A'),
                        _buildInfoRow('Birth Date', widget.patientData['birthDate'] ?? 'N/A'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Medical History Section
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
                        const Row(
                          children: [
                            Icon(Icons.medical_services, size: 20, color: Colors.black54),
                            SizedBox(width: 8),
                            Text(
                              'Medical History',
                              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Add Patient medical condition and history',
                          style: TextStyle(color: Colors.black54, fontSize: 12),
                        ),
                        const SizedBox(height: 16),

                        // Add Medical Condition Form
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: TextField(
                            controller: _conditionController,
                            style: const TextStyle(fontSize: 14),
                            decoration: const InputDecoration(
                              hintText: 'Condition',
                              hintStyle: TextStyle(fontSize: 12, color: Colors.grey),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: _selectDate,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        _selectedDate != null
                                            ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                                            : 'dd/mm/yyyy',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: _selectedDate != null ? Colors.black : Colors.grey,
                                        ),
                                      ),
                                      const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey.shade300),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: DropdownButtonFormField<String>(
                                  value: _selectedStatus,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  ),
                                  hint: const Text('Select Status', style: TextStyle(fontSize: 12)),
                                  items: _statusOptions.map((status) => DropdownMenuItem(
                                    value: status,
                                    child: Text(status, style: const TextStyle(fontSize: 12)),
                                  )).toList(),
                                  onChanged: (value) => setState(() => _selectedStatus = value!),
                                  style: const TextStyle(fontSize: 12, color: Colors.black),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _addMedicalCondition,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0B79FF),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Add',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14),
                            ),
                          ),
                        ),

                        // Display Medical History List
                        if (_medicalHistory.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          const Divider(),
                          const SizedBox(height: 8),
                          ...List.generate(_medicalHistory.length, (index) {
                            final condition = _medicalHistory[index];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade50,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey.shade200),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          condition['condition'],
                                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                                        ),
                                        Text(
                                          '${condition['status']} - ${condition['date']}',
                                          style: const TextStyle(color: Colors.black54, fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () => _deleteMedicalCondition(index),
                                    icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Vaccinations Section
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
                        const Row(
                          children: [
                            Icon(Icons.vaccines, size: 20, color: Colors.black54),
                            SizedBox(width: 8),
                            Text(
                              'Vaccinations',
                              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Track Vaccination History',
                          style: TextStyle(color: Colors.black54, fontSize: 12),
                        ),
                        const SizedBox(height: 16),

                        // Add Vaccination Form
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: TextField(
                            controller: _vaccineNameController,
                            style: const TextStyle(fontSize: 14),
                            decoration: const InputDecoration(
                              hintText: 'Vaccine Name',
                              hintStyle: TextStyle(fontSize: 12, color: Colors.grey),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        Row(
                          children: [
                            _buildDatePickerField(
                              label: 'First Dose',
                              selectedDate: _firstDoseDate,
                              onTap: _selectFirstDoseDate,
                            ),
                            const SizedBox(width: 12),
                            _buildDatePickerField(
                              label: 'Second Dose',
                              selectedDate: _secondDoseDate,
                              onTap: _selectSecondDoseDate,
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _addVaccination,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0B79FF),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Add',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14),
                            ),
                          ),
                        ),

                        // Display Vaccination List
                        if (_vaccinations.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          const Divider(),
                          const SizedBox(height: 8),
                          ...List.generate(_vaccinations.length, (index) {
                            final vaccination = _vaccinations[index];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade50,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey.shade200),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          vaccination['vaccineName'],
                                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                                        ),
                                        if (vaccination['firstDose'] != null)
                                          Text(
                                            'First: ${vaccination['firstDose']}',
                                            style: const TextStyle(color: Colors.black54, fontSize: 12),
                                          ),
                                        if (vaccination['secondDose'] != null)
                                          Text(
                                            'Second: ${vaccination['secondDose']}',
                                            style: const TextStyle(color: Colors.black54, fontSize: 12),
                                          ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () => _deleteVaccination(index),
                                    icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.black54, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}