import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';
import 'list_item.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTx;
  final Function searchTransaction;
  // final Function editTx;
  TransactionList(this.transactions, this.deleteTx, this.searchTransaction);
  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty
        ? LayoutBuilder(builder: (ctx, constraints) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "No Transactions added",
                  style: Theme.of(context).textTheme.headline6,
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                    height: 130,
                    child: Image.asset('assets/images/waiting.png',
                        fit: BoxFit.cover)),
              ],
            );
          })
        : ListView.builder(
            itemBuilder: (ctx, index) {
              return ListItem(
                  transaction: transactions[index], deleteTx: deleteTx);
            },
            itemCount: transactions.length,
          );
  }
}
