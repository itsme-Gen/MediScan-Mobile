// lib/pages/search/Search.dart
import 'package:flutter/material.dart';
import '../dashboard/dashboard.dart';
import '../scan/Scan_ID.dart';

class SearchPage extends StatefulWidget {
  static const routeName = '/search';

  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final String _selectedItem = 'Search';
  bool _showProfilePanel = false;

  Widget _buildNavIcon(IconData icon, String label, String route) {
    final selected = _selectedItem == label;
    return GestureDetector(
      onTap: () {
        if (route != SearchPage.routeName) {
          Navigator.of(context).pushNamed(route);
        }
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF1E88FF) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: selected ? Colors.white : Colors.black54, size: 20),
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
                  const SizedBox(height: 20),
                  CircleAvatar(
                    radius: 36, backgroundColor: Colors.transparent,
                    child: Container(
                      decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.black87, width: 2)),
                      child: const CircleAvatar(radius: 32, backgroundColor: Colors.transparent, child: Icon(Icons.person_outline, size: 36, color: Colors.black87)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text('Juan Dela Cruz', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(color: const Color(0xFFE8F0FF), borderRadius: BorderRadius.circular(8)),
                    child: const Text('Doctor', style: TextStyle(color: Color(0xFF1E88FF), fontWeight: FontWeight.w600, fontSize: 12)),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(20),
              child: InkWell(
                onTap: () => Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false),
                child: Container(
                  width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(color: const Color(0xFF1E88FF), borderRadius: BorderRadius.circular(8)),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Icon(Icons.logout_outlined, color: Colors.white), SizedBox(width: 10), Text('Log out', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600))],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statCard(String title, String value, String delta, {IconData? icon}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 12, color: Colors.black54)),
                const SizedBox(height: 6),
                Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(delta, style: TextStyle(fontSize: 11, color: delta.startsWith('-') ? Colors.red : Colors.green)),
              ],
            ),
          ),
          if (icon != null)
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFE8F7FF),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: const Color(0xFF0077CC), size: 20),
            ),
        ],
      ),
    );
  }

  Widget _sampleQueryButton(String query) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: () {
          _searchController.text = query;
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F0FF),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFF1E88FF).withOpacity(0.2)),
          ),
          child: Text(
            query,
            style: const TextStyle(
              color: Color(0xFF1E88FF),
              fontWeight: FontWeight.w500,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_showProfilePanel) {
          setState(() { _showProfilePanel = false; });
          return false;
        } else {
          setState(() { _showProfilePanel = true; });
          return false;
        }
      },
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
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(color: const Color(0xFF1E88FF), borderRadius: BorderRadius.circular(10)),
                                  child: Image.asset('assets/images/mediscanapp_logo.png', width: 18, height: 18, color: Colors.white, fit: BoxFit.contain),
                                ),
                                const SizedBox(width: 8),
                                const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('MediScan', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w700, fontSize: 16)),
                                    Text('Medical Record Verification', style: TextStyle(color: Colors.black54, fontSize: 12)),
                                  ],
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: () => setState(() { _showProfilePanel = true; }),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(color: Color(0xFF1E88FF), shape: BoxShape.circle),
                                child: const Icon(Icons.person_outline, color: Colors.white, size: 20),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            _buildNavIcon(Icons.home_outlined, 'Dashboard', Dashboard.routeName),
                            _buildNavIcon(Icons.camera_alt_outlined, 'Scan ID', ScanIDPage.routeName),
                            _buildNavIcon(Icons.search, 'Search', SearchPage.routeName),
                            _buildNavIcon(Icons.folder_open_outlined, 'Records', '/records'),
                            _buildNavIcon(Icons.chat_bubble_outline, 'Assistant', '/assistant'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 500),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 12),
                            const Text('Smart Search', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Colors.black87), textAlign: TextAlign.center),
                            const SizedBox(height: 8),
                            Text('Use natural language to search\nthrough patient records and medical data', style: TextStyle(fontSize: 14, color: Colors.grey[600], height: 1.4), textAlign: TextAlign.center),
                            const SizedBox(height: 24),
                            const Text('AI-Powered Medical Search', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.black87), textAlign: TextAlign.center),
                            const SizedBox(height: 16),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade300),
                                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))],
                              ),
                              child: TextField(
                                controller: _searchController,
                                style: const TextStyle(fontSize: 16),
                                decoration: InputDecoration(
                                  hintText: 'Search',
                                  hintStyle: TextStyle(color: Colors.grey[500], fontSize: 16),
                                  prefixIcon: Padding(padding: const EdgeInsets.all(12), child: Icon(Icons.search, color: Colors.grey[600], size: 24)),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Align(alignment: Alignment.centerLeft, child: Text('Try these sample queries:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey[700]))),
                            const SizedBox(height: 12),
                            _sampleQueryButton('"Show me all diabetic patients"'),
                            _sampleQueryButton('"Who had surgery last year?"'),
                            const SizedBox(height: 20),
                            _statCard('Total Patients', '1,247', '+24 this week', icon: Icons.group_rounded),
                            _statCard('Medical Records', '5,890', '+8% from yesterday', icon: Icons.folder_open_outlined),
                            _statCard('Recent Visits', '156', '-3% from yesterday', icon: Icons.access_time),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              if (_showProfilePanel)
                Positioned(right: 0, top: 0, bottom: 0, child: _buildProfilePanel()),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}