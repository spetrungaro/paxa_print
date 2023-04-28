import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/printer.dart';

class PrinterEditScreen extends StatefulWidget {
  final Printer printer;
  final dynamic onUpdate;
  final dynamic onDelete;
  const PrinterEditScreen(this.printer, this.onUpdate, this.onDelete,
      {super.key});

  @override
  State<PrinterEditScreen> createState() => _PrinterEditScreenState();
}

class _PrinterEditScreenState extends State<PrinterEditScreen> {
  String? alias;
  String? name;
  String? host;
  int? port;
  String? driver;
  int? cols;
  String? proxyPrinterName;
  late String prevAlias;

  Box printersBox = Hive.box('printers');

  final _formKey = GlobalKey<FormState>();
  bool enableCols = false;
  bool enablePrintername = false;

  @override
  void initState() {
    super.initState();
    alias = widget.printer.alias;
    prevAlias = widget.printer.alias;
    name = widget.printer.name;
    host = widget.printer.host;
    port = widget.printer.port;
    driver = widget.printer.driver;
    cols = widget.printer.cols;
    proxyPrinterName = widget.printer.proxyPrinterName;
    enableCols = driver == 'ReceiptDirectJet';
    enablePrintername = driver == 'Fiscalberry';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            var printerInfo = {
              'name': name,
              'port': port,
              'host': host,
              'driver': driver,
              'marca': driver == 'Fiscalberry' ? 'Fiscalberry' : 'EscP',
              'cols': cols,
              'printerName': proxyPrinterName,
            };
            widget.onUpdate(alias, printerInfo);
            if (prevAlias != alias && widget.onDelete != null) {
              widget.onDelete(prevAlias);
            }

            Navigator.pop(context);
          }
        },
        child: const Icon(
          Icons.check_rounded,
          size: 32,
        ),
      ),
      appBar: AppBar(
        title: Text('Editando impresora "${widget.printer.name}"'),
        centerTitle: true,
      ),
      body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.only(top: 0, left: 10, right: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.only(bottom: 20, top: 20),
                  child: Text(
                    'Ingrese la configuración',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                TextFormField(
                  initialValue: name,
                  decoration: const InputDecoration(label: Text('Nombre')),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Debe completar este campo';
                    }
                    return null;
                  },
                  onChanged: (value) => name = value,
                ),
                TextFormField(
                  initialValue: alias,
                  decoration: const InputDecoration(label: Text('Alias')),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Debe completar este campo';
                    }
                    return null;
                  },
                  onChanged: (value) => alias = value,
                ),
                TextFormField(
                  initialValue: host,
                  decoration: const InputDecoration(label: Text('IP')),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Debe completar este campo';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    if (value == 'EscP') {}
                    host = value;
                  },
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  initialValue: port.toString(),
                  decoration: const InputDecoration(label: Text('Puerto')),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Debe completar este campo';
                    } else if (int.tryParse(value) == null) {
                      return 'Solo puede ingresar números';
                    }
                    return null;
                  },
                  onChanged: (value) => port = int.tryParse(value),
                ),
                DropdownButtonFormField(
                    value: driver,
                    decoration: const InputDecoration(label: Text('Driver')),
                    items: const [
                      DropdownMenuItem<String>(
                        value: 'ReceiptDirectJet',
                        child: Text('Comandera'),
                      ),
                      DropdownMenuItem<String>(
                        value: 'Fiscalberry',
                        child: Text('Proxy'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        driver = value;
                        if (value == 'Fiscalberry') {
                          enablePrintername = true;
                          enableCols = false;
                          setState(() {});
                        } else {
                          enablePrintername = false;
                          enableCols = true;
                          setState(() {});
                        }
                      } else {
                        enablePrintername = false;
                        enableCols = false;
                      }
                    }),
                enableCols && !enablePrintername
                    ? TextFormField(
                        keyboardType: TextInputType.number,
                        initialValue: cols.toString(),
                        decoration:
                            const InputDecoration(label: Text('Columnas')),
                        validator: (value) {
                          if (value == null) {
                            return null;
                          }
                          if (int.tryParse(value) == null) {
                            return 'Solo puede ingresar números';
                          }
                          return null;
                        },
                        onChanged: (value) => cols = int.tryParse(value),
                      )
                    : enablePrintername && !enableCols
                        ? TextFormField(
                            keyboardType: TextInputType.number,
                            initialValue: proxyPrinterName,
                            decoration: const InputDecoration(
                                label: Text('Proxy printerName')),
                            validator: (value) {
                              if (value == null) {
                                return 'Ingrese un valor';
                              }
                              return null;
                            },
                            onChanged: (value) => proxyPrinterName = value,
                          )
                        : const SizedBox.shrink(),
              ],
            ),
          )),
    );
  }
}
