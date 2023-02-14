import '../../models/printer.dart';
import '../../models/results.dart';
import '../interfaces/driver_interface.dart';

class FiscalberryDriver implements IPrinterDriver {
  @override
  Future<PrintResult> printCommand(
      Printer printer, String commandType, Map<String, dynamic> command) async {
    return PrintResult.success;
  }
}
