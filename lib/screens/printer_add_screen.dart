import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:paxa_print/utils/uuid_assignment.dart';

class PrinterAddScreen extends StatefulWidget {
  final dynamic onCreate;
  const PrinterAddScreen(this.onCreate, {super.key});

  @override
  State<PrinterAddScreen> createState() => _PrinterAddScreenState();
}

class _PrinterAddScreenState extends State<PrinterAddScreen> {
  String? alias;
  String? name;
  String? ip;
  int? port = 9100;
  String driver = 'ReceiptDirectJet';
  String uuid = UuidAssignment.v4();

  Box printersBox = Hive.box('printers');

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    print(uuid);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.search),
        onPressed: () {},
      ),
      appBar: AppBar(actions: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          child: ElevatedButton(
            style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.green)),
            child: const Text('Agregar'),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                var printerInfo = {
                  'name': name,
                  'alias': alias,
                  'port': port,
                  'ip': ip,
                  'driver': driver
                };
                widget.onCreate(uuid, printerInfo);

                Navigator.pop(context);
              }
            },
          ),
        )
      ]),
      body: Form(
          key: _formKey,
          child: Padding(
            padding:
                const EdgeInsets.only(top: 0, left: 10, right: 10, bottom: 200),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.only(bottom: 40),
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
                  onChanged: (value) => ip = value,
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
                      }
                    }),
              ],
            ),
          )),
    );
  }
}
