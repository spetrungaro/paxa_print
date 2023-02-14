import 'package:hive_flutter/hive_flutter.dart';

class ActualConfig {
  late Map<String, dynamic> server;
  late Map<dynamic, dynamic> _printers;
  late Map<dynamic, dynamic> _actualConfig;

  ActualConfig() {
    var server = Hive.box('config').get('SERVIDOR');
    server = {
      "puerto": server['puerto'],
      "ip_privada": server['ip_privada'],
      "uuid": server['uuid'],
      "discover_url": server['discover_url'],
    };
    _printers = Hive.box('printers').toMap();
    _actualConfig = {"SERVIDOR": server};
    _actualConfig.addAll(_printers);
  }

  Map get actualConfig => {
        "rta": {"action": "getActualConfig", "rta": _actualConfig}
      };

  Map get getAvailablePrinters {
    var printerNames = _printers.keys.toList();
    return {
      "rta": {"action": "getAvailablePrinters", "rta": printerNames}
    };
  }
}
