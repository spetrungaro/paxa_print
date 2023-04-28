import 'package:flutter/material.dart';

import '../api/request_handler.dart';
import '../main.dart';
import '../screens/devices_screen.dart';
import '../screens/printers_screen.dart';
import 'info_dialog.dart';

class MenuDrawer extends StatelessWidget {
  final RequestHandler handler;
  const MenuDrawer(this.handler, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          DrawerHeader(
            margin: EdgeInsets.zero,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: Column(
              children: [
                const Image(
                  image: AssetImage('assets/icons/plogo.png'),
                  height: 90,
                ),
                const Spacer(),
                Text(
                  'Fiscalberry',
                  style: TextStyle(color: Colors.grey.shade400, fontSize: 24),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.print),
            title: const Text('Impresoras'),
            subtitle: Text('Configure o agregue impresoras',
                textScaleFactor: .9,
                style: TextStyle(color: Colors.grey.shade400)),
            onTap: () {
              // Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: ((context) => const PrintersScreen()),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.devices),
            title: const Text('Dispositivos'),
            subtitle: Text(
              'Quiénes están conectados',
              textScaleFactor: .9,
              style: TextStyle(color: Colors.grey.shade400),
            ),
            onTap: () {
              // Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: ((context) => DevicesScreen(handler)),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.text_snippet_outlined),
            title: const Text('Documentos'),
            subtitle: Text(
              'Consulte los últimos comprobantes',
              textScaleFactor: .9,
              style: TextStyle(color: Colors.grey.shade400),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.announcement_rounded),
            title: const Text('Info'),
            subtitle: Text(
              'Acerca de Fiscalberry',
              textScaleFactor: .9,
              style: TextStyle(color: Colors.grey.shade400),
            ),
            onTap: () {
              Navigator.pop(context);
              infoDialog(context);
            },
          ),
          ListTile(
            tileColor: const Color.fromARGB(255, 252, 237, 239),
            leading: Icon(
              Icons.refresh_rounded,
              color: Colors.red.shade900,
            ),
            title: Text(
              'Reiniciar Servidor',
              style: TextStyle(color: Colors.red.shade900),
            ),
            subtitle: Text(
              'En caso de haber cambiado los ajustes',
              textScaleFactor: .9,
              style: TextStyle(color: Colors.grey.shade400),
            ),
            onTap: () {
              if (handler.running) {
                handler.closeServer().then((value) {
                  RestartWidget.restartApp(context);
                });
              } else {
                RestartWidget.restartApp(context);
              }
            },
          ),
          Expanded(
            child: Align(
              alignment: FractionalOffset.bottomCenter,
              child: ListTile(
                leading: const Icon(Icons.settings),
                isThreeLine: true,
                title: const Text('Configuración'),
                subtitle: Text('Configure las opciones del servidor',
                    textScaleFactor: .9,
                    style: TextStyle(color: Colors.grey.shade400)),
                onTap: () {
                  // Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: ((context) => const PrintersScreen()),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
