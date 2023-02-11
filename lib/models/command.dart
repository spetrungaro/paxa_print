class PrintCommandException implements Exception {
  final dynamic message;

  PrintCommandException([this.message]);
}

class PrintCommand {
  String commandType;
  String? printerAlias;
  Map<String, dynamic> command;
  bool status = false;

  String? get friendlyType {
    // if (!commandType.contains('print')) return null;
    var replaced = commandType.replaceFirst('print', '');
    final beforeNonLeadingCapitalLetter = RegExp(r"(?=(?!^)[A-Z])");
    List<String> splitPascalCase(String input) =>
        input.split(beforeNonLeadingCapitalLetter);
    return splitPascalCase(replaced).join(' ');
  }

  PrintCommand(this.commandType, {this.printerAlias, this.command = const {}});

  @override
  String toString() {
    return '[ $printerAlias > $commandType ] => $command';
  }
}
