import 'escpos/receipt_direct_jet_driver.dart';
import 'fiscalberry/fiscalberry_proxy_driver.dart';
import 'interfaces/driver_interface.dart';

class DriverHandler {
  Map<String, IPrinterDriver> availableDrivers = {
    'ReceiptDirectJet': ReceiptDirectJetDriver(),
    'Fiscalberry': FiscalberryDriver(),
  };
  IPrinterDriver getPrinterDriver(String driverName) {
    final driver = availableDrivers[driverName];
    if (driver == null) throw Exception();
    return driver;
  }
}
