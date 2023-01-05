import 'package:flutter/material.dart';
import 'package:personal_expenses/widgets/chart.dart';
import 'package:personal_expenses/widgets/new_transaction.dart';
import 'package:personal_expenses/widgets/transaction_list.dart';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'models/transaction.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expenses',
      theme: ThemeData(
        primarySwatch: Colors.green,
        accentColor: Colors.orange,
        errorColor: Colors.red,
        // appBarTheme:
        // AppBarTheme(textTheme: ThemeData.light().textTheme.copyWith())
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _userTransactions = [
    //Mock
    Transaction(
        id: 't1', title: 'New Shoes', amount: 69.99, date: DateTime.now()),
    Transaction(
        id: 't2',
        title: 'Weekly groceries',
        amount: 16.53,
        date: DateTime.now()),
    Transaction(
        id: 't3', title: 'New Shoes', amount: 69.99, date: DateTime.now()),
    Transaction(
        id: 't4',
        title: 'Weekly groceries',
        amount: 16.53,
        date: DateTime.now()),
    Transaction(
        id: 't5', title: 'New Shoes', amount: 69.99, date: DateTime.now()),
    Transaction(
        id: 't6',
        title: 'Weekly groceries',
        amount: 16.53,
        date: DateTime.now()),
    Transaction(
        id: 't7', title: 'New Shoes', amount: 69.99, date: DateTime.now()),
    Transaction(
        id: 't8',
        title: 'Weekly groceries',
        amount: 16.53,
        date: DateTime.now()),
    Transaction(
        id: 't9', title: 'New Shoes', amount: 69.99, date: DateTime.now()),
    Transaction(
        id: 't10',
        title: 'Weekly groceries',
        amount: 16.53,
        date: DateTime.now()),
  ];

  bool _showChart = false;

  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(DateTime.now().subtract(const Duration(days: 7)));
    }).toList();
  }

  void _addNewTransaction(
      String txTitle, double txAmount, DateTime chosenDate) {
    final newTx = Transaction(
        id: DateTime.now().toString(),
        title: txTitle,
        amount: txAmount,
        date: chosenDate);

    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return GestureDetector(
              onTap: () {},
              behavior: HitTestBehavior.opaque,
              child: NewTransaction(_addNewTransaction));
        });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((trx) => trx.id == id);
    });
  }

  List<Widget> _buildLandscapeContent(MediaQueryData mediaQuery,
          PreferredSizeWidget appBar, Widget txListWidget) =>
      [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Show Chart',
            ),
            Switch.adaptive(
                activeColor: Theme.of(context).accentColor,
                value: _showChart,
                onChanged: (value) {
                  setState(() {
                    _showChart = value;
                  });
                })
          ],
        ),
        _showChart
            ? Container(
                height: (mediaQuery.size.height -
                        appBar.preferredSize.height -
                        mediaQuery.padding.top) *
                    0.21,
                child: Chart(recentTransactions: _recentTransactions))
            : txListWidget
      ];

  List<Widget> _buildPortraitContent(MediaQueryData mediaQuery,
          PreferredSizeWidget appBar, Widget txListWidget) =>
      [
        Container(
            height: (mediaQuery.size.height -
                    appBar.preferredSize.height -
                    mediaQuery.padding.top) *
                0.21,
            child: Chart(recentTransactions: _recentTransactions)),
        txListWidget
      ];

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;
    final PreferredSizeWidget appBar = Platform.isIOS
        ? CupertinoNavigationBar(
            middle: const Text('Personal Expenses'),
            trailing: Row(mainAxisSize: MainAxisSize.min, children: [
              GestureDetector(
                child: const Icon(CupertinoIcons.add),
                onTap: () => _startAddNewTransaction(context),
              )
            ]),
          )
        : AppBar(
            title: const Text('Personal Expenses'),
            actions: [
              IconButton(
                  onPressed: () => _startAddNewTransaction(context),
                  icon: const Icon(Icons.add))
            ],
          ) as PreferredSizeWidget;

    final txListWidget = Container(
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            0.79,
        child: TransactionList(_userTransactions, _deleteTransaction));

    final bodyWidget = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (isLandscape)
              ..._buildLandscapeContent(mediaQuery, appBar, txListWidget),
            if (!isLandscape)
              ..._buildPortraitContent(mediaQuery, appBar, txListWidget),
          ],
        ),
      ),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: bodyWidget,
            navigationBar: appBar as ObstructingPreferredSizeWidget,
          )
        : Scaffold(
            appBar: appBar,
            body: bodyWidget,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    onPressed: () => _startAddNewTransaction(context),
                    child: const Icon(Icons.add),
                  ),
          );
  }
}
