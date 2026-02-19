class Sale {
  int? id;
  int productId;
  String productName;
  int quantity;
  double unitPrice;
  double buyingPrice; // ✅ Add buying price
  double totalAmount;
  double profit; // ✅ Add profit field
  DateTime saleDate;
  String? customerName;
  String? customerPhone;
  String? customerAddress; // ✅ Add customer address

  Sale({
    this.id,
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
    required this.buyingPrice, // ✅ Add this
    required this.totalAmount,
    required this.profit, // ✅ Add this
    DateTime? saleDate,
    this.customerName,
    this.customerPhone,
    this.customerAddress, // ✅ Add this
  }) : saleDate = saleDate ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'product_id': productId,
      'product_name': productName,
      'quantity': quantity,
      'unit_price': unitPrice,
      'buying_price': buyingPrice, // ✅ Add this
      'total_amount': totalAmount,
      'profit': profit, // ✅ Add this
      'sale_date': saleDate.toIso8601String(),
      'customer_name': customerName,
      'customer_phone': customerPhone,
      'customer_address': customerAddress, // ✅ Add this
    };
  }

  factory Sale.fromMap(Map<String, dynamic> map) {
    return Sale(
      id: map['id'],
      productId: map['product_id'],
      productName: map['product_name'],
      quantity: map['quantity'],
      unitPrice: map['unit_price'],
      buyingPrice: map['buying_price'] ?? 0, // ✅ Add this
      totalAmount: map['total_amount'],
      profit: map['profit'] ?? 0, // ✅ Add this
      saleDate: DateTime.parse(map['sale_date']),
      customerName: map['customer_name'],
      customerPhone: map['customer_phone'],
      customerAddress: map['customer_address'], // ✅ Add this
    );
  }

  // Calculate profit percentage
  double get profitPercentage {
    if (buyingPrice == 0) return 0;
    return ((profit / (buyingPrice * quantity)) * 100);
  }
}
