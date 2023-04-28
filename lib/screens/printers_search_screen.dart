import 'package:flutter/material.dart';
import 'package:paxa_print/utils/ip_finder.dart';
import 'package:paxa_print/utils/network_scan.dart';

import '../components/printer_tile.dart';
import '../models/printer.dart';

class PrintersSearchScreen extends StatefulWidget {
  final dynamic onUpdate;
  const PrintersSearchScreen(this.onUpdate, {super.key});

  @override
  State<PrintersSearchScreen> createState() => _PrintersSearchScreenState();
}

class _PrintersSearchScreenState extends State<PrintersSearchScreen> {
  bool searching = false;
  List<Printer> printersFound = [];
  @override
  void initState() {
    searchPrinters();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            searching ? 'Buscando impresoras...' : 'Impresoras Encontradas'),
        actions: [
          IconButton(
              onPressed: searching ? null : () => searchPrinters(),
              disabledColor: Colors.grey,
              color: Colors.white,
              icon: const Icon(Icons.refresh))
        ],
      ),
      body: searching
          ? Center(
              child: CircularProgressIndicator(
                color: Colors.amber.shade700,
              ),
            )
          : ListView(
              children: ListTile.divideTiles(
                  context: context,
                  color: Colors.grey.shade300,
                  tiles: [
                  ...printersFound.map(
                    (printer) => PrinterTile(
                        printer.toMap(), printer.alias, null, widget.onUpdate),
                  ),
                ]).toList()),
    );
  }

  Future<void> searchPrinters() async {
    var ip = await getIP();
    if (mounted) {
      setState(() {
        searching = true;
      });
    }
    var scannedFound = await NetworkScanner.scanCommonPorts(ip);

    if (mounted) {
      setState(() {
        searching = false;
        printersFound = scannedFound;
      });
    }
  }
}
