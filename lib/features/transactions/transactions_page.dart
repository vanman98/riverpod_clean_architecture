import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../app/router/app_routes.dart';

class TransactionsPage extends StatelessWidget {
  const TransactionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ids = List.generate(10, (i) => 'TX-${i + 1}');
    return Scaffold(
      appBar: AppBar(title: const Text('Transactions')),
      body: ListView.builder(
        itemCount: ids.length,
        itemBuilder: (_, i) {
          final id = ids[i];
          return ListTile(
            title: Text('Transaction $id'),
            onTap: () {
              context.push(AppRoutes.transactionDetail(id));
            },
          );
        },
      ),
    );
  }
}
