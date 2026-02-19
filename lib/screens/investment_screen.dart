import 'package:flutter/material.dart';
import '../models/investment_model.dart';
import '../database/investment_repository.dart';

class InvestmentsScreen extends StatefulWidget {
  @override
  _InvestmentsScreenState createState() => _InvestmentsScreenState();
}

class _InvestmentsScreenState extends State<InvestmentsScreen> {
  final InvestmentRepository _investmentRepo = InvestmentRepository();
  List<Investment> _investments = [];
  List<Investment> _filteredInvestments = [];
  bool _isLoading = true;
  String _selectedFilter = 'all';
  double _totalAmount = 0;

  @override
  void initState() {
    super.initState();
    _loadInvestments();
  }

  Future<void> _loadInvestments() async {
    setState(() => _isLoading = true);
    try {
      List<Investment> investments = await _investmentRepo.getAllInvestments();

      // Calculate total
      double total = 0;
      for (var inv in investments) {
        total += inv.amount;
      }

      setState(() {
        _investments = investments;
        _filteredInvestments = investments;
        _totalAmount = total;
        _isLoading = false;
      });
    } catch (e) {
      print("Error loading investments: $e");
      setState(() => _isLoading = false);
    }
  }

  void _filterInvestments(String type) {
    setState(() {
      _selectedFilter = type;
      if (type == 'all') {
        _filteredInvestments = _investments;
      } else {
        _filteredInvestments = _investments
            .where((inv) => inv.type == type)
            .toList();
      }
    });
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'product_purchase':
        return Icons.shopping_cart;
      case 'expense':
        return Icons.money_off;
      case 'other':
        return Icons.money;
      default:
        return Icons.attach_money;
    }
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'product_purchase':
        return Colors.blue;
      case 'expense':
        return Colors.red;
      case 'other':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Widget _buildInvestmentCard(Investment investment) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: _getTypeColor(investment.type).withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Icon(
              _getTypeIcon(investment.type),
              color: _getTypeColor(investment.type),
              size: 24,
            ),
          ),
        ),
        title: Text(
          investment.description,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(investment.typeText),
            if (investment.productName != null)
              Text('Product: ${investment.productName!}'),
            Text('Date: ${investment.formattedDate}'),
            if (investment.notes != null && investment.notes!.isNotEmpty)
              Text('Notes: ${investment.notes!}'),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'Rs ${investment.amount.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            SizedBox(height: 4),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: _getTypeColor(investment.type).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                investment.typeText.split(' ')[0],
                style: TextStyle(
                  fontSize: 10,
                  color: _getTypeColor(investment.type),
                ),
              ),
            ),
          ],
        ),
        onTap: () {
          // Investment details screen
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Investments (${_filteredInvestments.length})'),
        actions: [
          IconButton(icon: Icon(Icons.refresh), onPressed: _loadInvestments),
        ],
      ),
      body: Column(
        children: [
          // Summary Card
          Card(
            margin: EdgeInsets.all(10),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    'Total Investment',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Rs ${_totalAmount.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildTypeSummary('product_purchase', 'Purchase'),
                      _buildTypeSummary('expense', 'Expense'),
                      _buildTypeSummary('other', 'Other'),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                FilterChip(
                  label: Text('All'),
                  selected: _selectedFilter == 'all',
                  onSelected: (_) => _filterInvestments('all'),
                ),
                SizedBox(width: 5),
                FilterChip(
                  label: Text('Product Purchase'),
                  selected: _selectedFilter == 'product_purchase',
                  onSelected: (_) => _filterInvestments('product_purchase'),
                ),
                SizedBox(width: 5),
                FilterChip(
                  label: Text('Expenses'),
                  selected: _selectedFilter == 'expense',
                  onSelected: (_) => _filterInvestments('expense'),
                ),
                SizedBox(width: 5),
                FilterChip(
                  label: Text('Other'),
                  selected: _selectedFilter == 'other',
                  onSelected: (_) => _filterInvestments('other'),
                ),
              ],
            ),
          ),

          SizedBox(height: 10),

          // Investments List
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _filteredInvestments.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.account_balance_wallet,
                          size: 60,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 10),
                        Text(
                          _selectedFilter == 'all'
                              ? 'No investments found'
                              : 'No ${_selectedFilter} investments',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                        if (_selectedFilter != 'all')
                          TextButton(
                            onPressed: () => _filterInvestments('all'),
                            child: Text('Show All'),
                          ),
                      ],
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _loadInvestments,
                    child: ListView.builder(
                      itemCount: _filteredInvestments.length,
                      itemBuilder: (context, index) {
                        return _buildInvestmentCard(
                          _filteredInvestments[index],
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add_investment');
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildTypeSummary(String type, String label) {
    double total = _investments
        .where((inv) => inv.type == type)
        .fold(0.0, (sum, inv) => sum + inv.amount);

    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _getTypeColor(type).withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(_getTypeIcon(type), color: _getTypeColor(type), size: 20),
        ),
        SizedBox(height: 5),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey)),
        Text(
          'Rs ${total.toStringAsFixed(0)}',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: _getTypeColor(type),
          ),
        ),
      ],
    );
  }
}
