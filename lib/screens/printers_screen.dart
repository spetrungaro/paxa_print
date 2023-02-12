import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../components/printer_tile.dart';

// import '../models/printer.dart';

class PrintersScreen extends StatefulWidget {
  const PrintersScreen({super.key});

  @override
  State<PrintersScreen> createState() => _PrintersScreenState();
}

class _PrintersScreenState extends State<PrintersScreen> {
  final Box printersBox = Hive.box('printers');
  late Iterable printerAliases;

  @override
  void initState() {
    printerAliases = printersBox.keys;
    for (dynamic key in printerAliases) {
      print(key);
    }
    print(printerAliases);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Impresoras'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, size: 32),
      ),
      body: ListView(
          children: ListTile.divideTiles(
              context: context,
              color: Colors.grey.shade300,
              tiles: [
            ...printerAliases.map(
              (alias) => PrinterTile(printersBox.get(alias)),
            ),
          ]).toList()),
    );
  }
}
