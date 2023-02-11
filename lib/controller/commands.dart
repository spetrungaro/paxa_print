import 'package:esc_pos_utils/esc_pos_utils.dart';

import 'escpos/driver/network_printer.dart';

Map<String, dynamic> printTexto(
    NetworkPrinter printer, Map<String, dynamic>? command) {
  printer.text("text", styles: const PosStyles.defaults());
  return {};
}

void printRemito() {}
void printTicket() {}
void printPedido() {}
void printComanda() {}
