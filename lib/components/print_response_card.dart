import 'package:flutter/material.dart';

import '../models/print_response.dart';
import '../models/results.dart';
import '../screens/detail_screen.dart';

class PrintResponseCard extends StatelessWidget {
  final PrintResponse printResponse;
  const PrintResponseCard(this.printResponse, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      key: Key(printResponse.id),
      elevation: 0,
      borderOnForeground: true,
      color: Colors.grey.shade300,
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: Column(
        children: printResponse.printResult == PrintResult.success
            ? <Widget>[
                ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: ((context) =>
                            DetailScreen(printResponse: printResponse)),
                      ),
                    );
                  },
                  leading: const Icon(
                    Icons.print,
                    color: Colors.green,
                  ),
                  title: Text(printResponse.command!.friendlyType!,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(printResponse.printerName!),
                ),
              ]
            : [
                ListTile(
                  leading: const Icon(
                    Icons.print,
                    color: Colors.red,
                  ),
                  title: printResponse.command?.friendlyType == null
                      ? Text(
                          printResponse.message.title,
                          style: const TextStyle(color: Colors.red),
                        )
                      : Row(
                          children: <Widget>[
                            Text(
                              printResponse.printResult !=
                                      PrintResult.noSuchAction
                                  ? '${printResponse.command!.friendlyType}  '
                                  : '',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              printResponse.message.title,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                  subtitle: Text(printResponse.printerName ?? 'Impresora?'),
                  trailing:
                      printResponse.printResult == PrintResult.connectionError
                          ? IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.replay_outlined),
                            )
                          : null,
                ),
              ],
      ),
    );
  }
}
