// lib/pages/scan/Medical_Information.dart
import 'package:flutter/material.dart';
import '../search/Search.dart';
import '../dashboard/Dashboard.dart';

class MedicalInformationPage extends StatefulWidget {
  final Map<String, String> patientData;
  const MedicalInformationPage({super.key, required this.patientData});
  @override
  State<MedicalInformationPage> createState() => _MedicalInformationPageState();
}

class _MedicalInformationPageState extends State<MedicalInformationPage> {
  final List<Map<String, dynamic>> _medicalHistory = [];
  final List<Map<String, dynamic>> _vaccinations = [];
  final List<Map<String, dynamic>> _currentMedications = [];
  final List<Map<String, dynamic>> _labResults = [];
  bool _showProfilePanel = false;
  
  final TextEditingController _conditionController = TextEditingController();
  final TextEditingController _vaccineNameController = TextEditingController();
  final TextEditingController _medicationNameController = TextEditingController();
  final TextEditingController _dosageController = TextEditingController();
  final TextEditingController _frequencyController = TextEditingController();
  final TextEditingController _prescribedByController = TextEditingController();
  final TextEditingController _testNameController = TextEditingController();
  final TextEditingController _labFrequencyController = TextEditingController();
  
  DateTime? _selectedDate;
  DateTime? _firstDoseDate;
  DateTime? _secondDoseDate;
  DateTime? _labDate;
  String _selectedStatus = 'Active';
  final List<String> _statusOptions = ['Active', 'Resolved', 'Chronic', 'Monitoring'];

