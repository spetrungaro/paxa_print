// ignore_for_file: avoid_print

import '../models/printer.dart';
import 'network_analyzer.dart';

class NetworkScanner {
  static Future<List<Printer>> _scanPort(String ip, int port,
      {int timeout = 5}) async {
    final String subnet = ip.substring(0, ip.lastIndexOf('.'));
    final stream = NetworkAnalyzer.discover2(
      subnet,
      port,
      timeout: Duration(milliseconds: timeout * 1000),
    );
    List<Printer> foundPrinters = [];

    await stream.listen((NetworkAddress addr) {
      if (addr.exists) {
        foundPrinters.add(Printer(host: addr.ip, port: port));
      }
    }).asFuture();
    return foundPrinters;
  }

  static Future<List<Printer>> scanCommonPorts(String ip,
      {int timeout = 5}) async {
    List<int> ports = [6001, 6100, 9100];
    List<Printer> foundPrinters = [];

    for (int port in ports) {
      List<Printer> newPrinters = await _scanPort(ip, port);
      foundPrinters.addAll(newPrinters);
    }
    return foundPrinters;
  }

  static Future<bool> scanSpecificPrinter(String ip, int port) async {
    final printer = await NetworkAnalyzer.discoverOnly(ip, port);
    return printer.exists;
  }
}
