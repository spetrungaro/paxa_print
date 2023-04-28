import 'package:flutter/material.dart';
import 'package:paxa_print/screens/printer_edit_screen.dart';

import '../models/printer.dart';
import '../utils/network_scan.dart';

class PrinterTile extends StatefulWidget {
  final Map value;
  final dynamic id;
  final dynamic onDelete;
  final dynamic onUpdate;
  const PrinterTile(this.value, this.id, this.onDelete, this.onUpdate,
      {super.key});

  @override
  State<PrinterTile> createState() => _PrinterTileState();
}

class _PrinterTileState extends State<PrinterTile> {
  bool online = false;
  bool loading = true;
  @override
  Widget build(BuildContext context) {
    scan();
    return ListTile(
      tileColor: loading
          ? null
          : online
              ? null
              : const Color.fromARGB(255, 255, 241, 242),
      title: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              widget.value['name'] ?? 'Desconocido',
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
            ),
            Text(
              '  (${widget.id})',
              style: const TextStyle(fontSize: 13),
            ),
          ],
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        child: Row(
          children: [
            Text(widget.value['host'] ?? 'Sin IP'),
            Text(
              ' :${widget.value['port'].toString()}',
              textScaleFactor: 0.8,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      leading: Icon(widget.value['marca'] == 'EscP' ? Icons.print : Icons.cast,
          color: online ? Colors.green : Colors.red),
      trailing: !loading
          ? IconButton(
              onPressed: () => widget.onDelete(widget.id),
              icon: const Icon(
                Icons.delete_forever,
                color: Colors.red,
              ),
            )
          : const CircularProgressIndicator.adaptive(),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: ((context) => PrinterEditScreen(
                  Printer.fromMap({widget.id: widget.value}),
                  widget.onUpdate,
                  widget.onDelete))),
        );
      },
    );
  }

  void scan() async {
    if (!loading) return;

    var result = await NetworkScanner.scanSpecificPrinter(
        widget.value['host'], widget.value['port']);
    if (mounted) {
      setState(() {
        loading = false;
        online = result;
      });
    }
  }
}
