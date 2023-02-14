import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../components/notification_snack_bar.dart';
import '../components/printer_tile.dart';
import 'printer_add_screen.dart';

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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    printerAliases = Hive.box('printers').keys;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.refresh))
        ],
        title: const Text('Impresoras'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: ((context) => PrinterAddScreen(createPrinter))),
          );
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, size: 32),
      ),
      body: ListView(
          children: ListTile.divideTiles(
              context: context,
              color: Colors.grey.shade300,
              tiles: [
            ...printerAliases.map(
              (alias) =>
                  PrinterTile(printersBox.get(alias), alias, deletePrinter),
            ),
          ]).toList()),
    );
  }

  void createPrinter(String alias, Map printerInfo) {
    printersBox.put(alias, printerInfo);
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
        notificationSnackBar('Impresora ${printerInfo['name']} añadida'));
  }

  void deletePrinter(String alias) async {
    printersBox.delete(alias).then((value) {
      setState(() {});
      ScaffoldMessenger.of(context)
          .showSnackBar(notificationSnackBar('Impresora Eliminada'));
    });
  }
}
