class Investment {
  int? id;
  String description;
  double amount;
  String type;
  int? productId;
  String? productName;
  DateTime date;
  String? notes;

  Investment({
    this.id,
    required this.description,
    required this.amount,
    required this.type,
    this.productId,
    this.productName,
    DateTime? date,
    this.notes,
  }) : date = date ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'amount': amount,
      'type': type,
      'product_id': productId,
      'date': date.toIso8601String(),
      'notes': notes,
    };
  }

  factory Investment.fromMap(Map<String, dynamic> map) {
    return Investment(
      id: map['id'],
      description: map['description'],
      amount: map['amount'],
      type: map['type'],
      productId: map['product_id'],
      productName: map['product_name'],
      date: DateTime.parse(map['date']),
      notes: map['notes'],
    );
  }

  String get formattedDate {
    return "${date.day}/${date.month}/${date.year}";
  }

  String get typeText {
    switch (type) {
      case 'product_purchase':
        return 'Product Purchase';
      case 'expense':
        return 'Expense';
      case 'other':
        return 'Other';
      default:
        return type;
    }
  }
}
