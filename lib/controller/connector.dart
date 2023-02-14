import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

import '../models/build_actual_config.dart';
import '../models/print_response.dart';
import '../models/printer.dart';
import '../models/results.dart';
import 'driver_handler.dart';
import 'driver_interface.dart';
import 'escpos/errors.dart';

class Connector {
  late void Function(PrintTask) onPrintMessage;
  DriverHandler driverHandler = DriverHandler();

  Future<dynamic> runPrintJob(String json) async {
    PrintTask printTask = PrintTask();
    String driverName;
    IPrinterDriver? driver;
    Printer? printerMap;
    ActualConfig actualConfig = ActualConfig();

    try {
      var printers = Hive.box('printers');
      // var printersObject
      printTask.rawRequest = json;
      printTask = _jsonToPrintCommand(printTask);
      printTask = _getPrinterAlias(printTask);
      printTask = _getCommandType(printTask);
      if (printTask.commandType == 'getActualConfig') {
        return jsonEncode(actualConfig.actualConfig);
      } else if (printTask.commandType == 'getAvailablePrinters') {
        return jsonEncode(actualConfig.getAvailablePrinters);
      }

      var printer = printers.get(printTask.printerAlias);
      if (printer == null) {
        printTask.printErrors.add(PrintError.printerNotExist);
      } else {
        printTask.printerName = printer['name'];
        driverName = printer['driver'];
        driver = driverHandler.getPrinterDriver(driverName);
        printerMap = Printer.fromMap({printTask.printerAlias!: printer});
      }
      if (printTask.commandType != null) {
        printTask = _getCommand(printTask);
      }
      if (driver == null) {
        printTask.printErrors.add(PrintError.noDriver);
      } else if (printTask.printErrors.isEmpty && printTask.command != null) {
        printTask.printResult =
            driver.printCommand(printerMap!, printTask.command!);
      }
    } catch (e) {
      if (e is PrinterConnectionError) {
        printTask.printErrors.add(PrintError.connectionError);
      } else {
        printTask.printErrors.add(PrintError.unhandledError);
      }
      printTask.printResult = PrintResult.withErrors;
    }
    onPrintMessage(printTask);
    return printTask;
  }

  PrintTask _jsonToPrintCommand(PrintTask task) {
    //
    try {
      task.command = jsonDecode(task.rawRequest!);
      return task;
    } catch (_) {
      task.printErrors.add(PrintError.badJsonFormat);
      return task;
    }
  }

  PrintTask _getPrinterAlias(PrintTask task) {
    String? printerAlias = task.command?.remove('printerName');
    task.printerAlias = printerAlias;

    if (printerAlias == null) {
      task.printErrors.add(PrintError.noPrinterInJson);
    }
    return task;
  }

  PrintTask _getCommandType(PrintTask task) {
    String? commandType;
    try {
      commandType = task.command?.keys.first;
      if (commandType == null) {
        task.printErrors.add(PrintError.noCommand);
      }
      task.commandType = commandType;
    } catch (_) {
      task.commandType = commandType;
      task.printErrors.add(PrintError.noCommand);
    }

    return task;
  }

  PrintTask _getCommand(PrintTask task) {
    try {
      task.command = task.command?[task.commandType];
      return task;
    } catch (e) {
      if (task.commandType == 'openDrawer') {
        task.command = {'drawer': task.command};
        return task;
      }
      task.printErrors.add(PrintError.badCommand);
      return task;
    }
  }
}
