import '../utils/message_setter.dart';
import '../utils/uuid_assignment.dart';
import 'command.dart';
import 'response_message.dart';
import 'results.dart';

class PrintResponse {
  PrintCommand? command;
  String? printerName;
  String? rawRequest;
  PrintResult printResult;
  late String id;
  late bool success;
  late PrintResponseMessage message;

  PrintResponse(
      {this.command,
      this.printerName,
      required this.printResult,
      this.rawRequest}) {
    id = UuidAssignment.v4();
    success = printResult == PrintResult.success;
    message = setResponseMessage(printResult, command);
  }

  @override
  String toString() {
    return '$command | $printerName | $printResult | $id | $success | $rawRequest';
  }
}
