import 'package:base_repository/interface/dto.dart';
import 'package:uuid/uuid.dart';

abstract class LocalData extends DTO {
  final String uuid;

  LocalData({
    String? uuid,
  }) : uuid = uuid ?? const Uuid().v4();
}
