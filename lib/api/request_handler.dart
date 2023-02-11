// ignore_for_file: avoid_print

import 'dart:io';

import '../controller/connector.dart';
import '../models/print_response.dart';
// import 'server_errors.dart';

class RequestHandler {
  late HttpServer _server;

  late String ip;
  late int port;
  late bool _running;
  late void Function(PrintResponse) onPrintMessage;
  late void Function(bool) onServerStatusChanged;
  late void Function() onServerError;

  final Connector _connector = Connector();
  final List<WebSocket> _sockets = [];
  final List<String> _clients = [];

  bool get running => _running;

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
      var clientAddress =
          request.connectionInfo?.remoteAddress.address ?? 'desconocido';
      var clientPort = request.connectionInfo?.remotePort ?? 'desconocido';
      var clientInfo = '$clientAddress:$clientPort';
      _sockets.add(socket);
      _clients.add(clientInfo);

      print('Client: $clientInfo');
      print(_clients);

      handleSocketMessages(socket, clientInfo);
    } else {
      request.response.statusCode = HttpStatus.forbidden;
      request.response.close();
    }
  }

  void handleSocketMessages(WebSocket socket, String clientInfo) {
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

  void removeClient(String clientInfo, WebSocket socket) {
    print('Client $clientInfo disconnected');
    _sockets.remove(socket);
    _clients.remove(clientInfo);
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
