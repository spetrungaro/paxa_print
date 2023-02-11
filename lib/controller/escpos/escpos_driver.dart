import 'package:esc_pos_utils/esc_pos_utils.dart';

import 'driver/enums.dart';
import 'driver/network_printer.dart';
import 'errors.dart';

class EscPosDriver {
  static Future<NetworkPrinter> getPrinter(String ip, {int port = 9100}) async {
    const PaperSize paper = PaperSize.mm80;
    final profile = await CapabilityProfile.load();
    final printer = NetworkPrinter(paper, profile);

    final PosPrintResult res = await printer.connect(ip, port: port);

    if (res == PosPrintResult.success) {
      return printer;
    } else {
      throw PrinterConnectionError(res);
    }
  }
}
