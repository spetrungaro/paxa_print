import 'package:uuid/uuid.dart' show Uuid;

class UuidAssignment {
  static const uuid = Uuid();

  static String v4({bool shortened = true}) {
    String assignedUuid = uuid.v4();
    if (!shortened) return assignedUuid;
    return assignedUuid.substring(24);
  }
}
