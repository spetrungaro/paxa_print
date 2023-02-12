// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'api/request_handler.dart';
import 'components/menu_drawer.dart';
import 'components/notification_snack_bar.dart';
import 'components/print_response_card.dart';
import 'models/print_response.dart';
import 'utils/ip_finder.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final List<PrintResponse> printResponses = [];
  final List<String> clients = [];
  final printersBox = Hive.box('printers');

  RequestHandler handler = RequestHandler();

  String ip = 'localhost';
  int port = 12000;
  bool _running = false;

  @override
  void initState() {
    print('Init');
    getIP().then((value) {
      setState(() {
        ip = value;
        handler.ip = value;
        handler.port = port;
        handler.onPrintMessage = handlePrintMessage;
        handler.onServerError = handleServerError;
        handler.onServerStatusChanged = handleServerStatus;
        // handler.onClientUpdate = handleClientUpdate;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('building');
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text('IP: $ip'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (!_running) {
            handler.startServer();
            ScaffoldMessenger.of(context).showSnackBar(
              notificationSnackBar('Servidor iniciado'),
            );
          } else {
            handler.closeServer().then((value) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(notificationSnackBar('Servidor detenido!'));
            });
          }
        },
        backgroundColor: _running ? Colors.red : Colors.green,
        child: Icon(_running ? Icons.close_rounded : Icons.play_arrow_rounded,
            size: 32),
      ),
      drawer: MenuDrawer(handler),
      body: Center(
        child: ListView(
          children: <Widget>[
            ...printResponses.reversed.map((e) => PrintResponseCard(e)),
          ],
        ),
      ),
    );
  }

  Future<void> _addPrintResult(PrintResponse newResponse) async {
    setState(() {
      printResponses.add(newResponse);
    });
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
    _addPrintResult(response);
  }

  // void handleClientUpdate() {
  //   ScaffoldMessenger.of(context)
  //       .showSnackBar(notificationSnackBar('Nuevo dispositivo conectado!'));
  // }
}
