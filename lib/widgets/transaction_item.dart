import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';

class TransactionItem extends StatefulWidget {
  const TransactionItem({
    Key? key,
    required this.transaction,
    required this.deleteTrx,
  }) : super(key: key);

  final Transaction transaction;
  final Function deleteTrx;

  @override
  State<TransactionItem> createState() => _TransactionItemState();
}

class _TransactionItemState extends State<TransactionItem> {
  late Color _bgColor;

  @override
  void initState() {
    const availableColors = [
      Colors.red,
      Colors.black,
      Colors.blue,
      Colors.purple
    ];

    _bgColor = availableColors[Random().nextInt(4)];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
      elevation: 5,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _bgColor,
          radius: 30,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: FittedBox(child: Text('\$${widget.transaction.amount}')),
          ),
        ),
        title: Text(
          widget.transaction.title,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        subtitle: Text(DateFormat.yMMMd().format(widget.transaction.date)),
        trailing: MediaQuery.of(context).size.width > 460
            ? ElevatedButton.icon(
                onPressed: () => widget.deleteTrx(widget.transaction.id),
                label: const Text('Delete'),
                icon: const Icon(
                  Icons.delete,
                ),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        Theme.of(context).errorColor)),
              )
            : IconButton(
                icon: const Icon(Icons.delete),
                color: Theme.of(context).errorColor,
                onPressed: () => widget.deleteTrx(widget.transaction.id),
              ),
      ),
    );
  }
}
