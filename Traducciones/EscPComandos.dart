import 'dart:developer';
import 'package:ComandoInterface.dart';
import 'package:ComandoException.dart';
import 'package:EscPConstants.dart';
import 'package:datetime.dart' as datetime;
import 'dart:math' as math;
import 'dart:convert';

String floatToString(dynamic inputValue) {
  if (!(inputValue is double)) {
    inputValue = double.parse(inputValue);
  }
  return inputValue.toStringAsFixed(2).replaceAll(RegExp(r'0*$'), '').replaceAll(RegExp(r'\.$'), '');
}

String pad(dynamic texto, int size, String relleno, {String float = 'l'}) {
  String text = texto.toString();
  if (float.toLowerCase() == 'l') {
    return text.substring(0, size).padRight(size, relleno);
  } else {
    return text.substring(0, size).padLeft(size, relleno);
  }
}

class PrinterException implements Exception {}

class EscPComandos implements ComandoInterface {
  static const String traductorModule = "Traductores.TraductorReceipt";
  static const String DEFAULT_DRIVER = "ReceipDirectJet";
  dynamic __preFillTrailer;

  EscPComandos();

  @override
  void sendCommand(String comando, {bool skipStatusErrors = false}) {
    try {
      dynamic ret = conector.sendCommand(comando, skipStatusErrors);
      return ret;
    } on PrinterException catch (e) {
      log("PrinterException: ${e.toString()}");
      throw ComandoException("Error de la impresora: ${e.toString()}. Comando enviado: $comando");
    }
  }

  void printTexto(String texto) {
    dynamic printer = conector.driver;
    printer.start();
    printer.text(texto);
    printer.cut(PARTIAL_CUT);
    printer.end();
  }

  void printMuestra() {
    dynamic printer = conector.driver;
    printer.start();
    List<int> firstLetter = [FONT_B, FONT_A];
    List<int> secondLetter = [NORMAL, BOLD];
    int iteration = 0;
    for (int j = 1; j < 3; j++) {
      for (int i = 1; i < 3; i++) {
        for (int second in secondLetter) {
          for (int first in firstLetter) {
            printer.set(CENTER, first, second, i, j);
            printer.text("\n");
            printer.text("$iteration CENTER, $first, $second, $i, $j");
            printer.text("\n");
            iteration++;
          }
        }
      }
    }
    printer.cut(PARTIAL_CUT);
    printer.end();
  }

  void print_mesa_mozo(dynamic setTrailer) {
    for (dynamic key in setTrailer) {
      doble_alto_x_linea(key);
    }
  }
}

void openDrawer() {
  var printer = self.conector.driver;
  printer.start();
  printer.cashdraw(2);
  printer.end();
}

// def printPedido(self, **kwargs):

void printPedido() {
  var printer = self.conector.driver;

  var encabezado = kwargs["encabezado"];
  var items = kwargs["items"];

  printer.start();

  printer.set(CENTER, FONT_A, NORMAL, 1, 1);

  if (encabezado.containsKey("es_pedido")) {
    printer.text("Nuevo Pedido\n");
  } else {
    printer.text("Nueva OC\n");
  }
  printer.set(LEFT, FONT_A, NORMAL, 1, 1);
  var fecha = DateFormat('HH:mm yy/MM/dd').format(DateTime.now());
  if (encabezado != null) {
    if (encabezado.containsKey("nombre_proveedor")) {
      printer.text("Proveedor: " + encabezado["nombre_proveedor"]);
      printer.text("\n");
    }
    if (encabezado.containsKey("cuit") && encabezado["cuit"].length > 1) {
      printer.text("CUIT: " + encabezado["cuit"]);
      printer.text("\n");
    }
    if (encabezado.containsKey("telefono") && encabezado["telefono"].length > 1) {
      printer.text("Telefono: " + encabezado["telefono"]);
      printer.text("\n");
    }
    if (encabezado.containsKey("email") && encabezado["email"].length > 1) {
      printer.text("E-mail: " + encabezado["email"]);
    }
    printer.text("\n");
    if (encabezado.containsKey("pedido_recepcionado")) {
      if (encabezado["pedido_recepcionado"] == 1) {
        printer.text("Esta orden de compra ya ha sido recepcionada\n");
      }
    }
  }
  printer.text("Fecha: $fecha\n");

  printer.text("CANT\tDESCRIPCIÓN\n");
  printer.text("\n");
  var total_cols = 40;

  for (var item in items) {
    printer.set(LEFT, FONT_A, NORMAL, 1, 1);
    var desc = item["ds"].substring(0, 24);
    var cant = double.parse(item["qty"]);
    var unidad_de_medida = item["unidad_de_medida"];
    var observacion = item["observacion"];
    var cant_tabs = 3;
    var can_tabs_final = cant_tabs - (desc.length / 8).ceil();
    var strTabs = desc.padRight(desc.length + can_tabs_final, '\t');

    printer.text("${cant.toStringAsFixed(2)} $unidad_de_medida $strTabs\n");

    if (observacion != null) {
      printer.set(LEFT, FONT_B, BOLD, 1, 1);
      printer.text("OBS: $observacion\n");
    }
  }
  printer.text("\n");

  var barcode = kwargs["barcode"];
  if (barcode != null) {
    printer.barcode(barcode.toString().padLeft(8, "0"), 'EAN13');
  }

  printer.set(CENTER, FONT_A, BOLD, 2, 2);

  printer.cut(PARTIAL_CUT);
}
