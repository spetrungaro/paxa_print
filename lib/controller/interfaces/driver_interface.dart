import '../../models/printer.dart';
import '../../models/results.dart';

abstract class IPrinterDriver {
  Future<PrintResult> printCommand(
      Printer printer, String commandType, Map<String, dynamic> command);
}