  Widget _buildNavIcon(IconData icon, String label, String route) {
    return GestureDetector(
      onTap: () { if (route != '/scan') Navigator.of(context).pushNamed(route); },
      child: Container(
        margin: const EdgeInsets.only(right: 8), padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: label == 'Scan ID' ? const Color(0xFF1E88FF) : Colors.grey.shade100, borderRadius: BorderRadius.circular(12)),
        child: Icon(icon, color: label == 'Scan ID' ? Colors.white : Colors.black54, size: 20),
      ),
    );
  }

  Widget _buildProfilePanel() {
    return Container(
      width: 280, height: double.infinity, color: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () => setState(() { _showProfilePanel = false; }),
                      child: const Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.arrow_back_ios, color: Color(0xFF1E88FF), size: 16), SizedBox(width: 6), Text('Back', style: TextStyle(color: Color(0xFF1E88FF)))]),
                    ),
                  ),
                  const SizedBox(height: 20),
                  CircleAvatar(radius: 36, backgroundColor: Colors.transparent, child: Container(decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.black87, width: 2)), child: const CircleAvatar(radius: 32, backgroundColor: Colors.transparent, child: Icon(Icons.person_outline, size: 36, color: Colors.black87)))),
                  const SizedBox(height: 12),
                  const Text('Juan Dela Cruz', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                  const SizedBox(height: 8),
                  Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: const Color(0xFFE8F0FF), borderRadius: BorderRadius.circular(8)), child: const Text('Doctor', style: TextStyle(color: Color(0xFF1E88FF), fontWeight: FontWeight.w600, fontSize: 12))),
                ],
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(20),
              child: InkWell(
                onTap: () => Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false),
                child: Container(width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 16), decoration: BoxDecoration(color: const Color(0xFF1E88FF), borderRadius: BorderRadius.circular(8)), child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.logout_outlined, color: Colors.white), SizedBox(width: 10), Text('Log out', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600))])),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _conditionController.dispose();
    _vaccineNameController.dispose();
    _medicationNameController.dispose();
    _dosageController.dispose();
    _frequencyController.dispose();
    _prescribedByController.dispose();
    _testNameController.dispose();
    _labFrequencyController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(1900), lastDate: DateTime.now());
    if (picked != null && picked != _selectedDate) setState(() { _selectedDate = picked; });
  }

  Future<void> _selectFirstDoseDate() async {
    final DateTime? picked = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(1900), lastDate: DateTime.now());
    if (picked != null && picked != _firstDoseDate) setState(() { _firstDoseDate = picked; });
  }

  Future<void> _selectSecondDoseDate() async {
    final DateTime? picked = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(1900), lastDate: DateTime.now());
    if (picked != null && picked != _secondDoseDate) setState(() { _secondDoseDate = picked; });
  }

  Future<void> _selectLabDate() async {
    final DateTime? picked = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(1900), lastDate: DateTime.now());
    if (picked != null && picked != _labDate) setState(() { _labDate = picked; });
  }

  void _addMedicalCondition() {
    if (_conditionController.text.isNotEmpty && _selectedDate != null) {
      setState(() {
        _medicalHistory.add({'condition': _conditionController.text, 'status': _selectedStatus, 'date': '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'});
        _conditionController.clear(); _selectedStatus = 'Active'; _selectedDate = null;
      });
    }
  }

  void _deleteMedicalCondition(int index) => setState(() { _medicalHistory.removeAt(index); });

  void _addVaccination() {
    if (_vaccineNameController.text.isNotEmpty) {
      setState(() {
        _vaccinations.add({'vaccineName': _vaccineNameController.text, 'firstDose': _firstDoseDate != null ? '${_firstDoseDate!.day}/${_firstDoseDate!.month}/${_firstDoseDate!.year}' : null, 'secondDose': _secondDoseDate != null ? '${_secondDoseDate!.day}/${_secondDoseDate!.month}/${_secondDoseDate!.year}' : null});
        _vaccineNameController.clear(); _firstDoseDate = null; _secondDoseDate = null;
      });
    }
  }

  void _deleteVaccination(int index) => setState(() { _vaccinations.removeAt(index); });

  void _addCurrentMedication() {
    if (_medicationNameController.text.isNotEmpty) {
      setState(() {
        _currentMedications.add({
          'medicationName': _medicationNameController.text,
          'dosage': _dosageController.text.isNotEmpty ? _dosageController.text : 'N/A',
          'frequency': _frequencyController.text.isNotEmpty ? _frequencyController.text : 'N/A',
          'prescribedBy': _prescribedByController.text.isNotEmpty ? _prescribedByController.text : 'N/A'
        });
        _medicationNameController.clear();
        _dosageController.clear();
        _frequencyController.clear();
        _prescribedByController.clear();
      });
    }
  }

  void _deleteCurrentMedication(int index) => setState(() { _currentMedications.removeAt(index); });

  void _addLabResult() {
    if (_testNameController.text.isNotEmpty && _labDate != null) {
      setState(() {
        _labResults.add({
          'testName': _testNameController.text,
          'date': '${_labDate!.day}/${_labDate!.month}/${_labDate!.year}',
          'frequency': _labFrequencyController.text.isNotEmpty ? _labFrequencyController.text : 'One-time'
        });
        _testNameController.clear();
        _labFrequencyController.clear();
        _labDate = null;
      });
    }
  }

  void _deleteLabResult(int index) => setState(() { _labResults.removeAt(index); });

  Widget _buildDatePickerField({required String label, required DateTime? selectedDate, required VoidCallback onTap}) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.black54, fontWeight: FontWeight.w500)),
          const SizedBox(height: 4),
          GestureDetector(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8)),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(selectedDate != null ? '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}' : 'dd/mm/yyyy', style: TextStyle(fontSize: 14, color: selectedDate != null ? Colors.black : Colors.grey)), const Icon(Icons.calendar_today, size: 16, color: Colors.grey)]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: const TextStyle(fontSize: 12, color: Colors.black54, fontWeight: FontWeight.w500)), const SizedBox(height: 4), Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600))]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async { Navigator.of(context).pop(); return false; },
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F8FA),
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: const Color(0xFF1E88FF), borderRadius: BorderRadius.circular(10)), child: Image.asset('assets/images/mediscanapp_logo.png', width: 18, height: 18, color: Colors.white, fit: BoxFit.contain)),
                                const SizedBox(width: 8),
                                const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('MediScan', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w700, fontSize: 16)), Text('Medical Record Verification', style: TextStyle(color: Colors.black54, fontSize: 12))]),
                              ],
                            ),
                            GestureDetector(onTap: () => setState(() { _showProfilePanel = true; }), child: Container(padding: const EdgeInsets.all(8), decoration: const BoxDecoration(color: Color(0xFF1E88FF), shape: BoxShape.circle), child: const Icon(Icons.person_outline, color: Colors.white, size: 20))),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(children: [_buildNavIcon(Icons.home_outlined, 'Dashboard', Dashboard.routeName), _buildNavIcon(Icons.camera_alt_outlined, 'Scan ID', '/scan'), _buildNavIcon(Icons.search, 'Search', SearchPage.routeName), _buildNavIcon(Icons.folder_open_outlined, 'Records', '/records'), _buildNavIcon(Icons.chat_bubble_outline, 'Assistant', '/assistant')]),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 500),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text('Medical Information', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Colors.black87)),
                            const SizedBox(height: 8),
                            Text('Complete Patient Medical Profile', style: TextStyle(fontSize: 14, color: Colors.grey[600], height: 1.4), textAlign: TextAlign.center),
                            const SizedBox(height: 24),

                            // Personal Information Section
                            Container(
                              width: double.infinity, padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade200)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Row(children: [Icon(Icons.person, size: 20, color: Colors.black54), SizedBox(width: 8), Text('Personal Information', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16))]),
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
                              width: double.infinity, padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade200)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Row(children: [Icon(Icons.medical_services, size: 20, color: Colors.black54), SizedBox(width: 8), Text('Medical History', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16))]),
                                  const SizedBox(height: 4),
                                  const Text('Add Patient medical condition and history', style: TextStyle(color: Colors.black54, fontSize: 12)),
                                  const SizedBox(height: 16),

                                  Container(decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8)), child: TextField(controller: _conditionController, style: const TextStyle(fontSize: 14), decoration: const InputDecoration(hintText: 'Condition', hintStyle: TextStyle(fontSize: 12, color: Colors.grey), border: InputBorder.none, contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10)))),
                                  const SizedBox(height: 12),

                                  Row(
                                    children: [
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: _selectDate,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                            decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8)),
                                            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(_selectedDate != null ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}' : 'dd/mm/yyyy', style: TextStyle(fontSize: 14, color: _selectedDate != null ? Colors.black : Colors.grey)), const Icon(Icons.calendar_today, size: 16, color: Colors.grey)]),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Container(
                                          decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8)),
                                          child: DropdownButtonFormField<String>(value: _selectedStatus, decoration: const InputDecoration(border: InputBorder.none, contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8)), hint: const Text('Select Status', style: TextStyle(fontSize: 12)), items: _statusOptions.map((status) => DropdownMenuItem(value: status, child: Text(status, style: const TextStyle(fontSize: 12)))).toList(), onChanged: (value) => setState(() => _selectedStatus = value!), style: const TextStyle(fontSize: 12, color: Colors.black)),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),

                                  SizedBox(width: double.infinity, child: ElevatedButton(onPressed: _addMedicalCondition, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0B79FF), padding: const EdgeInsets.symmetric(vertical: 10), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))), child: const Text('Add', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14)))),

                                  // Display Medical History List
                                  if (_medicalHistory.isNotEmpty) ...[
                                    const SizedBox(height: 16), const Divider(), const SizedBox(height: 8),
                                    ...List.generate(_medicalHistory.length, (index) {
                                      final condition = _medicalHistory[index];
                                      return Container(
                                        margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.shade200)),
                                        child: Row(children: [Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(condition['condition'], style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)), Text('${condition['status']} - ${condition['date']}', style: const TextStyle(color: Colors.black54, fontSize: 12))])), IconButton(onPressed: () => _deleteMedicalCondition(index), icon: const Icon(Icons.delete, color: Colors.red, size: 20))]),
                                      );
                                    }),
                                  ],
                                ],
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Vaccinations Section
                            Container(
                              width: double.infinity, padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade200)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Row(children: [Icon(Icons.vaccines, size: 20, color: Colors.black54), SizedBox(width: 8), Text('Vaccinations', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16))]),
                                  const SizedBox(height: 4),
                                  const Text('Track Vaccination History', style: TextStyle(color: Colors.black54, fontSize: 12)),
                                  const SizedBox(height: 16),

                                  Container(decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8)), child: TextField(controller: _vaccineNameController, style: const TextStyle(fontSize: 14), decoration: const InputDecoration(hintText: 'Vaccine Name', hintStyle: TextStyle(fontSize: 12, color: Colors.grey), border: InputBorder.none, contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10)))),
                                  const SizedBox(height: 12),

                                  Row(children: [_buildDatePickerField(label: 'First Dose', selectedDate: _firstDoseDate, onTap: _selectFirstDoseDate), const SizedBox(width: 12), _buildDatePickerField(label: 'Second Dose', selectedDate: _secondDoseDate, onTap: _selectSecondDoseDate)]),
                                  const SizedBox(height: 12),

                                  SizedBox(width: double.infinity, child: ElevatedButton(onPressed: _addVaccination, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0B79FF), padding: const EdgeInsets.symmetric(vertical: 10), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))), child: const Text('Add', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14)))),

                                  // Display Vaccination List
                                  if (_vaccinations.isNotEmpty) ...[
                                    const SizedBox(height: 16), const Divider(), const SizedBox(height: 8),
                                    ...List.generate(_vaccinations.length, (index) {
                                      final vaccination = _vaccinations[index];
                                      return Container(
                                        margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.shade200)),
                                        child: Row(children: [Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(vaccination['vaccineName'], style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)), if (vaccination['firstDose'] != null) Text('First: ${vaccination['firstDose']}', style: const TextStyle(color: Colors.black54, fontSize: 12)), if (vaccination['secondDose'] != null) Text('Second: ${vaccination['secondDose']}', style: const TextStyle(color: Colors.black54, fontSize: 12))])), IconButton(onPressed: () => _deleteVaccination(index), icon: const Icon(Icons.delete, color: Colors.red, size: 20))]),
                                      );
                                    }),
                                  ],
                                ],
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Current Medication Section
                            Container(
                              width: double.infinity, padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade200)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Row(children: [Icon(Icons.medication, size: 20, color: Colors.black54), SizedBox(width: 8), Text('Current Medication', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16))]),
                                  const SizedBox(height: 4),
                                  const Text('List of current medication and prescription', style: TextStyle(color: Colors.black54, fontSize: 12)),
                                  const SizedBox(height: 16),

                                  Container(decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8)), child: TextField(controller: _medicationNameController, style: const TextStyle(fontSize: 14), decoration: const InputDecoration(hintText: 'Medication Name', hintStyle: TextStyle(fontSize: 12, color: Colors.grey), border: InputBorder.none, contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10)))),
                                  const SizedBox(height: 12),

                                  Container(decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8)), child: TextField(controller: _dosageController, style: const TextStyle(fontSize: 14), decoration: const InputDecoration(hintText: 'Dosage', hintStyle: TextStyle(fontSize: 12, color: Colors.grey), border: InputBorder.none, contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10)))),
                                  const SizedBox(height: 12),

                                  Container(decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8)), child: TextField(controller: _frequencyController, style: const TextStyle(fontSize: 14), decoration: const InputDecoration(hintText: 'Frequency', hintStyle: TextStyle(fontSize: 12, color: Colors.grey), border: InputBorder.none, contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10)))),
                                  const SizedBox(height: 12),

                                  Container(decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8)), child: TextField(controller: _prescribedByController, style: const TextStyle(fontSize: 14), decoration: const InputDecoration(hintText: 'Prescribed by', hintStyle: TextStyle(fontSize: 12, color: Colors.grey), border: InputBorder.none, contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10)))),
                                  const SizedBox(height: 12),

                                  SizedBox(width: double.infinity, child: ElevatedButton(onPressed: _addCurrentMedication, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0B79FF), padding: const EdgeInsets.symmetric(vertical: 10), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))), child: const Text('Add', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14)))),

                                  // Display Current Medication List
                                  if (_currentMedications.isNotEmpty) ...[
                                    const SizedBox(height: 16), const Divider(), const SizedBox(height: 8),
                                    ...List.generate(_currentMedications.length, (index) {
                                      final medication = _currentMedications[index];
                                      return Container(
                                        margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.shade200)),
                                        child: Row(children: [Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(medication['medicationName'], style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)), const SizedBox(height: 4), Text('Dosage: ${medication['dosage']}', style: const TextStyle(color: Colors.black54, fontSize: 12)), Text('Frequency: ${medication['frequency']}', style: const TextStyle(color: Colors.black54, fontSize: 12)), Text('Prescribed by: ${medication['prescribedBy']}', style: const TextStyle(color: Colors.black54, fontSize: 12))])), IconButton(onPressed: () => _deleteCurrentMedication(index), icon: const Icon(Icons.delete, color: Colors.red, size: 20))]),
                                      );
                                    }),
                                  ],
                                ],
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Lab Result Section
                            Container(
                              width: double.infinity, padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade200)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Row(children: [Icon(Icons.science, size: 20, color: Colors.black54), SizedBox(width: 8), Text('Lab Result', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16))]),
                                  const SizedBox(height: 4),
                                  const Text('Laboratory Lab Results and reports', style: TextStyle(color: Colors.black54, fontSize: 12)),
                                  const SizedBox(height: 16),

                                  Container(decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8)), child: TextField(controller: _testNameController, style: const TextStyle(fontSize: 14), decoration: const InputDecoration(hintText: 'Test Name', hintStyle: TextStyle(fontSize: 12, color: Colors.grey), border: InputBorder.none, contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10)))),
                                  const SizedBox(height: 12),

                                  Row(
                                    children: [
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: _selectLabDate,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                            decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8)),
                                            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(_labDate != null ? '${_labDate!.day}/${_labDate!.month}/${_labDate!.year}' : 'dd/mm/yyyy', style: TextStyle(fontSize: 14, color: _labDate != null ? Colors.black : Colors.grey)), const Icon(Icons.calendar_today, size: 16, color: Colors.grey)]),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Container(decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8)), child: TextField(controller: _labFrequencyController, style: const TextStyle(fontSize: 14), decoration: const InputDecoration(hintText: 'Frequency', hintStyle: TextStyle(fontSize: 12, color: Colors.grey), border: InputBorder.none, contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10)))),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),

                                  SizedBox(width: double.infinity, child: ElevatedButton(onPressed: _addLabResult, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0B79FF), padding: const EdgeInsets.symmetric(vertical: 10), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))), child: const Text('Add', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14)))),

                                  // Display Lab Result List
                                  if (_labResults.isNotEmpty) ...[
                                    const SizedBox(height: 16), const Divider(), const SizedBox(height: 8),
                                    ...List.generate(_labResults.length, (index) {
                                      final labResult = _labResults[index];
                                      return Container(
                                        margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.shade200)),
                                        child: Row(children: [Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(labResult['testName'], style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)), Text('Date: ${labResult['date']}', style: const TextStyle(color: Colors.black54, fontSize: 12)), Text('Frequency: ${labResult['frequency']}', style: const TextStyle(color: Colors.black54, fontSize: 12))])), IconButton(onPressed: () => _deleteLabResult(index), icon: const Icon(Icons.delete, color: Colors.red, size: 20))]),
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
                ],
              ),
              if (_showProfilePanel) Positioned(right: 0, top: 0, bottom: 0, child: _buildProfilePanel()),
            ],
          ),
        ),
      ),
    );
  }
}