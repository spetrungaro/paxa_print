import 'package:flutter/material.dart';

import '../models/printer.dart';

class PrintersScreen extends StatelessWidget {
  final List<Printer> printers = [
    Printer(),
    Printer(ipAddress: '192.168.0.232')
  ];
  PrintersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Impresoras'),
      ),
    );
  }
}
