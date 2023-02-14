import 'package:flutter/material.dart';

import '../utils/network_scan.dart';

class PrinterTile extends StatefulWidget {
  final Map value;
  final dynamic onDelete;
  final dynamic id;
  const PrinterTile(this.value, this.id, this.onDelete, {super.key});

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
              : const Color.fromARGB(255, 250, 219, 222),
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
        child: Text(widget.value['host'] ?? 'Sin IP'),
      ),
      leading: Icon(widget.value['marca'] == 'EscP' ? Icons.print : Icons.cast),
      trailing: !loading
          ? IconButton(
              onPressed: () => widget.onDelete(widget.id),
              icon: Icon(
                Icons.radio_button_checked,
                color: online ? Colors.green : Colors.red,
              ),
            )
          : const CircularProgressIndicator.adaptive(),
      onTap: () {},
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
