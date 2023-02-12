import 'package:flutter/material.dart';

class DeviceTile extends StatelessWidget {
  final Map<String, String> value;
  const DeviceTile(this.value, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
        child: Row(
          children: [
            Text(
              value['address']?.split(':')[0] ?? 'Desconocido',
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
            ),
            Text(
              ' (${value['address']?.split(':')[1] ?? 'Desconocido'})',
              style: const TextStyle(fontSize: 13),
            ),
          ],
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        child: Text(value['type'] ?? 'Desconocido'),
      ),
      leading: Icon(value['type'] == 'desktop'
          ? Icons.desktop_windows
          : value['type'] == 'mobile'
              ? Icons.phone_android
              : Icons.question_mark),
      trailing: const Icon(
        Icons.radio_button_checked,
        color: Colors.green,
      ),
      onTap: () {},
    );
  }
}
