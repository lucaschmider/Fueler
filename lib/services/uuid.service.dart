import 'package:uuid/uuid.dart';

class UuidService {
  final Uuid _uuid = Uuid();
  String newUuid() => _uuid.v4();
}

UuidService uuidService = UuidService();
