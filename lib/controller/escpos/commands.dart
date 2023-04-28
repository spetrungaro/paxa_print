import 'package:esc_pos_utils/esc_pos_utils.dart';

import '../../models/printer.dart';
import 'constants.dart';
import 'driver/network_printer.dart';

class ReceiptDirectJetCommands {
  int totalCols = 42;
  int priceCols = 12;
  int cantCols = 6;
  int get desCols => totalCols - cantCols - priceCols;
  int get descColsExt => totalCols - priceCols;
  String symbol = '\$';

  String _pad(String text, int size, String fill, String side) {
    if (side.toLowerCase() == 'r') {
      return text
          .substring(0, size < text.length ? size : null)
          .padLeft(size, fill);
    } else if (side.toLowerCase() == 'l') {
      return text
          .substring(0, size < text.length ? size : null)
          .padRight(size, fill);
    } else {
      return text
          .substring(0, size < text.length ? size : null)
          .padLeft((size - (size - text.length) / 2).floor(), fill)
          .padRight((totalCols - cantCols - priceCols).ceil(), fill);
    }
  }

  void printTexto(NetworkPrinter printer, Printer printerInfo,
      Map<String, dynamic> command) {
    printer.text(command['text']);
    printer.cut();
    return;
  }

  void printPedido(NetworkPrinter printer, Printer printerInfo,
      Map<String, dynamic>? command) {
    return;
  }

  void printComanda(NetworkPrinter printer, Printer printerInfo,
      Map<String, dynamic>? command) {
    return;
  }

  void printRemito(NetworkPrinter printer, Printer printerInfo,
      Map<String, dynamic>? command) {
    totalCols = printerInfo.cols;
    if (command == null) return;
    Map encabezado = command['encabezado'];
    List items = command['items'];
    List pagos = command['pagos'];
    Map? addAdditional = command['addAdditional'];

    if (encabezado['imprimir_fecha_remito'] != null) {
      var fecha = DateTime.now();
      printer.text(
          '${fecha.day}/${fecha.month.toString().padLeft(2, '0')}/${fecha.year}'
          ' ${fecha.hour.toString().padLeft(2, '0')}'
          ':${fecha.minute.toString().padLeft(2, '0')}', maxCharsPerLine: totalCols,
          styles: CENTER_A_A_1_1);
      print('${fecha.day}/${fecha.month.toString().padLeft(2, '0')}/${fecha.year}'
          ' ${fecha.hour.toString().padLeft(2, '0')}'
          ':${fecha.minute.toString().padLeft(2, '0')}');
    }
    printer.text("Verifique su cuenta por favor\n", maxCharsPerLine: totalCols, styles: CENTER_A_A_1_1);
    print("Verifique su cuenta por favor\n");
    printer.text("NO VALIDO COMO FACTURA\n\n", maxCharsPerLine: totalCols, styles: CENTER_A_A_1_1);
    print("NO VALIDO COMO FACTURA\n\n");

    if (encabezado['nombre_cliente'] != null) {
      printer.text('\n${encabezado['nombre_cliente']}', maxCharsPerLine: totalCols, styles: CENTER_A_A_1_2);
      print('\n${encabezado['nombre_cliente']}');
      if (encabezado['telefono'] != null) {
        printer.text('\n${encabezado['telefono']}', maxCharsPerLine: totalCols, styles: CENTER_A_A_1_2);
        print('\n${encabezado['telefono']}');
      }
      if (encabezado['domicilio_cliente'] != null) {
        printer.text('\n${encabezado['domicilio_cliente']}', maxCharsPerLine: totalCols, styles: CENTER_A_A_1_2);
        print('\n${encabezado['domicilio_cliente']}');
      }
      printer.text('\n', maxCharsPerLine: totalCols, styles: CENTER_A_A_1_2);
      print('\n');
    }
    var cantHeader = _pad('CANT', cantCols, ' ', 'l');
    var dsCentrador = ' ' * (priceCols - cantCols);
    var dsHeader = _pad('${dsCentrador}DESCRIPCION', desCols, ' ', 'c');
    var precioHeader = _pad('PRECIO', priceCols, ' ', 'r');
    printer.text('$cantHeader$dsHeader$precioHeader', maxCharsPerLine: totalCols,
          styles: CENTER_A_A_1_1);
    print('$cantHeader$dsHeader$precioHeader');
    printer.text('\n', maxCharsPerLine: totalCols,
          styles: CENTER_A_A_1_1);
    print('\n');
    double importeSubTotal = 0.0;

    for (Map item in items) {
      dynamic qty;
      if (item['qty'] is String) {
        qty = int.parse(item['qty']);
      } else {
        qty = item['qty'];
      }
      double importe = (item['importe'] as int).toDouble();
      String ds = item['ds'] ?? '';
      double total = qty * importe;
      String itemCant = qty.toString();
      String totalProducto = (qty * importe).toStringAsFixed(2);
      String cantTxt = _pad(itemCant, cantCols, ' ', 'l');
      String dsTxt = _pad(ds, desCols, ' ', 'l');
      String totalTxt = _pad(totalProducto, priceCols, ' ', 'r');

      printer.text('$cantTxt$dsTxt$totalTxt', maxCharsPerLine: totalCols, styles: LEFT_A_A_1_1);
      print('$cantTxt$dsTxt$totalTxt');
      importeSubTotal += total;
    }
    printer.text('\n', maxCharsPerLine: totalCols, styles: LEFT_A_A_1_1);
    print('\n');

    var importeTotal = importeSubTotal;

    if (addAdditional != null) {
      double sAmount = (addAdditional['amount'] as int).toDouble();
      String descuentoDesc =
          addAdditional['description'].toString().substring(0, descColsExt - 2);
      // bool negative = addAdditional['negative'] ?? true;
      sAmount = -sAmount;
      importeTotal += sAmount;
      String dsSubtotal = _pad("SUBTOTAL:", descColsExt - 1, " ", "l");
      String importeSubTotalTxt =
          _pad(importeSubTotal.toStringAsFixed(2), priceCols, ' ', 'r');
      String dsDescuento = _pad(descuentoDesc, descColsExt - 1, ' ', 'l');
      String importeDescuento =
          _pad(sAmount.toStringAsFixed(2), priceCols, ' ', 'r');

      printer.text('$dsSubtotal$symbol$importeSubTotalTxt',
          styles: LEFT_A_B_1_1);

      printer.text('$dsDescuento$symbol$importeDescuento',
          styles: LEFT_A_A_1_1);
    }

    var dsTotal = _pad('TOTAL:', descColsExt - 1, ' ', 'l');
    var importeTotalTxt =
        _pad(importeTotal.toStringAsFixed(2), priceCols, ' ', 'r');

    printer.text('$dsTotal$symbol$importeTotalTxt', styles: LEFT_A_B_1_2, maxCharsPerLine: totalCols);
    print('$dsTotal$symbol$importeTotalTxt');

    printer.cut(mode: PosCutMode.partial);
  }

  void printRemitoCorto(NetworkPrinter printer, Printer printerInfo,
      Map<String, dynamic>? command) {
    return;
  }

  void printFacturaElectronica(NetworkPrinter printer, Printer printerInfo,
      Map<String, dynamic>? command) {
    return;
  }

  void printArqueo(NetworkPrinter printer, Printer printerInfo,
      Map<String, dynamic>? command) {
    return;
  }

  void openDrawer(NetworkPrinter printer, Printer printerInfo,
      Map<String, dynamic>? command) {
    printer.drawer();
    return;
  }
}
