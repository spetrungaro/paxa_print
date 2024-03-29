import 'package:flutter/material.dart';

import 'api/request_handler.dart';
import 'components/menu_drawer.dart';
import 'components/notification_snack_bar.dart';
import 'components/print_task_tile.dart';
import 'controller/connector.dart';
import 'models/print_response.dart';
import 'utils/ip_finder.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final List<PrintTask> printTasks = [];
  final List<String> clients = [];

  RequestHandler handler = RequestHandler();
  Connector connector = Connector();

  String ip = 'localhost';
  int port = 12000;
  bool _running = false;

  @override
  void initState() {
    getIP().then((value) {
      setState(() {
        ip = value;
        connector.onPrintMessage = handlePrintMessage;
        handler.connector = connector;
        handler.ip = value;
        handler.port = port;
        handler.onServerError = handleServerError;
        handler.onServerStatusChanged = handleServerStatus;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
        child: Icon(_running ? Icons.stop_rounded : Icons.play_arrow_rounded,
            size: 32),
      ),
      drawer: MenuDrawer(handler),
      body: Center(
          child: printTasks.isNotEmpty
              ? ListView(
                  children: ListTile.divideTiles(
                      context: context,
                      color: Colors.grey.shade300,
                      tiles: [
                        ...printTasks.reversed
                            .map((printTask) => PrintTaskTile(printTask)),
                      ]).toList(),
                )
              : const Text(
                  'Aún no hay impresiones',
                  style: TextStyle(fontWeight: FontWeight.w300, fontSize: 20),
                )),
    );
  }

  Future<void> _addPrintResult(PrintTask newResponse) async {
    if (mounted) {
      setState(() {
        printTasks.add(newResponse);
      });
    }
  }

  void handleServerStatus(bool status) {
    if (mounted) {
      setState(() {
        _running = status;
      });
    }
  }

  void handleServerError() {
    print('error');
  }

  void handlePrintMessage(PrintTask response) {
    _addPrintResult(response);
  }

  // void handleClientUpdate() {
  //   ScaffoldMessenger.of(context)
  //       .showSnackBar(notificationSnackBar('Nuevo dispositivo conectado!'));
  // }
}
