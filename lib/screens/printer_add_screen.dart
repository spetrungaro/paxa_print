import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class PrinterAddScreen extends StatefulWidget {
  final dynamic onCreate;
  const PrinterAddScreen(this.onCreate, {super.key});

  @override
  State<PrinterAddScreen> createState() => _PrinterAddScreenState();
}

class _PrinterAddScreenState extends State<PrinterAddScreen> {
  String? alias;
  String? name;
  String? host;
  int? port = 9100;
  String driver = 'ReceiptDirectJet';
  int? cols = 42;
  String? proxyPrinterName;

  Box printersBox = Hive.box('printers');

  final _formKey = GlobalKey<FormState>();
  final _driverKey = GlobalKey<FormFieldState>();
  bool enableCols = false;
  bool enablePrintername = false;
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
            widget.onCreate(alias, printerInfo);

            Navigator.pop(context);
          }
        },
        child: const Icon(
          Icons.check_rounded,
          size: 32,
        ),
      ),
      appBar: AppBar(
        title: const Text('Agregar impresora'),
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
                  initialValue: '9100',
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
                    key: _driverKey,
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
                        initialValue: '42',
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
                            initialValue: '',
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
