import '../models/response_message.dart';
import '../models/results.dart';

List<PrintResponseMessage> setResponseMessages(
    List<PrintError> errors, Map details) {
  final List<PrintResponseMessage> messages = [];
  for (PrintError error in errors) {
    switch (error) {
      case PrintError.connectionError:
        messages.add(PrintResponseMessage(
            title: 'Error de conexión con la impresora',
            subtitle: 'No se pudo imprimir porque se rechazó la conexión',
            comments: 'Controlá que la misma esté bien conectada'
                ' o que la configuracion sea la correcta.'));
        break;
      case PrintError.printerNotExist:
        messages.add(PrintResponseMessage(
            title: 'Impresora no configurada '
                '(${details['printer'][0] ?? details['printer'][1]})',
            subtitle: 'No se encontró ninguna impresora con ese alias/nombre',
            comments:
                'Recorda que el Alias y el Nombre distinguen mayúsculas'));
        break;
      case PrintError.badJsonFormat:
        messages.add(PrintResponseMessage(
            title: 'Mensaje indescifrable',
            subtitle:
                'Se recibió un mensaje de impresión, pero no pudo ser procesado'));
        break;
      case PrintError.badCommand:
        messages.add(PrintResponseMessage(
            title:
                '${details['command'][1] ?? details['command'][0]} inválido/a',
            subtitle: 'Se encontraron errores que no permiten imprimir',
            comments: 'Puede que en el/la '
                '${details['command'][1] ?? details['command'][0]} falten datos'
                ' importantes y por eso no se contunuó con la impresión'));
        break;
      case PrintError.noSuchAction:
        messages.add(PrintResponseMessage(
            title: '${details['command'][1]} -> No existe la acción'));
        break;
      case PrintError.printerError:
        messages.add(PrintResponseMessage(title: 'Error impresora'));
        break;
      case PrintError.unhandledError:
        messages.add(PrintResponseMessage(title: 'Error desconocido'));
        break;
      case PrintError.noPrinterInJson:
        messages
            .add(PrintResponseMessage(title: 'No hay impresora en el JSON'));
        break;
      case PrintError.noCommand:
        messages.add(PrintResponseMessage(
            title: 'No hay comando de impresión en el JSON'));
        break;
      case PrintError.noDriver:
        messages.add(PrintResponseMessage(title: 'No hay Driver'));
        break;
      case PrintError.didNotPrint:
        messages.add(PrintResponseMessage(title: 'No imprimió'));
        break;
    }
  }
  return messages;
}
