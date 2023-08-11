import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:comando_interface/comando_interface.dart';

import 'package:Traductores/TraductorFiscalberry.dart';

class PrinterException implements Exception {
}

class FiscalberryComandos implements ComandoInterface {
  String traductorModule = "Traductores.TraductorFiscalberry";
  static const String DEFAULT_DRIVER = "Fiscalberry";

  Future<dynamic> _sendCommand(String comando, {bool skipStatusErrors = false}) async {
    try {
      var ret = await this.conector.sendCommand(comando, skipStatusErrors);
      return ret;
    } on PrinterException catch (e) {
      Logger("ProxyComandos").error("PrinterException: ${e.toString()}");
      throw ComandoException("Error de la impresora: ${e.toString()}.\nComando enviado: $comando");
    }
  }
}

/*If the function has a declared return type, then update the type to be Future<T>, 
where T is the type of the value that the function returns. If the function doesn’t 
explicitly return a value, then the return type is Future<void>:

Now that you have an async function, you can use the await keyword to wait for a future
to complete:

As the following two examples show, the async and await keywords result in asynchronous 
code that looks a lot like synchronous code. The only differences are highlighted in the 
asynchronous example, which—if your window is wide enough—is to the right of the 
synchronous example. */