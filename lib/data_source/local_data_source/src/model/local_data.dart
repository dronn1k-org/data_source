import 'package:data_source/dto/dto.dart';

abstract interface class DTOWithLocalIdentifier<Identifier> implements DTO {
  abstract final Identifier localId;
}
