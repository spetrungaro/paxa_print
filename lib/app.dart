// ignore_for_file: avoid_print

import 'package:flutter/material.dart';

import 'api/request_handler.dart';
import 'components/info_dialog.dart';
import 'components/print_response_card.dart';
import 'models/print_response.dart';
import 'utils/ip_finder.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final List<PrintResponse> _printResponses = [];

  RequestHandler handler = RequestHandler();

  String _ip = 'localhost';
  int port = 12000;
  bool _running = false;

  @override
  void initState() {
    getIP().then((value) {
      setState(() {
        _ip = value;
      });
      handler.ip = value;
      handler.port = port;
      handler.onPrintMessage = handlePrintMessage;
      handler.onServerError = handleServerError;
      handler.onServerStatusChanged = handleServerStatus;
    });
    super.initState();
  }

  void handleServerStatus(bool status) {
    setState(() {
      _running = status;
    });
  }

  void handleServerError() {
    print('error');
  }

  void handlePrintMessage(PrintResponse response) {
    print('Mensaje');
    _addPrintResult(response);
  }

  @override
  Widget build(BuildContext context) {
    print('building');
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text('IP: $_ip'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: !_running ? handler.startServer : handler.closeServer,
        backgroundColor: _running ? Colors.red : Colors.green,
        child: Icon(_running ? Icons.close_rounded : Icons.play_arrow_rounded,
            size: 32),
      ),
      drawer: Drawer(
        elevation: 50,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: Column(
                children: const [
                  Image(
                    image: AssetImage('assets/icons/plogo.png'),
                    height: 80,
                  ),
                  Spacer(),
                  Text(
                    'Fiscalberry',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.devices),
              title: const Text('Dispositivos'),
              subtitle: Text(
                'Quiénes están conectados',
                textScaleFactor: .9,
                style: TextStyle(color: Colors.grey.shade400),
              ),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.text_snippet_outlined),
              title: const Text('Documentos'),
              subtitle: Text(
                'Consulte los últimos comprobantes',
                textScaleFactor: .9,
                style: TextStyle(color: Colors.grey.shade400),
              ),
              onTap: () => Navigator.pop(context),
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
              subtitle: Text('Configure sus impresoras',
                  textScaleFactor: .9,
                  style: TextStyle(color: Colors.grey.shade400)),
              leading: const Icon(Icons.settings),
              title: const Text('Configuración'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
      body: Center(
        child: ListView(
          children: <Widget>[
            ..._printResponses.reversed.map((e) => PrintResponseCard(e))
          ],
        ),
      ),
    );
  }

  Future<void> _addPrintResult(PrintResponse newResponse) async {
    setState(() {
      _printResponses.add(newResponse);
    });
  }
}
