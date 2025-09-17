// lib/pages/search/Search.dart
import 'package:flutter/material.dart';
import '../dashboard/dashboard.dart';
import '../scan/scan_id.dart';

class SearchPage extends StatefulWidget {
  static const routeName = '/search';

  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final String _selectedItem = 'Search';

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
        if (route != SearchPage.routeName) {
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

  Widget _sampleQueryButton(String query) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          _searchController.text = query;
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                  const SizedBox(height: 20),
                  const Text(
                    'Smart Search',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Use natural language to search\nthrough patient records and medical data',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    'AI-Powered Medical Search',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      style: const TextStyle(fontSize: 16),
                      decoration: InputDecoration(
                        hintText: 'Search',
                        hintStyle: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 16,
                        ),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Icon(
                            Icons.search,
                            color: Colors.grey[600],
                            size: 24,
                          ),
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Try these sample queries:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _sampleQueryButton('"Show me all diabetic patients"'),
                  _sampleQueryButton('"Who had surgery last year?"'),
                  _sampleQueryButton('"Patients with high blood pressure"'),
                  _sampleQueryButton('"Find recent emergency visits"'),
                  _sampleQueryButton('"Show elderly patients with heart conditions"'),
                  const SizedBox(height: 40),
                ],
              ),
            ),
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