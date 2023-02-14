import '../utils/message_setter.dart';
import '../utils/uuid_assignment.dart';
import 'response_message.dart';
import 'results.dart';

class PrintTask {
  Map<String, dynamic>? command;
  String? commandType;
  String? printerName;
  String? printerAlias;
  String? rawRequest;
  PrintResult printResult = PrintResult.withErrors;
  String id = UuidAssignment.v4();
  final List<PrintError> printErrors = [];

  String? get friendlyType {
    if (commandType == null) return null;
    var replaced = commandType!.replaceFirst('print', '');
    if (replaced == 'openDrawer') return 'Abrir Cajón';
    final beforeNonLeadingCapitalLetter = RegExp(r"(?=(?!^)[A-Z])");
    List<String> splitPascalCase(String input) =>
        input.split(beforeNonLeadingCapitalLetter);
    return splitPascalCase(replaced).join(' ');
  }

  bool get success => printResult == PrintResult.success;
  Map get details => {
        'printer': [printerAlias, printerName],
        'command': [commandType, friendlyType],
      };
  List<PrintResponseMessage> get messages =>
      setResponseMessages(printErrors, details);
}
