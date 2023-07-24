import 'package:data_source/dto/dto.dart';

abstract interface class LocalEntity implements DTO {
  abstract final String localId;
  const LocalEntity();
}
