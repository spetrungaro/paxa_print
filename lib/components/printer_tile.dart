import 'package:flutter/material.dart';

class PrinterTile extends StatelessWidget {
  final Map value;
  const PrinterTile(this.value, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              value['name'] ?? 'Desconocido',
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
            ),
            Text(
              '  (${value['alias'] ?? 'Desconocido'})',
              style: const TextStyle(fontSize: 13),
            ),
          ],
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        child: Text(value['ip'] ?? 'Sin IP'),
      ),
      leading: Icon(
          value['driver'] == 'ReceiptDirectJet' ? Icons.print : Icons.cast),
      trailing: const Icon(
        Icons.radio_button_checked,
        color: Colors.green,
      ),
      onTap: () {},
    );
  }
}
