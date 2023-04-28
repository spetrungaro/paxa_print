import 'dart:convert';

import 'package:http/http.dart';

import '../../models/printer.dart';
import '../../models/results.dart';
import '../interfaces/driver_interface.dart';

class FiscalberryDriver implements IPrinterDriver {
  @override
  Future<PrintResult> printCommand(
      Printer printer, String commandType, Map<String, dynamic> command) async {
    try {
      var response = await post(
          Uri.parse('http://${printer.host}:${printer.port}/api'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            commandType: command,
            'printerName': printer.proxyPrinterName ?? printer.alias
          }));
      if (response.statusCode == 200) return PrintResult.success;
      return PrintResult.withWarnings;
    } on Exception catch (e) {
      print(e);
      rethrow;
    }
  }
}
