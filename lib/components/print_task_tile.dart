
import 'package:flutter/material.dart';

import '../models/print_response.dart';
import '../models/results.dart';
import '../screens/detail_screen.dart';

class PrintTaskTile extends StatelessWidget {
  final PrintTask printTask;
  const PrintTaskTile(this.printTask, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return printTask.printResult == PrintResult.success
        ? ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: ((context) => DetailScreen(printTask: printTask)),
                ),
              );
            },
            leading: const Icon(
              Icons.print,
              color: Color.fromARGB(255, 41, 145, 44),
            ),
            title: Text(printTask.friendlyType!,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(printTask.printerName ??
                printTask.printerAlias ??
                'Impresora?'),
          )
        : printTask.printResult == PrintResult.withWarnings
            ? ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: ((context) =>
                          DetailScreen(printTask: printTask)),
                    ),
                  );
                },
                leading: const Icon(
                  Icons.print,
                  color: Color.fromARGB(255, 185, 141, 20),
                ),
                title: Text(printTask.friendlyType!,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(printTask.printerName ??
                    printTask.printerAlias ??
                    'Impresora?'),
              )
            : ListTile(
                leading: const Icon(
                  Icons.print,
                  color: Color.fromARGB(255, 219, 24, 10),
                ),
                title: Wrap(
                  spacing: 10,
                  children: <Widget>[
                    Text(
                        printTask.friendlyType ??
                            printTask.commandType ??
                            printTask.printerName ??
                            printTask.printerAlias ??
                            '',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    ...printTask.messages.map((e) => Text(
                          e.title,
                        ))
                  ],
                ),
                subtitle: Text(printTask.printerName ??
                    printTask.printerAlias ??
                    'Impresora?'),
                trailing:
                    printTask.printErrors.contains(PrintError.connectionError)
                        ? IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.replay_outlined),
                          )
                        : null);
  }
}
