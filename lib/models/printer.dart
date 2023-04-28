class Printer {
  late String host;
  late int port;
  late String name;
  late String alias;
  late int cols;
  late String driver;
  late String? proxyPrinterName;

  Printer(
      {this.host = '192.168.0.253',
      this.port = 9100,
      this.name = 'unknown',
      this.proxyPrinterName,
      this.alias = 'unknown',
      this.driver = 'ReceiptDirectJet',
      this.cols = 42});

  Printer.fromMap(Map<String, dynamic> printerMap) {
    alias = printerMap.keys.single.toString();
    final printerConfig = printerMap[alias];
    host = printerConfig['host'] ?? '192.168.0.253';
    port = printerConfig['port'] ?? 9100;
    name = printerConfig['name'] ?? 'unknown';
    cols = printerConfig['cols'] ?? 42;
    driver = printerConfig['driver'] ?? 'ReceiptDirectJet';
    proxyPrinterName = printerConfig['printerName'];
  }

  Map<String, dynamic> toMap() {
    var printerInfo = {
      'name': name,
      'port': port,
      'host': host,
      'driver': driver,
      'marca': driver == 'Fiscalberry' ? 'Fiscalberry' : 'EscP',
      'cols': cols,
      'printerName': proxyPrinterName,
    };
    return printerInfo;
  }
}
