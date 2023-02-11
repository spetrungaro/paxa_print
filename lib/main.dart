// ignore_for_file: avoid_print
import 'dart:io';

import 'package:flutter/foundation.dart'
    show kIsWeb, defaultTargetPlatform, TargetPlatform;
import 'package:flutter/material.dart';
import 'package:flutter_background/flutter_background.dart';

import 'components/info_dialog.dart';
import 'components/print_response_card.dart';
import 'controller/connector.dart';
import 'models/print_response.dart';

void main() async {
  runApp(
    MaterialApp(
      theme: ThemeData(
        colorSchemeSeed: const Color.fromARGB(248, 9, 28, 201),
      ),
      debugShowCheckedModeBanner: false,
      title: 'Fiscalberry - Paxapos',
      home: const App(),
    ),
  );
  print('started');

  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
    const config = FlutterBackgroundAndroidConfig(
      notificationTitle: 'Fiscalberry Background',
      notificationText: "Texto explicando que hace",
      enableWifiLock: true,
      showBadge: true,
      shouldRequestBatteryOptimizationsOff: true,
    );

    var hasPermissions = await FlutterBackground.hasPermissions;
    print(hasPermissions.toString());
    hasPermissions = await FlutterBackground.initialize(androidConfig: config);
    print(hasPermissions.toString());
    if (hasPermissions) {
      final backgroundExecution =
          await FlutterBackground.enableBackgroundExecution();
      print(backgroundExecution.toString());
    }
  } else {
    print('No need for permissions');
    print(defaultTargetPlatform.name);
  }
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final List<PrintResponse> _printResponses = [];

  HttpServer? _server;
  List<WebSocket> sockets = [];
  NetworkInterface? _ip;
  String _noIp = 'IP Unknown';
  bool _running = false;

  Connector connector = Connector();

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb && _ip == null) {
      print('Not Web');
      getIP();
    } else if (_noIp != 'Browser') {
      setState(() {
        _noIp = 'Browser';
      });
    }
    print('building');
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text('IP: ${_ip != null ? _ip!.addresses[0].address : _noIp}'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _running ? _closeServer : _startServer,
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

  Future<void> _closeServer() async {
    // await _server?.close(force: true);
    await _server?.close(force: true);
    _server = null;
    for (var sock in sockets) {
      sock.close();
    }
    setState(() {
      _running = false;
    });
  }

  Future<void> _addPrintResult(PrintResponse newResponse) async {
    setState(() {
      _printResponses.add(newResponse);
    });
  }

  Future<void> _startServer() async {
    _server = await HttpServer.bind(_ip!.addresses[0].address, 12000);
    print('Listening on ${_ip!.addresses[0].address}:${_server?.port}');
    setState(() {
      _running = true;
    });
    await for (HttpRequest request in _server!) {
      if (request.uri.path == '/ws') {
        // Upgrade an HttpRequest to a WebSocket connection
        var socket = await WebSocketTransformer.upgrade(request);
        setState(() {
          sockets.add(socket);
        });

        print(sockets.length);
        print(
            'Client connected! ${request.connectionInfo?.remoteAddress.address}');

        // Listen for incoming messages from the client
        socket.listen((message) {
          print('Received message: $message');
          connector.runPrintJob(message, _addPrintResult);
          socket.add('You sent: $message');
        }, onDone: () {
          print('Me fui');
          setState(() {
            sockets.remove(socket);
          });
        }, cancelOnError: true, onError: (err) => {print(err)});
      } else {
        request.response.statusCode = HttpStatus.forbidden;
        request.response.close();
      }
    }
  }

  void getIP() async {
    await NetworkInterface.list(
            includeLinkLocal: false,
            includeLoopback: false,
            type: InternetAddressType.IPv4)
        .then((value) {
      setState(() {
        _ip = value.first;
      });
    });
  }
}
