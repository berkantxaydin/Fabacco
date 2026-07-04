import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'presentation/promos_screen.dart';
import 'presentation/facilities_screen.dart';
import 'presentation/account_screen.dart';
import 'presentation/logger_sheet.dart';

// --- Premium SPA Color Palette (60-30-10 Rule) ---
const Color appBackground = Color(0xFFF7F9F9); // 60% Serene Off-White
const Color appPrimary = Color(0xFF2C3E50); // 30% Deep Slate Navy
const Color appAccent = Color(0xFF1ABC9C); // 10% Calming Teal

void main() {
  runApp(
    const ProviderScope(
      child: FabaccoApp(),
    ),
  );
}

class FabaccoApp extends StatelessWidget {
  const FabaccoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fabacco', // Fixed browser tab name
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: appBackground,
        colorScheme: const ColorScheme.light(
          primary: appPrimary,
          secondary: appAccent,
          surface: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: appPrimary,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: appAccent,
          unselectedItemColor: Colors.grey,
          elevation: 8,
        ),
        useMaterial3: true,
      ),
      home: const MainDashboard(),
    );
  }
}

class MainDashboard extends StatefulWidget {
  const MainDashboard({super.key});

  @override
  State<MainDashboard> createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {
  int _currentIndex = 1;

  final List<Widget> _screens = const [
    PromosScreen(),
    FacilitiesScreen(),
    AccountScreen(),
  ];

  void _showLogger(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.6,
        child: const LoggerBottomSheet(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fabacco',
            style: TextStyle(fontWeight: FontWeight.w600, letterSpacing: 1.2)),
        actions: [
          IconButton(
            icon: const Icon(Icons.terminal,
                color: appAccent), // Accent color for the logger icon
            tooltip: 'Open Dev Logs',
            onPressed: () => _showLogger(context),
          ),
        ],
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.campaign), label: 'Promos'),
          BottomNavigationBarItem(icon: Icon(Icons.spa), label: 'Facilities'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
        ],
      ),
    );
  }
}
