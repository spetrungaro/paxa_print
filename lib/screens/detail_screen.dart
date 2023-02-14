import 'package:flutter/material.dart';

import '../models/print_response.dart';

class DetailScreen extends StatelessWidget {
  // In the constructor, require a Todo.
  const DetailScreen({super.key, required this.printTask});

  // Declare a field that holds the Todo.
  final PrintTask printTask;

  @override
  Widget build(BuildContext context) {
    // Use the Todo to create the UI.
    return Scaffold(
      appBar: AppBar(
        title: Text(printTask.id),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(printTask.commandType ?? 'Nada por aqui'),
      ),
    );
  }
}
