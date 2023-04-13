import 'package:base_repository/repository/domain/model/dto.dart';
import 'package:flutter/foundation.dart';

abstract class DTOWithLocalIdentifier<Identifier> extends DTO {
  abstract final Identifier localId;
}
