import 'commands.dart';
import 'driver/network_printer.dart';

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
      "default": printTexto
    };
  }

  Function(NetworkPrinter, Map<String, dynamic>) getCommand(
      String commandType) {
    return receiptDirectJetCommands()[commandType] ??
        receiptDirectJetCommands()["default"]!;
  }
}
