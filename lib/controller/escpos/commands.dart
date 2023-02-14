import 'package:esc_pos_utils/esc_pos_utils.dart';

import 'driver/network_printer.dart';

void printTexto(NetworkPrinter printer, Map<String, dynamic>? command) {
  printer.text("text", styles: const PosStyles.defaults());
  printer.disconnect();
  return;
}

void printPedido(NetworkPrinter printer, Map<String, dynamic>? command) {
  return;
}

void printComanda(NetworkPrinter printer, Map<String, dynamic>? command) {
  return;
}

void printRemitoCorto(NetworkPrinter printer, Map<String, dynamic>? command) {
  return;
}

void printRemito(NetworkPrinter printer, Map<String, dynamic>? command) {
  return;
}

void printFacturaElectronica(
    NetworkPrinter printer, Map<String, dynamic>? command) {
  return;
}

void printArqueo(NetworkPrinter printer, Map<String, dynamic>? command) {
  return;
}

void openDrawer(NetworkPrinter printer, Map<String, dynamic>? command) {
  return;
}
