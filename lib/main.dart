import 'dart:math';

import 'package:expenses/components/charts.dart';
import 'package:expenses/components/transaction_form.dart';
import 'package:expenses/components/transaction_list.dart';
import 'package:expenses/models/transaction.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(ExpensesApp());
}

class ExpensesApp extends StatelessWidget {
  ExpensesApp({super.key});

  final ThemeData tema = ThemeData();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
      theme: ThemeData(
        useMaterial3: true,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.purple,
          foregroundColor: Colors.white,
          titleTextStyle: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.amber,
          primary: Colors.purple,
          secondary: Colors.amber,
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _transactions = [
    Transaction(
      id: 't0',
      title: 'Novo Tênis',
      value: 200.00,
      date: DateTime.now().subtract(Duration(days: 1)),
    ),
    Transaction(
      id: 't1',
      title: 'Compra de Roupas',
      value: 315.15,
      date: DateTime.now().subtract(Duration(days: 2)),
    ),
    Transaction(
      id: 't2',
      title: 'Supermercado',
      value: 759.50,
      date: DateTime.now().subtract(Duration(days: 3)),
    ),
  ];

  List<Transaction> get _recentTransactions {
    //filtrar apenas as transações dos ultimos 7 dias
    // print(_transactions.where((tr) {
    //   print(tr.date.isAfter(DateTime.now().subtract(Duration(days: 7))));
    //   return tr.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
    // }));
    return _transactions.where((tr) {
      return tr.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  //usado para abrir o modal
  _opentransactionFormModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return TransactionForm(onSubmit: _addTransaction);
      },
    );
  }

  _addTransaction(String title, double value) {
    final newTransaction = Transaction(
      id: Random().nextDouble().toString(),
      title: title,
      value: value,
      date: DateTime.now(),
    );

    //altera o estado da aplicação
    setState(() {
      _transactions.add(newTransaction);
    });

    Navigator.of(context).pop(); //fecha o modal
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal Expenses'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _opentransactionFormModal(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Charts(recentTransaction: _recentTransactions),
            TransactionList(transaction: _transactions),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _opentransactionFormModal(context),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
