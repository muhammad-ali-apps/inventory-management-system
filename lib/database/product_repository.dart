import 'package:sqflite/sqflite.dart';
import '../models/product_model.dart';
import 'database_helper.dart';

class ProductRepository {
  final DatabaseHelper dbHelper = DatabaseHelper();

  // Add product
  Future<int> addProduct(Product product) async {
    Database db = await dbHelper.database;
    return await db.insert('products', product.toMap());
  }

  // Get all products
  Future<List<Product>> getAllProducts() async {
    Database db = await dbHelper.database;
    List<Map<String, dynamic>> maps = await db.query(
      'products',
      orderBy: 'name ASC',
    );
    return List.generate(maps.length, (i) {
      return Product.fromMap(maps[i]);
    });
  }

  // Get product by ID
  Future<Product?> getProductById(int id) async {
    Database db = await dbHelper.database;
    List<Map<String, dynamic>> maps = await db.query(
      'products',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Product.fromMap(maps.first);
    }
    return null;
  }

  // Update product
  Future<int> updateProduct(Product product) async {
    Database db = await dbHelper.database;
    return await db.update(
      'products',
      product.toMap(),
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }

  // Delete product
  Future<int> deleteProduct(int id) async {
    Database db = await dbHelper.database;
    return await db.delete('products', where: 'id = ?', whereArgs: [id]);
  }

  // Get low stock products
  Future<List<Product>> getLowStockProducts() async {
    Database db = await dbHelper.database;
    List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT * FROM products 
      WHERE current_quantity < min_stock_level 
      OR current_quantity = 0
      ORDER BY current_quantity ASC
    ''');
    return List.generate(maps.length, (i) {
      return Product.fromMap(maps[i]);
    });
  }

  // Update stock quantity
  Future<void> updateStock(int productId, int newQuantity) async {
    Database db = await dbHelper.database;
    await db.rawUpdate(
      '''
      UPDATE products 
      SET current_quantity = ?, updated_at = ?
      WHERE id = ?
    ''',
      [newQuantity, DateTime.now().toIso8601String(), productId],
    );
  }

  // Search products
  Future<List<Product>> searchProducts(String query) async {
    Database db = await dbHelper.database;
    List<Map<String, dynamic>> maps = await db.rawQuery(
      '''
      SELECT * FROM products 
      WHERE name LIKE ? OR description LIKE ? OR category LIKE ?
      ORDER BY name ASC
    ''',
      ['%$query%', '%$query%', '%$query%'],
    );

    return List.generate(maps.length, (i) {
      return Product.fromMap(maps[i]);
    });
  }

  // Get total products count
  Future<int> getTotalProductsCount() async {
    Database db = await dbHelper.database;
    return Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM products'),
        ) ??
        0;
  }

  // Get total stock value
  Future<double> getTotalStockValue() async {
    Database db = await dbHelper.database;
    List<Map<String, dynamic>> result = await db.rawQuery('''
      SELECT SUM(current_quantity * buying_price) as total_value 
      FROM products
    ''');

    return result.first['total_value']?.toDouble() ?? 0.0;
  }
}
