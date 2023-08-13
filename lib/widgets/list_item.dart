import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import '../models/transaction.dart';

class ListItem extends StatelessWidget {
  const ListItem({
    Key? key,
    required this.transaction,
    required this.deleteTx,
  }) : super(key: key);

  final Transaction transaction;
  final Function deleteTx;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.symmetric(vertical: 9, horizontal: 6),
      child: ListTile(
        leading: CircleAvatar(
          radius: 35,
          child: Padding(
            padding: EdgeInsets.all(6),
            child: FittedBox(
              child: Text('\u{20B9} ${transaction.amount}'),
            ),
          ),
        ),
        title: Text(
          transaction.title,
          style: Theme.of(context).textTheme.headline6,
        ),
        subtitle: Text(
          DateFormat.yMMMMd().format(transaction.date),
        ),
        trailing: SizedBox(
          width: 150,
          child: Row(children: [
            IconButton(onPressed: (() => {}), icon: Icon(Icons.edit)),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => deleteTx(transaction.id),
              color: Theme.of(context).errorColor,
            ),
          ]),
        ),
      ),
    );
  }
}
