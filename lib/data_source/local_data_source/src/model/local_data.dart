import 'package:data_source/dto/dto.dart';

abstract class DTOWithLocalIdentifier<Identifier> extends DTO {
  abstract final Identifier localId;
}
