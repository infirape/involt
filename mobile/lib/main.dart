import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift;
import 'core/data/database.dart';
import 'core/presentation/theme/app_colors.dart';
import 'core/presentation/widgets/curved_navigation_bar.dart';
import 'core/presentation/screens/sectors_list_screen.dart';
import 'core/presentation/screens/search_screen.dart';
import 'core/presentation/screens/sync_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final db = AppDatabase();
  
  // Seed data if empty
  await _seedData(db);

  runApp(MyApp(db: db));
}

Future<void> _seedData(AppDatabase db) async {
  final communities = await db.select(db.communities).get();
  if (communities.isEmpty) {
    // Add Chetilla community
    await db.into(db.communities).insert(
      CommunitiesCompanion.insert(id: 'com-1', name: 'Chetilla'),
    );

    // Sectors from the PDF
    final sectorsList = ['Alto Chetilla', 'Cadena', 'Casadencito', 'Cercado', 'Cochapampa'];

    for (var i = 0; i < sectorsList.length; i++) {
      final sectorId = 'sec-${i + 1}';
      await db.into(db.sectors).insert(
        SectorsCompanion.insert(id: sectorId, communityId: 'com-1', name: sectorsList[i]),
      );

      // Seed 2 customers per sector
      final cust1Id = 'cust-${sectorId}-1';
      await db.into(db.customers).insert(
        CustomersCompanion.insert(
          id: cust1Id,
          code: '${sectorsList[i].substring(0, 3).toUpperCase()}001',
          name: 'Juan Perez - ${sectorsList[i]}',
          communityId: 'com-1',
          sectorId: sectorId,
          connectionType: 1,
          tariff: 0.25,
          meterNumber: 'M-100$i',
        ),
      );
      
      // Seed an initial reading for verification
      await db.into(db.readings).insert(
        ReadingsCompanion.insert(
          id: 'read-${cust1Id}',
          customerId: cust1Id,
          previousValue: 100,
          currentValue: 150,
          consumptionKwh: 50,
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
          latitude: -7.0,
          longitude: -78.0,
          cargoFijo: 6.0,
          alumbradoPublico: 1.0,
          saldoRedondeo: 0.0,
          totalToPay: 7.0,
          isSynced: drift.Value(false),
        ),
      );
    }
  }
}

class MyApp extends StatelessWidget {
  final AppDatabase db;
  const MyApp({super.key, required this.db});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'InVolt',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: AppColors.magenta,
        scaffoldBackgroundColor: AppColors.onyx,
        useMaterial3: true,
      ),
      home: MainNavigationScreen(db: db),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  final AppDatabase db;
  const MainNavigationScreen({super.key, required this.db});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      SectorsListScreen(db: widget.db),
      SearchScreen(db: widget.db),
      SyncScreen(db: widget.db),
      const Center(child: Text('Notificaciones', style: TextStyle(fontSize: 24))),
      const Center(child: Text('Configuración', style: TextStyle(fontSize: 24))),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.mainGradient,
        ),
        child: _screens[_currentIndex],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
