import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function addTx;

  NewTransaction(this.addTx);

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;

  void _submitData() {
    if (_amountController.text.isEmpty) {
      return;
    }
    final enteredTitle = _titleController.text;
    final enteredAmount = double.parse(_amountController.text);
    if (enteredAmount <= 0 || enteredTitle.isEmpty || _selectedDate == null) {
      return;
    }
    widget.addTx(enteredTitle, enteredAmount, _selectedDate);
    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2019),
            lastDate: DateTime.now())
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      } else {
        setState(() {
          _selectedDate = pickedDate;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
            left: 10,
            right: 10,
            top: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                cursorColor: Theme.of(context).primaryColorDark,
                autocorrect: true,
                decoration: const InputDecoration(labelText: "Title"),
                controller: _titleController,
                onSubmitted: (_) => _submitData(),
                // onChanged: (val) {
                //   titleInput = val;
                // },
              ),
              TextField(
                keyboardType: TextInputType.number,
                cursorColor: Theme.of(context).primaryColorDark,
                decoration: const InputDecoration(labelText: "Amount"),
                controller: _amountController,
                onSubmitted: (_) => _submitData(),
                // onChanged: (val) {
                //   amountInput = val;
                // },
              ),
              Container(
                height: 70,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _selectedDate == null
                            ? "No Date Chosen!"
                            : "Picked Date: ${DateFormat.yMMMEd().format(_selectedDate!)}",
                      ),
                    ),
                    Platform.isIOS
                        ? CupertinoButton(
                            child: const Text(
                              "Choose Date",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            onPressed: _presentDatePicker)
                        : ElevatedButton(
                            onPressed: _presentDatePicker,
                            child: const Text(
                              "Choose Date",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            style: ElevatedButton.styleFrom(
                                onPrimary: Colors.white,
                                primary: Theme.of(context).primaryColorDark),
                          ),
                  ],
                ),
              ),
              Platform.isIOS
                  ? CupertinoButton.filled(
                      child: const Text(
                        "Add Transaction",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      onPressed: _submitData)
                  : ElevatedButton(
                      onPressed: _submitData,
                      child: const Text(
                        "Add Transaction",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                          onPrimary: Colors.white, primary: Colors.deepPurple),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
