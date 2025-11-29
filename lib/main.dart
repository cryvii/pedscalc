import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'widgets/weight_input_widget.dart';
import 'screens/emergency_tab.dart';
import 'screens/meds_tab.dart';
import 'screens/fluids_tab.dart';

void main() {
  runApp(
    const ProviderScope(
      child: PedsCalcApp(),
    ),
  );
}

class PedsCalcApp extends StatelessWidget {
  const PedsCalcApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PedsCalc',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF007AFF), // Clinical Blue
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily: 'Inter',
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF007AFF),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        fontFamily: 'Inter',
      ),
      themeMode: ThemeMode.system,
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'PedsCalc',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
      ),
      body: Column(
        children: [
          // Weight Input Section (Always visible at top)
          Container(
            color: Theme.of(context).colorScheme.surface,
            child: const Padding(
              padding: EdgeInsets.all(16.0),
              child: WeightInputWidget(),
            ),
          ),

          // Tab Bar
          Container(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: TabBar(
              controller: _tabController,
              labelColor: Theme.of(context).colorScheme.primary,
              unselectedLabelColor: Theme.of(context).colorScheme.onSurfaceVariant,
              indicatorColor: Theme.of(context).colorScheme.primary,
              indicatorWeight: 3,
              tabs: const [
                Tab(
                  icon: Icon(Icons.emergency),
                  text: 'Emergency',
                ),
                Tab(
                  icon: Icon(Icons.medication),
                  text: 'Meds',
                ),
                Tab(
                  icon: Icon(Icons.water_drop),
                  text: 'Fluids',
                ),
              ],
            ),
          ),

          // Tab Views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                EmergencyTab(),
                MedsTab(),
                FluidsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
