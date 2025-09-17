// lib/main.dart
import 'package:flutter/material.dart';
import 'pages/auth/Login.dart';
import 'pages/auth/Create_Account.dart';
import 'pages/dashboard/Dashboard.dart';
import 'pages/search/Search.dart';
import 'pages/scan/Scan_ID.dart';

final RouteObserver<ModalRoute<void>> routeObserver = RouteObserver<ModalRoute<void>>();

void main() {
  runApp(const MediScanApp());
}

class MediScanApp extends StatelessWidget {
  const MediScanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MediScan',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      navigatorObservers: [routeObserver],
      initialRoute: Login.routeName,
      routes: {
        Login.routeName: (_) => const Login(),
        CreateAccountPage.routeName: (_) => const CreateAccountPage(),
        Dashboard.routeName: (_) => const Dashboard(),
        SearchPage.routeName: (_) => const SearchPage(),
        ScanIDPage.routeName: (_) => const ScanIDPage(),
        // Future routes
        '/records': (_) => const Placeholder(),
        '/assistant': (_) => const Placeholder(),
      },
    );
  }
}