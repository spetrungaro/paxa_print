import '../../models/printer.dart';
import '../../models/results.dart';
import '../driver_interface.dart';

class FiscalberryDriver implements IPrinterDriver {
  @override
  PrintResult printCommand(Printer printer, Map<String, dynamic> command) {
    return PrintResult.success;
  }
}
