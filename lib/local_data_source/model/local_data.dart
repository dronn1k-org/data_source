import 'package:base_repository/interface/dto.dart';
import 'package:flutter/foundation.dart';

abstract class DTOWithLocalIdentifier<IdentifierType> extends DTO {
  final IdentifierType localId;

  @mustCallSuper
  const DTOWithLocalIdentifier({
    required this.localId,
  });
}
