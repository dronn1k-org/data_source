import 'package:base_repository/dto/dto.dart';

abstract class DTOWithLocalIdentifier<Identifier> extends DTO {
  abstract final Identifier localId;
}
