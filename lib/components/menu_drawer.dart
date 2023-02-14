import 'package:flutter/material.dart';

import '../api/request_handler.dart';
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
            // onTap: () {
            //   if (_running) {
            //     handler.closeServer().then((value) {
            //       RestartWidget.restartApp(context);
            //     });
            //   } else {
            //     RestartWidget.restartApp(context);
            //   }
            // },
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
          Expanded(
            child: Align(
              alignment: FractionalOffset.bottomCenter,
              child: ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Configuración'),
                subtitle: Text('Configure sus impresoras',
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
