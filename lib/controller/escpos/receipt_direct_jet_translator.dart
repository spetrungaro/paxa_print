import '../../models/printer.dart';
import 'commands.dart';
import 'driver/network_printer.dart';

class ReceiptDirectJetTranslator {
  ReceiptDirectJetCommands commands = ReceiptDirectJetCommands();
  Map<String, Function(NetworkPrinter, Printer, Map<String, dynamic>)>
      receiptDirectJetCommands = {};
  ReceiptDirectJetTranslator() {
    receiptDirectJetCommands = {
      "printTexto": commands.printTexto,
      "printPedido": commands.printPedido,
      "printComanda": commands.printComanda,
      "printRemito": commands.printRemito,
      "printRemitoCorto": commands.printRemitoCorto,
      "printFacturaElectronica": commands.printFacturaElectronica,
      "printArqueo": commands.printArqueo,
      "openDrawer": commands.openDrawer
    };
  }

  Function(NetworkPrinter, Printer, Map<String, dynamic>) getCommand(
      String commandType) {
    var command = receiptDirectJetCommands[commandType];
    if (command != null) return command;
    throw Exception;
  }
}
