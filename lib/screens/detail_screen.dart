import 'package:flutter/material.dart';

import '../models/print_response.dart';

class DetailScreen extends StatelessWidget {
  // In the constructor, require a Todo.
  const DetailScreen({super.key, required this.printResponse});

  // Declare a field that holds the Todo.
  final PrintResponse printResponse;

  @override
  Widget build(BuildContext context) {
    // Use the Todo to create the UI.
    return Scaffold(
      appBar: AppBar(
        title: Text(printResponse.id),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(printResponse.command?.commandType ?? 'Nada por aqui'),
      ),
    );
  }
}
