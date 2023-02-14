enum PrintResult { success, withWarnings, withErrors }

enum PrintError {
  badJsonFormat,
  noPrinterInJson,
  printerNotExist,
  noCommand,
  badCommand,
  noSuchAction,
  noDriver,
  connectionError,
  printerError,
  didNotPrint,
  unhandledError
}
