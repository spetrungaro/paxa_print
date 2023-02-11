import 'package:flutter/material.dart';

void infoDialog(BuildContext context) {
  showAboutDialog(
      context: context,
      applicationIcon: const FlutterLogo(),
      applicationName: 'Fiscalberry App',
      applicationVersion: '0.1.0b',
      children: <Widget>[
        const Text(
          "Servidor de impresión Paxapos\n",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        const Text(
            "Este servicio le permite imprimir en los dispositivos de su comercio.\n"),
        const Text(
          "No lo cierre",
          style: TextStyle(
              color: Color.fromARGB(255, 156, 10, 10),
              fontWeight: FontWeight.bold),
        ),
      ]);
}
