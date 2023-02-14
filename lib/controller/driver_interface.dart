import '../models/printer.dart';
import '../models/results.dart';

abstract class IPrinterDriver {
  PrintResult printCommand(Printer printer, Map<String, dynamic> command);
}
