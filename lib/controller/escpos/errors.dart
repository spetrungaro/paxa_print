import 'driver/enums.dart';

class PrinterConnectionError extends Error {
  final PosPrintResult message;

  PrinterConnectionError(this.message);
}
