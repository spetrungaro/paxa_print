import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../models/printer.dart';
import '../../models/results.dart';
import '../driver_interface.dart';
import 'driver/enums.dart';
import 'driver/network_printer.dart';
import 'errors.dart';

class ReceiptDirectJetDriver implements IPrinterDriver {
  @override
  PrintResult printCommand(Printer printer, Map<String, dynamic> command) {
    return PrintResult.success;
  }

  Future<NetworkPrinter> getPrinter(String ip,
      {int port = 9100, PaperSize paperSize = PaperSize.mm80}) async {
    final PaperSize paper = paperSize;
    final profile = await CapabilityProfile.load();
    final printer = NetworkPrinter(paper, profile);
    final int timeout = Hive.box('config').get('timeout') ?? 3;

    final PosPrintResult res = await printer.connect(ip,
        port: port, timeout: Duration(seconds: timeout));

    if (res == PosPrintResult.success) {
      return printer;
    } else {
      throw PrinterConnectionError(res);
    }
  }
}
