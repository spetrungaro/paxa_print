import '../models/command.dart';
import '../models/response_message.dart';
import '../models/results.dart';

PrintResponseMessage setResponseMessage(
    PrintResult result, PrintCommand? command) {
  switch (result) {
    case PrintResult.success:
      return PrintResponseMessage(
          title: 'Se imprimió con éxito',
          subtitle: 'Si no fue así, revisa el papel');
    case PrintResult.connectionError:
      return PrintResponseMessage(
          title: 'Error de conexión con la impresora',
          subtitle: 'No se pudo imprimir porque se rechazó la conexión',
          comments: 'Controlá que la misma esté bien conectada'
              ' o que la configuracion sea la correcta.');
    case PrintResult.printerNotExist:
      return PrintResponseMessage(
          title: 'Impresora no configurada',
          subtitle: 'No se encontró ninguna impresora con ese nombre',
          comments: 'Recorda que el Alias y el Nombre distinguen mayúsculas');
    case PrintResult.badJsonFormat:
      return PrintResponseMessage(
          title: 'Mensaje indescifrable',
          subtitle:
              'Se recibió un mensaje de impresión, pero no pudo ser procesado');
    case PrintResult.badCommand:
      return PrintResponseMessage(
          title: 'inválido/a',
          subtitle: 'Se encontraron errores que no permiten imprimir',
          comments: 'Puede que en el/la ${command?.friendlyType} falten datos'
              ' importantes y por eso no se contunuó con la impresión');
    case PrintResult.noSuchAction:
      return PrintResponseMessage(
          title: '${command?.commandType} -> No existe la acción');
    case PrintResult.printerError:
      return PrintResponseMessage(title: 'Error impresora');
    case PrintResult.other:
      return PrintResponseMessage(title: 'Error desconocido');
    case PrintResult.noPrinterInJson:
      return PrintResponseMessage(title: 'No hay impresora en el JSON');
    case PrintResult.noCommand:
      return PrintResponseMessage(
          title: 'No hay comando de impresion en el JSON');
  }
}
