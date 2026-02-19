import 'package:sqflite/sqflite.dart';
import '../models/investment_model.dart';
import 'database_helper.dart';

class InvestmentRepository {
  final DatabaseHelper dbHelper = DatabaseHelper();

  // Add investment
  Future<int> addInvestment(Investment investment) async {
    Database db = await dbHelper.database;
    return await db.insert('investments', investment.toMap());
  }

  // Get all investments
  Future<List<Investment>> getAllInvestments() async {
    Database db = await dbHelper.database;
    List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT i.*, p.name as product_name 
      FROM investments i
      LEFT JOIN products p ON i.product_id = p.id
      ORDER BY i.date DESC
    ''');

    return List.generate(maps.length, (i) {
      return Investment.fromMap(maps[i]);
    });
  }

  // Get investment by ID
  Future<Investment?> getInvestmentById(int id) async {
    Database db = await dbHelper.database;
    List<Map<String, dynamic>> maps = await db.query(
      'investments',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Investment.fromMap(maps.first);
    }
    return null;
  }

  // Update investment
  Future<int> updateInvestment(Investment investment) async {
    Database db = await dbHelper.database;
    return await db.update(
      'investments',
      investment.toMap(),
      where: 'id = ?',
      whereArgs: [investment.id],
    );
  }

  // Delete investment
  Future<int> deleteInvestment(int id) async {
    Database db = await dbHelper.database;
    return await db.delete('investments', where: 'id = ?', whereArgs: [id]);
  }

  // Get total investment
  Future<double> getTotalInvestment() async {
    Database db = await dbHelper.database;
    List<Map<String, dynamic>> result = await db.rawQuery(
      'SELECT SUM(amount) as total FROM investments',
    );

    return result.first['total']?.toDouble() ?? 0.0;
  }

  // Get product purchase investment
  Future<double> getProductInvestmentTotal() async {
    Database db = await dbHelper.database;
    List<Map<String, dynamic>> result = await db.rawQuery('''
      SELECT SUM(amount) as total 
      FROM investments 
      WHERE type = 'product_purchase'
    ''');

    return result.first['total']?.toDouble() ?? 0.0;
  }

  // Get other investments
  Future<double> getOtherInvestmentTotal() async {
    Database db = await dbHelper.database;
    List<Map<String, dynamic>> result = await db.rawQuery('''
      SELECT SUM(amount) as total 
      FROM investments 
      WHERE type != 'product_purchase'
    ''');

    return result.first['total']?.toDouble() ?? 0.0;
  }

  // Get monthly investment
  Future<Map<String, dynamic>> getMonthlyInvestment(int year, int month) async {
    Database db = await dbHelper.database;
    List<Map<String, dynamic>> result = await db.rawQuery(
      '''
      SELECT 
        type,
        SUM(amount) as total,
        COUNT(*) as count
      FROM investments 
      WHERE strftime('%Y', date) = ? 
      AND strftime('%m', date) = ?
      GROUP BY type
    ''',
      [year.toString(), month.toString().padLeft(2, '0')],
    );

    double total = 0;
    Map<String, double> typeWise = {};

    for (var row in result) {
      total += row['total'] ?? 0;
      typeWise[row['type']] = row['total']?.toDouble() ?? 0;
    }

    return {'total': total, 'type_wise': typeWise};
  }
}
