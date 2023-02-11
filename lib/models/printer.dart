import '../utils/uuid_assignment.dart';

class Printer {
  final String ipAddress;
  final int port;
  final String id;
  final String name;
  final String alias;
  final int cols;

  Printer(
      {this.ipAddress = '192.168.0.33',
      this.port = 9100,
      this.name = 'no-name',
      this.alias = 'no-alias',
      this.cols = 42})
      : id = UuidAssignment.v4();

  @override
  String toString() {
    return 'NOMBRE: $name | ALIAS: $alias | COLS: $cols |'
        ' IP: $ipAddress | PORT: ${port.toString()} | UUID: $id';
  }
}
