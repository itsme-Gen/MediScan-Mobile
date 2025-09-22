// lib/pages/dashboard/Dashboard.dart
import 'package:flutter/material.dart';
import '../search/Search.dart';
import '../scan/Scan_ID.dart';

class Dashboard extends StatefulWidget {
  static const routeName = '/dashboard';

  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String _selectedItem = 'Dashboard';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
        if (route != Dashboard.routeName) {
          Navigator.of(context).pushNamed(route);
        } else {
          setState(() {
            _selectedItem = label;
          });
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

  Widget _statCard(String title, String value, String delta, {IconData? icon}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
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
                const SizedBox(height: 8),
                Text(value, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text(delta, style: TextStyle(fontSize: 12, color: delta.startsWith('-') ? Colors.red : Colors.green)),
              ],
            ),
          ),
          if (icon != null)
            Container(
              height: 44,
              width: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFE8F7FF),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: const Color(0xFF0077CC)),
            ),
        ],
      ),
    );
  }

  Widget _pendingReviewsCard() {
    final items = [
      {'name': 'Marja Santos', 'note': 'ID Verified', 'time': '5 min ago', 'color': Colors.green},
      {'name': 'John Dela Cruz', 'note': 'New Registration', 'time': '12 min ago', 'color': Colors.blue},
      {'name': 'Ana Rodriguez', 'note': 'ORC Processing', 'time': '18 min ago', 'color': Colors.amber},
      {'name': 'Carlos Mendoza', 'note': 'Record Updated', 'time': '25 min ago', 'color': Colors.green},
    ];

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Text('Pending Reviews', style: TextStyle(fontWeight: FontWeight.w700)),
          ),
          const SizedBox(height: 6),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text('Latest patient verification activities', style: TextStyle(color: Colors.black54, fontSize: 12)),
          ),
          const SizedBox(height: 12),
          ...items.map((it) {
            return Column(
              children: [
                Row(
                  children: [
                    Container(width: 8, height: 8, decoration: BoxDecoration(color: it['color'] as Color, shape: BoxShape.circle)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(it['name'] as String, style: const TextStyle(fontWeight: FontWeight.w600)),
                          const SizedBox(height: 2),
                          Text(it['note'] as String, style: const TextStyle(fontSize: 12, color: Colors.black54)),
                        ],
                      ),
                    ),
                    Text(it['time'] as String, style: const TextStyle(fontSize: 12, color: Colors.black45)),
                  ],
                ),
                const SizedBox(height: 10),
                const Divider(height: 1),
                const SizedBox(height: 10),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _systemStatusCard() {
    final rows = [
      {'label': 'ORC Processing', 'status': 'Online', 'color': Colors.green},
      {'label': 'Database Connection', 'status': 'Healthy', 'color': Colors.green},
      {'label': 'AI Assistant', 'status': 'Active', 'color': Colors.blue},
      {'label': 'Camera Access', 'status': 'Available', 'color': Colors.grey},
    ];

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          const Align(alignment: Alignment.centerLeft, child: Text('System Status', style: TextStyle(fontWeight: FontWeight.w700))),
          const SizedBox(height: 6),
          const Align(alignment: Alignment.centerLeft, child: Text('Current System Performance', style: TextStyle(color: Colors.black54, fontSize: 12))),
          const SizedBox(height: 12),
          ...rows.map((r) {
            return Column(
              children: [
                Row(
                  children: [
                    Expanded(child: Text(r['label'] as String, style: const TextStyle(fontSize: 13))),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: (r['color'] as Color).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(r['status'] as String, style: TextStyle(color: r['color'] as Color, fontWeight: FontWeight.w600, fontSize: 12)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Divider(height: 1),
                const SizedBox(height: 12),
              ],
            );
          }),
          Container(
            margin: const EdgeInsets.only(top: 6),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: const Color(0xFFEFFCF1),
              border: Border.all(color: Colors.green.withOpacity(0.15)),
            ),
            child: Row(
              children: const [
                Icon(Icons.check_circle, color: Colors.green),
                SizedBox(width: 10),
                Expanded(
                  child: Text('System Performance: Excellent\nAll services running optimally', style: TextStyle(fontSize: 12)),
                ),
              ],
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
            // small rounded blue badge containing your asset logo
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
                // tint to white so it contrasts with blue badge; remove color if you want original logo colors
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
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 8),
                  const Text('Welcome back , Doctor', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
                  const SizedBox(height: 6),
                  Text(
                    "Here's whats happening in your medical verification system today",
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  _statCard('Patients Scanned Today', '127', '+12% from yesterday', icon: Icons.group_rounded),
                  _statCard('Records Verified', '98', '+8% from yesterday', icon: Icons.check_circle_outline),
                  _statCard('New Registrations', '15', '+25% from yesterday', icon: Icons.person_add_alt_1),
                  _statCard('Pending Reviews', '8', '-3% from yesterday', icon: Icons.pending_actions),
                  const SizedBox(height: 18),
                  LayoutBuilder(builder: (context, constraints) {
                    final isWide = constraints.maxWidth > 600;
                    if (isWide) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: _pendingReviewsCard()),
                          const SizedBox(width: 14),
                          Expanded(child: _systemStatusCard()),
                        ],
                      );
                    } else {
                      return Column(
                        children: [
                          _pendingReviewsCard(),
                          const SizedBox(height: 12),
                          _systemStatusCard(),
                        ],
                      );
                    }
                  }),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}