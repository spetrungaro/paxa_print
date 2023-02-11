import 'dart:convert';

import '../models/command.dart';
import '../models/print_response.dart';
import '../models/results.dart';

class TranslationException implements Exception {
  PrintResponse response;
  TranslationException(this.response);
}

class Connector {
  Map<String, dynamic> _jsonToPrintCommand(String json) {
    //
    Map<String, dynamic> printMessage = {};
    try {
      printMessage = jsonDecode(json);
      return printMessage;
    } catch (_) {
      throw TranslationException(
        PrintResponse(
          printResult: PrintResult.badJsonFormat,
        ),
      );
    }
  }

  String _getPrinterAlias(Map printMessage) {
    final String? printerAlias = printMessage.remove('printerName');

    if (printerAlias == null) {
      throw TranslationException(
        PrintResponse(
          command: PrintCommand(_getCommandType(printMessage, null)),
          printResult: PrintResult.noPrinterInJson,
        ),
      );
    }

    return printerAlias;
  }

  String _getCommandType(Map printMessage, String? printerName) {
    String? commandType;
    try {
      commandType = printMessage.keys.first;
      if (commandType == null) throw Exception;
    } catch (_) {
      throw TranslationException(
        PrintResponse(
          printerName: printerName,
          printResult: PrintResult.noCommand,
        ),
      );
    }

    return commandType;
  }

  PrintCommand _getCommand(
    Map printMessage,
    String commandType,
    String printerName,
  ) {
    Map<String, dynamic>? command;
    try {
      var parseCommand = printMessage[commandType];
      if (parseCommand is! Map<String, dynamic>) throw Exception();
      command = parseCommand;
    } catch (e) {
      throw TranslationException(
        PrintResponse(
          printerName: printerName,
          command: PrintCommand(commandType, printerAlias: printerName),
          printResult: PrintResult.badCommand,
        ),
      );
    }

    var printCommand =
        PrintCommand(commandType, printerAlias: printerName, command: command);

    return printCommand;
  }

  Future<void> runPrintJob(String json, Function(PrintResponse) action) async {
    try {
      var res = _jsonToPrintCommand(json);
      var printerAlias = _getPrinterAlias(res);
      var commandType = _getCommandType(res, printerAlias);
      if (!commandType.contains('print')) {
        throw TranslationException(
          PrintResponse(
              printerName: printerAlias,
              printResult: PrintResult.noSuchAction,
              command: PrintCommand(commandType, printerAlias: printerAlias)),
        );
      }
      var printerName = printerAlias;
      var command = _getCommand(res, commandType, printerName);
      var response = PrintResponse(
        rawRequest: json,
        printResult: PrintResult.success,
        command: command,
        printerName: printerName,
      );
      print(response);
      action(response);
    } catch (e) {
      if (e is TranslationException) {
        var response = e.response..rawRequest = json;
        print(response);
        action(response);
      } else if (e is TypeError) {
        print('Otra: $e');
      } else if (e is FormatException) {
        print(e);
      } else {
        print('LPM');
      }
    }
  }
}
