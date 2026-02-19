import 'package:flutter/material.dart';
import 'package:inventory/screens/in_stocks_screen.dart';
import 'package:inventory/screens/investment_screen.dart';
import 'package:inventory/screens/low_stocks_screen.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'screens/dashboard_screen.dart';
import 'screens/products_screen.dart';
import 'screens/add_product_screen.dart';
// import 'screens/investments_screen.dart';
import 'screens/add_investment_screen.dart';
import 'screens/reports_screen.dart';
import 'screens/sales_screen.dart';
import 'screens/add_sale_screen.dart';
import 'database/database_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize FFI for Windows
  sqfliteFfiInit();

  // Initialize database
  try {
    await DatabaseHelper().database;
    print("✅ Database initialized successfully");
  } catch (e) {
    print("❌ Error initializing database: $e");
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Salar Mobile Inventory',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[50],
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
        // ✅ CORRECT: Use CardThemeData instead of CardTheme
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: EdgeInsets.zero,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          elevation: 4,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey[600],
          elevation: 8,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => DashboardScreen(),
        '/products': (context) => ProductsScreen(),
        '/add_product': (context) => AddProductScreen(),
        '/investments': (context) => InvestmentsScreen(),
        '/add_investment': (context) => AddInvestmentScreen(),
        '/reports': (context) => ReportsScreen(),
        '/sales': (context) => SalesScreen(),
        '/add_sale': (context) => AddSaleScreen(),
        '/low_stocks': (context) => LowStocksScreen(),
        '/in_stocks': (context) => InStocksScreen(),
      },
      debugShowCheckedModeBanner: false,
      onUnknownRoute: (settings) {
        return MaterialPageRoute(builder: (context) => DashboardScreen());
      },
    );
  }
}
