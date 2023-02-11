import 'package:flutter/material.dart';

import '../models/printer.dart';

class PrinterCard extends StatelessWidget {
  final Printer printer;
  const PrinterCard(this.printer, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      key: Key(printer.id),
      elevation: 4,
      borderOnForeground: true,
      color: Colors.grey.shade300,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.print),
            title: Text(printer.name),
            subtitle: Text(printer.ipAddress),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              TextButton(
                child: const Text('Ver'),
                onPressed: () {/* ... */},
              ),
              const SizedBox(width: 8),
            ],
          ),
        ],
      ),
    );
  }
}
