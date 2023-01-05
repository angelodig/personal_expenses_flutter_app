import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_expenses/widgets/transaction_item.dart';

import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTrx;

  TransactionList(this.transactions, this.deleteTrx);

  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty
        ? LayoutBuilder(builder: (builder, constraints) {
            return Column(
              children: [
                const Text('No Transactions'),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                    height: constraints.maxHeight * 0.6,
                    child: Image.asset(
                      'assets/images/waiting.png',
                      fit: BoxFit.cover,
                    ))
              ],
            );
          })
        : ListView(
            children: [
              ...transactions.map((tx) => TransactionItem(
                  key: ValueKey(tx.id), transaction: tx, deleteTrx: deleteTrx))
            ].toList(),
          );
  }
}
