import 'escpos/commands.dart';
import 'escpos/driver/network_printer.dart';

class ReceiptDirectJetTranslator {
  Map<String, Function(NetworkPrinter, Map<String, dynamic>)>
      receiptDirectJetCommands() {
    return {
      "printTexto": printTexto,
      "printPedido": printPedido,
      "printComanda": printComanda,
      "printRemito": printRemito,
      "printRemitoCorto": printRemitoCorto,
      "printFacturaElectronica": printFacturaElectronica,
      "printArqueo": printArqueo,
      "openDrawer": openDrawer,
    };
  }
}

class BluetoothTranslator {}

class FiscalberryTranslator {}
