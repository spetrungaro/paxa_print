import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:paxa_print/components/notification_snack_bar.dart';
import 'package:paxa_print/screens/printer_add_screen.dart';

import '../components/printer_tile.dart';

// import '../models/printer.dart';

class PrintersScreen extends StatefulWidget {
  const PrintersScreen({super.key});

  @override
  State<PrintersScreen> createState() => _PrintersScreenState();
}

class _PrintersScreenState extends State<PrintersScreen> {
  final Box printersBox = Hive.box('printers');
  late Iterable printerIds;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    printerIds = Hive.box('printers').keys;
    return Scaffold(
      appBar: AppBar(
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
            ...printerIds.map(
              (id) => PrinterTile(printersBox.get(id), id, deletePrinter),
            ),
          ]).toList()),
    );
  }

  void createPrinter(String uuid, Map printerInfo) {
    printersBox.put(uuid, printerInfo);
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
        notificationSnackBar('Impresora ${printerInfo['name']} añadida'));
  }

  void deletePrinter(String key) async {
    printersBox.delete(key).then((value) {
      setState(() {});
      ScaffoldMessenger.of(context)
          .showSnackBar(notificationSnackBar('Impresora Eliminada'));
    });
  }
}
