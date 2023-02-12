// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import '../controller/connector.dart';
import '../models/print_response.dart';

class RequestHandler extends ChangeNotifier {
  late HttpServer _server;

  late String ip;
  late int port;
  late bool _running;
  late void Function(PrintResponse) onPrintMessage;
  late void Function(bool) onServerStatusChanged;
  late void Function() onServerError;

  final Connector _connector = Connector();
  final List<WebSocket> _sockets = [];

  bool get running => _running;

  final List<Map<String, String>> _devicesList = [];
  List<Map<String, String>> get devicesList => _devicesList;

  RequestHandler() {
    ip = 'localhost';
    port = 12000;
    _running = false;
    onPrintMessage = (_) {};
    onServerError = () {};
    onServerStatusChanged = (_) {};
  }

  Future<void> startServer() async {
    try {
      _server = await HttpServer.bind(ip, 12000);
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
      print(_devicesList);
      // Device Info

      handleSocketMessages(socket, clientInfo);
    } else if ((request.uri.path == '/api')) {
      print('Api alcanzada');
      var body = await utf8.decodeStream(request);
      _connector.runPrintJob(body, onPrintMessage);

      request.response.write('{"data":"datum}');
      request.response.close();
    } else {
      request.response.statusCode = HttpStatus.notFound;
      request.response.close();
    }
  }

  void handleSocketMessages(WebSocket socket, Map<String, String> clientInfo) {
    socket.listen(
      (message) {
        _connector.runPrintJob(message, onPrintMessage);
        socket.add('You sent: $message');
      },
      onDone: () => removeClient(clientInfo, socket),
      onError: handleSocketError,
      cancelOnError: true,
    );
  }

  void handleSocketError(err) {
    print(err);
    onServerError();
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
      socket.close().then(
            (value) => print('Socket closed by server'),
          );
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
      print('Error en el Server');
      onServerError();
    }
  }
}
