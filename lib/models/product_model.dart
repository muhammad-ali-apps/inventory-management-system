class Product {
  int? id;
  String name;
  String? description;
  String? category;
  String? barcode;
  int currentQuantity;
  int minStockLevel;
  int maxStockLevel;
  double buyingPrice;
  double sellingPrice;
  DateTime createdAt;
  DateTime updatedAt;

  Product({
    this.id,
    required this.name,
    this.description,
    this.category,
    this.barcode,
    required this.currentQuantity,
    this.minStockLevel = 5,
    this.maxStockLevel = 100,
    required this.buyingPrice,
    required this.sellingPrice,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'barcode': barcode,
      'current_quantity': currentQuantity,
      'min_stock_level': minStockLevel,
      'max_stock_level': maxStockLevel,
      'buying_price': buyingPrice,
      'selling_price': sellingPrice,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      category: map['category'],
      barcode: map['barcode'],
      currentQuantity: map['current_quantity'] ?? 0,
      minStockLevel: map['min_stock_level'] ?? 5,
      maxStockLevel: map['max_stock_level'] ?? 100,
      buyingPrice: map['buying_price'],
      sellingPrice: map['selling_price'],
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
    );
  }

  // Calculate stock status
  String get stockStatus {
    if (currentQuantity <= 0) return 'Out of Stock';
    if (currentQuantity < minStockLevel) return 'Low Stock';
    if (currentQuantity > maxStockLevel) return 'Over Stock';
    return 'In Stock';
  }

  // Get color based on stock
  int get stockColor {
    if (currentQuantity <= 0) return 0xFF000000; // Black
    if (currentQuantity < minStockLevel) return 0xFFFF0000; // Red
    if (currentQuantity > maxStockLevel) return 0xFFFFA500; // Orange
    return 0xFF00FF00; // Green
  }
}
