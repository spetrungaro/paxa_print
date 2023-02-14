// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../controller/connector.dart';
import '../models/print_response.dart';
import '../utils/uuid_assignment.dart';

class RequestHandler extends ChangeNotifier {
  late HttpServer _server;
  late Connector connector;

  late String ip;
  late int port;
  late bool _running;
  late void Function(bool) onServerStatusChanged;
  late void Function() onServerError;

  final List<WebSocket> _sockets = [];

  bool get running => _running;

  final List<Map<String, String>> _devicesList = [];
  List<Map<String, String>> get devicesList => _devicesList;

  RequestHandler() {
    ip = 'localhost';
    port = 12000;
    _running = false;
    onServerError = () {};
    onServerStatusChanged = (_) {};
  }

  Future<void> _discover() async {
    var server = Hive.box('config').get('SERVIDOR');
    var printers = Hive.box('printers').values;
    if (server == null) {
      var newServer = {
        'uuid': UuidAssignment.v4(),
        'puerto': port,
        'ip_privada': ip,
        'discover_url': 'https://www.paxapos.com/discover.json',
      };
      await Hive.box('config').put('SERVIDOR', newServer);
    }
    // throw Exception;
  }

  Future<void> startServer() async {
    try {
      await _discover();
      _server = await HttpServer.bind(ip, port);
      _running = true;
      onServerStatusChanged(_running);
      print('Listening on ${_server.address.address}:${_server.port}');
      await for (HttpRequest request in _server) {
        await handleSocketConnection(request);
      }
    } catch (e) {
      onServerError();
    }
  }

  Future<void> handleSocketConnection(HttpRequest request) async {
    if (request.uri.path == '/ws') {
      var socket = await WebSocketTransformer.upgrade(request);
      // Device Info
      var clientIp =
          request.connectionInfo?.remoteAddress.address ?? 'desconocido';
      var clientPort = request.connectionInfo?.remotePort ?? 'desconocido';
      var clientAddress = '$clientIp:$clientPort';

      String deviceType;
      var isMobile = request.headers['user-agent']?.first.contains('Mobile');
      if (isMobile == null) {
        deviceType = 'unknown';
      } else if (isMobile == true) {
        deviceType = 'mobile';
      } else {
        deviceType = 'desktop';
      }
      var clientInfo = {'address': clientAddress, 'type': deviceType};
      addClient(clientInfo, socket);
      // Device Info

      handleSocketMessages(socket, clientInfo);
    } else {
      request.response.statusCode = HttpStatus.notFound;
      request.response.close();
    }
  }

  void handleSocketMessages(WebSocket socket, Map<String, String> clientInfo) {
    socket.listen(
      (message) {
        var res = connector.runPrintJob(message);
        res.then((value) {
          if (value is String) {
            socket.add(value);
          } else if (value is PrintTask) {
            Map<String, dynamic> res = {
              "rta": {
                "action": value.commandType,
                "rta": value.printResult.name,
              }
            };
            if (value.printErrors.isNotEmpty) {
              var messages = value.messages.map((e) => e.title).toList();
              res['errors'] = messages;
            }
            var rta = jsonEncode(res);
            socket.add(rta);
          }
        });
      },
      onDone: () => removeClient(clientInfo, socket),
      onError: handleSocketError,
      cancelOnError: true,
    );
  }

  void handleSocketError(err) {
    onServerError();
    closeServer();
  }

  void removeClient(Map<String, String> clientInfo, WebSocket socket) {
    _devicesList.remove(clientInfo);
    _sockets.remove(socket);

    notifyListeners();
  }

  void addClient(Map<String, String> clientInfo, WebSocket socket) {
    _devicesList.add(clientInfo);
    _sockets.add(socket);

    notifyListeners();
  }

  void closeAllConnections() {
    for (var socket in _sockets) {
      socket.close();
    }
  }

  Future<void> closeServer() async {
    try {
      _server.close(force: true).then((value) {
        closeAllConnections();
        _running = false;
        onServerStatusChanged(_running);
      });
    } catch (e) {
      onServerError();
    }
  }
}
