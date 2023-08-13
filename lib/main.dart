import 'package:expense_tracker/widgets/chart.dart';
import 'dart:io';
import './widgets/new_transactions.dart';
import 'package:expense_tracker/widgets/transaction_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'models/transaction.dart';

void main() {
  runApp(myApp());
}

class myApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ExpenseApp',
      theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          accentColor: Colors.amberAccent,
          fontFamily: 'Quicksand',
          textTheme: ThemeData.light().textTheme.copyWith(
                  headline6: const TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              )),
          appBarTheme: AppBarTheme(
              // ignore: deprecated_member_use
              textTheme: ThemeData.light().textTheme.copyWith(
                  headline6: const TextStyle(
                      fontFamily: 'OpenSans',
                      fontSize: 20,
                      fontWeight: FontWeight.bold)))),
      home: myHomePage(),
    );
  }
}

class myHomePage extends StatefulWidget {
  @override
  State<myHomePage> createState() => _myHomePageState();
}

class _myHomePageState extends State<myHomePage> {
  final List<Transaction> _userTransaction = [
    // Transaction(
    //     id: 't1', title: 'New Shoes', amount: 700, date: DateTime.now()),
    // Transaction(id: 't2', title: 'Grocery', amount: 500, date: DateTime.now())
  ];

  bool _showChart = false;

  List<Transaction> get _recentTransactions {
    return _userTransaction.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
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
      _userTransaction.add(newTx);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: ctx,
        builder: (_) {
          return NewTransaction(_addNewTransaction);
        });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransaction.removeWhere((element) => element.id == id);
    });
  }

  void _searchTransaction(List<Transaction> _userTransactions, String id) {
    final index = _userTransaction.indexWhere((element) => element.id == id);
  }

  List<Widget> _buildLandscapeContent(Widget txListWidget, AppBar appBar) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Show Chart!",
            style: Theme.of(context).textTheme.headline6,
          ),
          Switch.adaptive(
            focusColor: Theme.of(context).toggleableActiveColor,
            value: _showChart,
            onChanged: (val) {
              setState(() {
                _showChart = val;
              });
            },
          ),
        ],
      ),
      _showChart
          ? Container(
              height: (MediaQuery.of(context).size.height -
                      appBar.preferredSize.height -
                      MediaQuery.of(context).padding.top) *
                  0.7,
              child: Chart(_recentTransactions))
          : txListWidget,
    ];
  }

  List<Widget> _buildPortraitContent(
    AppBar appBar,
    Widget txListWidget,
  ) {
    return [
      Container(
        height: (MediaQuery.of(context).size.height -
                appBar.preferredSize.height -
                MediaQuery.of(context).padding.top) *
            0.36,
        child: Chart(_recentTransactions),
      ),
      txListWidget
    ];
  }

  AppBar _buildAndroidAppBar() {
    return AppBar(
      title: Text('Expense App'),
      actions: [
        IconButton(
            onPressed: (() => {_searchTransaction}), icon: Icon(Icons.search)),
        IconButton(
            onPressed: () => _startAddNewTransaction(context),
            icon: Icon(CupertinoIcons.add)),
      ],
    );
  }

  CupertinoNavigationBar _buildCupertinoNavigationBar() {
    return CupertinoNavigationBar(
      middle: Text("Expense App"),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
              onPressed: (() => _startAddNewTransaction(context)),
              icon: Icon(Icons.search))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final PreferredSizeWidget appBar = Platform.isIOS
        ? _buildCupertinoNavigationBar()
        : _buildAndroidAppBar() as PreferredSizeWidget;

    final txListWidget = Container(
      height: (MediaQuery.of(context).size.height -
              appBar.preferredSize.height -
              MediaQuery.of(context).padding.top) *
          0.64,
      child: TransactionList(
          _userTransaction, _deleteTransaction, _searchTransaction),
    );

    final pageBody = SafeArea(
        child: SingleChildScrollView(
      child: Column(
        children: [
          if (isLandscape)
            ..._buildLandscapeContent(txListWidget, appBar as AppBar),
          if (!isLandscape)
            ..._buildPortraitContent(appBar as AppBar, txListWidget),
        ],
      ),
    ));

    return Platform.isIOS
        ? CupertinoPageScaffold(
            navigationBar: appBar as ObstructingPreferredSizeWidget,
            child: pageBody,
          )
        : Scaffold(
            appBar: appBar,
            body: pageBody,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () => _startAddNewTransaction(context),
                  ),
          );
  }
}
