import 'package:flutter/material.dart';

import '../api/request_handler.dart';
import '../components/device_tile.dart';

class DevicesScreen extends StatefulWidget {
  final RequestHandler handler;
  const DevicesScreen(this.handler, {super.key});

  @override
  State<DevicesScreen> createState() => _DevicesScreenState();
}

class _DevicesScreenState extends State<DevicesScreen> {
  List<Map<String, String>> clients = [];
  late RequestHandler handler;
  @override
  void initState() {
    handler = widget.handler;
    clients = handler.devicesList;
    handler.addListener(() => mounted ? setState(() {}) : null);
    super.initState();
  }

  @override
  void dispose() {
    handler.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dispositivos'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.lightGreen,
        child: const Icon(
          Icons.refresh,
          size: 32,
        ),
      ),
      body: ListView(
          children: ListTile.divideTiles(
              context: context,
              color: Colors.grey.shade300,
              tiles: [
            ...clients.map(
              (value) => DeviceTile(value),
            ),
          ]).toList()),
    );
  }
}
